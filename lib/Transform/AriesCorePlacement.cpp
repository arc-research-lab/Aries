#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Builders.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Analysis/Liveness.h"
#include "mlir/Dialect/Affine/Utils.h"
#include "mlir/Dialect/Affine/LoopUtils.h"
#include "mlir/Dialect/Affine/Analysis/LoopAnalysis.h"
#include "llvm/Support/Debug.h"
#include "aries/Transform/Passes.h"
#include "aries/Transform/Utils.h"
#include "aries/Dialect/ADF/ADFDialect.h"

using namespace mlir;
using namespace aries;
using namespace adf;
using namespace mlir::memref;
using namespace mlir::func;
using namespace mlir::affine;

namespace {

struct AriesCorePlacement : public AriesCorePlacementBase<AriesCorePlacement> {
public:
  AriesCorePlacement() = default;
  AriesCorePlacement(const AriesOptions &opts) {
    ColNum=opts.OptColNum;
    RowNum=opts.OptRowNum;
    ColOffset=opts.OptColOffset;
    RowOffset=opts.OptRowOffset;
    ColGap = opts.OptColGap;
    CoreAlgo=opts.OptCoreAlgo;
    EnablePL = opts.OptEnablePL;
    EnableAIE2 = opts.OptEnableAIE2;
  }
  void runOnOperation() override {
    auto mod = dyn_cast<ModuleOp>(getOperation());
    
    if(!EnablePL && EnableAIE2){
      if (!NPUCorePlacement(mod))
        signalPassFailure();
    }else{
      if (!CorePlacement(mod))
        signalPassFailure();
    }
    
  }

private:
  // All the place algorithm here follows the logic below:
  // pid =  (3d cell -> 1d serialization)
  // Height = The number of rows utilized in this placement
  // col = pid % Height
  // row = floor (pid/Height)

  // In this algorithm, the reduction dim is consecutive vertically
  bool placementNaive0(OpBuilder builder, FuncOp func, 
                       const unsigned colNum, const unsigned rowNum, 
                       unsigned colOffset, unsigned rowOffset,
                       unsigned KSize, unsigned JSize, unsigned ISize){
    auto indexType = builder.getIndexType();
    unsigned rowStart = rowOffset;
    // Determine the height and formula for pid
    unsigned realRowNum = rowNum - rowStart;
    unsigned height= std::min(KSize, realRowNum);
    unsigned flag;
    if(KSize<=realRowNum){
      if(realRowNum%KSize==0)
        height= realRowNum;
      if(ISize < JSize){
        flag = 0;
      }else{
        flag = 1;
      }
    }else{
      if(ISize < JSize){
        flag = 2;
      }else{
        flag = 3;
      }
    }
    unsigned coreNum = KSize * JSize * ISize;
    unsigned colWidth = std::ceil(coreNum/(float)height);
    if(colWidth > colNum)
      return false;
    unsigned colStart = std::floor((colNum - colWidth) / 2.0) + colOffset;

    auto result = func.walk([&](CallOp callOp){
      if(!callOp->hasAttr("adf.kernel"))
        return WalkResult::advance();
      if(!callOp->hasAttr("ivs"))
        return WalkResult::advance();
      auto ivArrayAttr = dyn_cast<ArrayAttr>(callOp->getAttr("ivs"));
      callOp->removeAttr("ivs");
      // Check if there are reduction loops need to be placed
      
      SmallVector<unsigned, 3> ivIdeices;
      for(auto attr : ivArrayAttr){
        auto intAttr = dyn_cast<IntegerAttr>(attr);
        ivIdeices.push_back((unsigned)intAttr.getInt());
      }
      unsigned kSize=0;
      unsigned jSize=0;
      unsigned iSize=0;
      if(ivIdeices.size()>3){
        WalkResult::interrupt();
      }else if(ivIdeices.size()==3){
        kSize = ivIdeices[0];
        jSize = ivIdeices[1];
        iSize = ivIdeices[2];
      }else if(ivIdeices.size()==2){
        if(KSize ==1){
          jSize = ivIdeices[0];
          iSize = ivIdeices[1];
        }else{
          kSize = ivIdeices[0];
          jSize = ivIdeices[1];
        }
      }else if(ivIdeices.size()==1){
        if(KSize ==1){
          jSize = ivIdeices[0];
        }else{
          kSize = ivIdeices[0];
        }
      }else{
        return WalkResult::advance();
      }
      unsigned pid=0;
      unsigned index=0;
      if(flag == 0){
        pid = kSize + jSize * KSize + iSize * JSize * KSize;
      }else if(flag == 1){
        pid = kSize + iSize * KSize + jSize * ISize * KSize;
      }else if(flag == 2){
        index = kSize + jSize * KSize + iSize * JSize * KSize; 
      }else if(flag == 3){
        index = kSize + iSize * KSize + jSize * ISize * KSize;
      }
      if(flag == 2 || flag ==3){
        unsigned remi = index % height;
        unsigned quot = std::floor(index / (float)height);
        if(quot%2==0){
          pid = quot * height + remi;
        }else{
          pid = quot * height + (height-1) - remi;
        }
      }
      unsigned col = colStart + std::floor(pid / (float)height);
      unsigned row = rowStart + pid % height;
      if((col > colNum-1) || (row > rowNum-1)){
        llvm::errs() << "Placement exceeds array boundary\n";
        return WalkResult::interrupt();
      }
      auto colAttr = builder.getIntegerAttr(indexType, col);
      auto rowAttr = builder.getIntegerAttr(indexType, row);
      auto arrayAttr = builder.getArrayAttr({colAttr, rowAttr});
      callOp->setAttr("col, row", arrayAttr);
      return WalkResult::advance();
    });
    if(result == WalkResult::interrupt())
      return false;
    return true;
  }

  void determineDir(const unsigned colNum, const unsigned rowNum, unsigned col, 
                    unsigned row, bool dir, bool horizental, int order,
                    SmallVector<int64_t, 4>& directions){
    // Determine the directions that a buffer can be placed
    // 0: down, 1: up, 2:left, 3:right
    // There are 9 cases, 4 cases when core adjacent with two edge,
    // 4 cases when core adjacent with one edges, 1 case for no edges
    // Deal with first 4 cases
    if(dir){
      if(order == 3)
        directions.push_back(1);
      else
        directions.push_back(3);
      return;
    }
    if(order==0){
      directions.push_back(1);
      directions.push_back(3);
      return;
    }else if(order==1){
      if(row%2==0){
        directions.push_back(1);
        directions.push_back(2);
        directions.push_back(3);
      }else{
        directions.push_back(0);
        directions.push_back(2);
        directions.push_back(3);
      }
      return;
    }else if(order==2){
      directions.push_back(0);
      directions.push_back(2);
    }
    if(horizental){ //Only allow horizental direction
      if(col == 0 && row == 0){ // left bottom
        directions.push_back(3);
      }else if(col == 0 && row == rowNum-1){ // left top
        directions.push_back(3);
      }else if(col == colNum -1 && row == 0){ // right bottom
        directions.push_back(2);
      }else if(col == colNum -1 && row == rowNum-1){ // right top
        directions.push_back(2);
      }else if(col == 0){   // left
        directions.push_back(3);
      }else if(row == 0){   // bottom
        directions.push_back(2);
        directions.push_back(3);
      }else if(col == colNum -1){ // right
        directions.push_back(2);
      }else if(row == rowNum -1){ // up
        if(row%2==0){ // left first then right
          directions.push_back(2);
          directions.push_back(3);
        }else{ // right first then left
          directions.push_back(3);
          directions.push_back(2);
        }
      }else{
        if(row%2==0){ 
          directions.push_back(2);
          directions.push_back(3);
        }else{
          directions.push_back(3);
          directions.push_back(2);
        }
      }
      return;
    }
    if(col == 0 && row == 0){ // left bottom
      directions.push_back(1);
      directions.push_back(3);
    }else if(col == 0 && row == rowNum-1){ // left top
      directions.push_back(0);
      directions.push_back(3);
    }else if(col == colNum -1 && row == 0){ // right bottom
      directions.push_back(1);
      directions.push_back(2);
    }else if(col == colNum -1 && row == rowNum-1){ // right top
      directions.push_back(0);
      directions.push_back(2);
    }else if(col == 0){   // left
      directions.push_back(0);
      directions.push_back(1);
      directions.push_back(3);
    }else if(row == 0){   // bottom
      directions.push_back(1);
      directions.push_back(2);
      directions.push_back(3);
    }else if(col == colNum -1){ // right
      directions.push_back(0);
      directions.push_back(1);
      directions.push_back(2);
    }else if(row == rowNum -1){ // up
      directions.push_back(0);
      directions.push_back(2);
      directions.push_back(3);
    }else{
      directions.push_back(0);
      directions.push_back(1);
      directions.push_back(2);
      directions.push_back(3);
    }
  }

  // Given direction and core placement, determine the buffer location,
  // since buffer change directions at odd row and even row
  void bufLoc(unsigned direction, unsigned col, unsigned row,
              unsigned& bufCol, unsigned& bufRow){
    bufCol = col;
    bufRow = row;
    if(direction == 0){ // down
      bufRow = row - 1;
    }else if(direction == 1){ // up
      bufRow = row + 1;
    }else if(direction == 2){ // left
      if(row%2==0){
        bufCol = col - 1;
      }else{
        bufCol = col;
      }
    }else{ // right
      if(row%2==0){
        bufCol = col;
      }else{
        bufCol = col + 1;
      }
    }
  }

  void createBufLoc(OpBuilder builder, CallOp call, Value buffer,
                    unsigned col, unsigned row,
                    unsigned offset0, unsigned offset1){
    auto loc = builder.getUnknownLoc();
    auto indexType = builder.getIndexType();
    auto colAttr = builder.getIntegerAttr(indexType, col);
    auto rowAttr = builder.getIntegerAttr(indexType, row);
    auto offsetAttr0 = builder.getIntegerAttr(indexType, offset0);
    auto offsetAttr1 = builder.getIntegerAttr(indexType, offset1);
    builder.setInsertionPoint(call);
    auto colVal = builder.create<arith::ConstantOp>(loc, colAttr);
    auto rowVal = builder.create<arith::ConstantOp>(loc, rowAttr);
    auto offsetVal0 = builder.create<arith::ConstantOp>(loc, offsetAttr0);
    auto offsetVal1 = builder.create<arith::ConstantOp>(loc, offsetAttr1);
    builder.setInsertionPointAfter(call);
    builder.create<BuffLocOp>(loc, buffer, colVal, rowVal, 
                              offsetVal0, offsetVal1);
  }

  bool bufPlace1(OpBuilder builder, CallOp callOp, 
                 const unsigned bankNum, unsigned col, unsigned row,
                 bool horizental, SmallVector<int64_t, 4> directions,
                 SmallVector<std::pair<Value, int64_t>, 4>& memInfo,
                 std::vector<std::vector<int>>& DMACnt,
                 std::vector<std::vector<std::vector<unsigned>>>& bufOffsets){
    const unsigned bankSize = 4096;
    const unsigned stackSize = 1024;
    const unsigned lastBankSize = bankSize - stackSize;
    // Place larger mem first
    llvm::sort(memInfo.begin(), memInfo.end(), 
        [](const std::pair<Value, int>& a, const std::pair<Value, int>& b) {
        return a.second > b.second;
    });
    unsigned dirIndex = 0;
    for(auto pair : memInfo){
      auto buffer = pair.first;
      auto sizeInBytes = pair.second;
      unsigned lefSize = sizeInBytes % bankSize;
      unsigned bankNeeded = std::ceil(sizeInBytes / (float)bankSize);
      // Check if buffer exceed the local memory size
      if(bankNeeded > bankNum || (bankNeeded==bankNum && lefSize>=lastBankSize))
        return false;
      // Find the location of the buffer
      // For a new mem change another direction to alleviate bank conflicts
      bool flag_end = false;
      SmallVector<int64_t, 4> invalidDir;
      invalidDir.clear();
      unsigned directSize = directions.size();
      while(!flag_end){
        // If all the direction has been tested and failed, then no solution
        if(invalidDir.size()==directSize)
          return false;
        unsigned directSel = dirIndex % directSize;
        auto it = llvm::find(invalidDir,directSel);
        if(it != invalidDir.end()){
          dirIndex++;
          continue;
        }
        auto direction = directions[directSel];
        unsigned bufCol, bufRow;
        bufLoc(direction, col, row, bufCol, bufRow);
        // Get the number of DMAs remaining
        auto dmaBudget = DMACnt[bufCol][bufRow];
        // If no available dma, then mark this dir as invalid
        if(dmaBudget < 1){
          invalidDir.push_back(directSel);
          dirIndex++;
          continue;
        }
        // Place the buffer in one of the available bank of dest location
        // Find an empty bank to place, if non-empty one, then insert it in 
        // one of the avialable bank
        // Round 0, find empty bank first
        bool round1_flag = true;
        for(unsigned b = 0; b < bankNum; b++){
          // an affine map e.g. [0,1,2,3] -> [0,2,1,3]
          auto remi = b % (bankNum/2);
          auto quot = std::floor(b / (bankNum/2));
          unsigned bnew;
          if(quot == 0)
            bnew = remi * 2;
          else
            bnew = remi * 2 + 1;
          // Double buffer is interleaved in AIE
          // [0, 2, 4, 6] where 0,2; 4,6; 1,3; 5,7; are pairs
          // [1, 3, 5, 7] index should be [0->0] [1->1] [2-->4] [3-->5]
          unsigned breal;
          if(bnew%2==0)
            breal = bnew * 2;
          else
            breal = bnew * 2 - 1;
          auto curBudget = bufOffsets[bufCol][bufRow][bnew];
          if(curBudget >= bankSize)
            continue;
          unsigned flag = true;
          if(curBudget!=0)
            continue;
          else{
            // Check if start from this bank the capacity is enough
            for(unsigned i = 0; i < bankNeeded; i++){
              auto needBank = i + bnew;
              auto needBudget = bufOffsets[bufCol][bufRow][needBank];
              // The buffer need to be consecutive. If find non-consecutive
              // banks go to next bank
              if(needBudget != 0){
                flag =false;
                break;
              }         
            }
            if(!flag)
              continue;
            // If can be placed then update offsets
            for(unsigned i = 0; i < bankNeeded; i++){
              auto needBank = i + bnew;
              if(i==bankNeeded-1)
                bufOffsets[bufCol][bufRow][needBank] = lefSize + 1;
              else
                bufOffsets[bufCol][bufRow][needBank] = bankSize;       
            }
            unsigned offset0 = breal * bankSize;
            unsigned offset1 = offset0 +  bankSize * 2;
            createBufLoc(builder, callOp, buffer, 
                         bufCol, bufRow, offset0, offset1);
            DMACnt[bufCol][bufRow] = DMACnt[bufCol][bufRow] - 1;
            flag_end = true;
            round1_flag = false;
            break;
          }  
        }
        if(round1_flag){//Run second round
          for(unsigned b = 0; b < bankNum; b++){
            auto remi = b % (bankNum/2);
            auto quot = std::floor(b / (bankNum/2));
            unsigned bnew;
            if(quot == 0)
              bnew = remi * 2;
            else
              bnew = remi * 2 + 1;
            unsigned breal;
            if(bnew%2==0)
              breal = bnew * 2;
            else
              breal = bnew * 2 - 1;
            auto curBudget = bufOffsets[bufCol][bufRow][bnew];
            if(curBudget >= bankSize)
              continue;
            unsigned flag = true;
            // Check if with the curBudget start from this bank the 
            // capacity is enough
            auto availableBank = bankNum - bnew;
            auto newSizeInBytes = curBudget + sizeInBytes;
            unsigned newLefSize = newSizeInBytes % bankSize;
            unsigned newBankNeeded = std::ceil(newSizeInBytes / (float)bankSize);
            if(newBankNeeded > availableBank || 
              (bankNeeded==availableBank && newLefSize>=lastBankSize))
              break;
            for(unsigned i = 0; i < newBankNeeded; i++){
              auto needBank = i + bnew;
              auto needBudget = bufOffsets[bufCol][bufRow][needBank];
              // This is already the second round, try another bank
              if(i!=0 && needBudget != 0){
                flag =false;
                break;
              }
            }
            if(!flag)
              continue;
            for(unsigned i = 0; i < newBankNeeded; i++){
              auto needBank = i + bnew;
              if(i==0 && newBankNeeded==1)
                bufOffsets[bufCol][bufRow][needBank] = newLefSize + 1;
              else if(i==newBankNeeded-1)
                bufOffsets[bufCol][bufRow][needBank] = newLefSize + 1;
              else
                bufOffsets[bufCol][bufRow][needBank] = bankSize;
            }
            unsigned offset0 = breal * bankSize + curBudget;
            unsigned offset1 = offset0 +  bankSize * 2;
            createBufLoc(builder, callOp, buffer, 
                         bufCol, bufRow, offset0, offset1);
            DMACnt[bufCol][bufRow] = DMACnt[bufCol][bufRow] - 1;
            flag_end = true;
            break;
          }
        }
        // After check all the banks in this direction, still not find, then
        // mark this direction as invalid and change another direction
        if(horizental){ // For horizental buff placement only change direction
          if(!flag_end){ // can't find available banks
            invalidDir.push_back(directSel);
            dirIndex++;
          }
        }else{ //Change direction no matter find or not
          if(!flag_end){
            invalidDir.push_back(directSel);
          }
          dirIndex++;
        }
        
      }
    }
    return true;
  }

  bool bufPlace2(OpBuilder builder, CallOp callOp, 
                 const unsigned bankNum, unsigned col, unsigned row,
                 bool horizental, SmallVector<int64_t, 4> directions,
                 SmallVector<std::pair<Value, int64_t>, 4>& memInfo,
                 std::vector<std::vector<int>>& DMACnt,
                 std::vector<std::vector<std::vector<unsigned>>>& bufOffsets){
    const unsigned bankSize = 4096;
    const unsigned stackSize = 1024;
    const unsigned lastBankSize = bankSize - stackSize;
    // Place larger mem first
    llvm::sort(memInfo.begin(), memInfo.end(), 
        [](const std::pair<Value, int>& a, const std::pair<Value, int>& b) {
        return a.second > b.second;
    });
    for(auto pair : memInfo){
      auto buffer = pair.first;
      auto sizeInBytes = pair.second;
      unsigned lefSize = sizeInBytes % bankSize;
      unsigned bankNeeded = std::ceil(sizeInBytes / (float)bankSize);
      // Check if buffer exceed the local memory size
      if(bankNeeded > bankNum || (bankNeeded==bankNum && lefSize>=lastBankSize))
        return false;
      // Find the location of the buffer
      auto flag_end = false;
      for(auto direction : directions){
        unsigned bufCol, bufRow;
        bufLoc(direction, col, row, bufCol, bufRow);
        auto dmaBudget = DMACnt[bufCol][bufRow];
        // If no available dma, then change another direction
        if(dmaBudget < 1)
          continue;
                // Place the buffer in one of the available bank of dest location
        // Find an empty bank to place, if non-empty one, then insert it in 
        // one of the avialable bank
        // Round 0, find empty bank first
        bool round1_flag = true;
        for(unsigned b = 0; b < bankNum; b++){
          // an affine map e.g. [0,1,2,3] -> [0,2,1,3]
          auto remi = b % (bankNum/2);
          auto quot = std::floor(b / (bankNum/2));
          unsigned bnew;
          if(quot == 0)
            bnew = remi * 2;
          else
            bnew = remi * 2 + 1;
          // Double buffer is interleaved in AIE
          // [0, 2, 4, 6] where 0,2; 4,6; 1,3; 5,7; are pairs
          // [1, 3, 5, 7] index should be [0->0] [1->1] [2-->4] [3-->5]
          unsigned breal;
          if(bnew%2==0)
            breal = bnew * 2;
          else
            breal = bnew * 2 - 1;
          auto curBudget = bufOffsets[bufCol][bufRow][bnew];
          if(curBudget >= bankSize)
            continue;
          unsigned flag = true;
          if(curBudget!=0)
            continue;
          else{
            // Check if start from this bank the capacity is enough
            for(unsigned i = 0; i < bankNeeded; i++){
              auto needBank = i + bnew;
              auto needBudget = bufOffsets[bufCol][bufRow][needBank];
              // The buffer need to be consecutive. If find non-consecutive
              // banks go to next bank
              if(needBudget != 0){
                flag =false;
                break;
              }         
            }
            if(!flag)
              continue;
            // If can be placed then update offsets
            for(unsigned i = 0; i < bankNeeded; i++){
              auto needBank = i + bnew;
              if(i==bankNeeded-1)
                bufOffsets[bufCol][bufRow][needBank] = lefSize + 1;
              else
                bufOffsets[bufCol][bufRow][needBank] = bankSize;       
            }
            unsigned offset0 = breal * bankSize;
            unsigned offset1 = offset0 +  bankSize * 2;
            createBufLoc(builder, callOp, buffer, 
                         bufCol, bufRow, offset0, offset1);
            DMACnt[bufCol][bufRow] = DMACnt[bufCol][bufRow] - 1;
            flag_end = true;
            round1_flag = false;
            break;
          }
          if(flag_end)
            break;
        }
        if(round1_flag){//Run second round
          for(unsigned b = 0; b < bankNum; b++){
            auto remi = b % (bankNum/2);
            auto quot = std::floor(b / (bankNum/2));
            unsigned bnew;
            if(quot == 0)
              bnew = remi * 2;
            else
              bnew = remi * 2 + 1;
            unsigned breal;
            if(bnew%2==0)
              breal = bnew * 2;
            else
              breal = bnew * 2 - 1;
            auto curBudget = bufOffsets[bufCol][bufRow][bnew];
            if(curBudget >= bankSize)
              continue;
            unsigned flag = true;
            // Check if with the curBudget start from this bank the 
            // capacity is enough
            auto availableBank = bankNum - bnew;
            auto newSizeInBytes = curBudget + sizeInBytes;
            unsigned newLefSize = newSizeInBytes % bankSize;
            unsigned newBankNeeded = std::ceil(newSizeInBytes / (float)bankSize);
            if(newBankNeeded > availableBank || 
              (bankNeeded==availableBank && newLefSize>=lastBankSize))
              break;
            for(unsigned i = 0; i < newBankNeeded; i++){
              auto needBank = i + bnew;
              auto needBudget = bufOffsets[bufCol][bufRow][needBank];
              // This is already the second round, try another bank
              if(i!=0 && needBudget != 0){
                flag =false;
                break;
              }
            }
            if(!flag)
              continue;
            for(unsigned i = 0; i < newBankNeeded; i++){
              auto needBank = i + bnew;
              if(i==0 && newBankNeeded==1)
                bufOffsets[bufCol][bufRow][needBank] = newLefSize + 1;
              else if(i==newBankNeeded-1)
                bufOffsets[bufCol][bufRow][needBank] = newLefSize + 1;
              else
                bufOffsets[bufCol][bufRow][needBank] = bankSize;
            }
            unsigned offset0 = breal * bankSize + curBudget;
            unsigned offset1 = offset0 +  bankSize * 2;
            createBufLoc(builder, callOp, buffer, 
                         bufCol, bufRow, offset0, offset1);
            DMACnt[bufCol][bufRow] = DMACnt[bufCol][bufRow] - 1;
            flag_end = true;
            break;
          }
          if(flag_end)
            break;
        }
        if(flag_end)
          break;
      }
      if(!flag_end)
        return false;
    }
    return true;
  }

  // This buffer placement algorithm is built upon the placementNaive1
  bool bufPlacement(OpBuilder builder, CallOp callOp, const unsigned colNum, 
                    const unsigned rowNum, const unsigned bankNum, unsigned col, 
                    unsigned row, unsigned sel, int order,
                    std::vector<std::vector<int>>& DMAINCnt,
                    std::vector<std::vector<int>>& DMAOUTCnt,
                   std::vector<std::vector<std::vector<unsigned>>>& bufOffsets){
    
    SmallVector<int64_t, 4> dirIns;
    SmallVector<int64_t, 4> dirOuts;
    dirIns.clear();
    dirOuts.clear();

    // Place input buffer
    SmallVector<std::pair<Value, int64_t>, 4> memIn; // <mem, size in byte>
    for(unsigned i = 0; i < callOp.getNumOperands(); i++){
      auto operand = callOp.getOperand(i);
      auto defineOp = operand.getDefiningOp();
      if(!defineOp)
        continue;
      unsigned in_flag = true;
      // Skip placement for shared memory
      for(auto use: operand.getUsers()){
        if(auto connectOp = dyn_cast<ConnectOp>(use)){
          auto src = connectOp.getSrc();
          auto srcType = src.getType();
          if(auto memrefType = dyn_cast<MemRefType>(srcType)){
            if(memrefType.getMemorySpaceAsInt() == (int)MemorySpace::L1){
              in_flag = false;
              break;
            }
          }
        }
      }
      if(!in_flag)
        continue;
      if(auto bufferOp = dyn_cast<BufferOp>(defineOp)){
        auto memrefType =  dyn_cast<MemRefType>(operand.getType());
        auto EPB = memrefType.getElementTypeBitWidth()/8;
        auto sizeInBytes = memrefType.getNumElements() * EPB;
        if(sizeInBytes <= 1)
          continue;
        memIn.push_back(std::pair(operand, sizeInBytes-1));
      }
    }
    // For a single core with more than 2 inputs then only allow horizental
    // Buffer placement
    bool horizentalIn = (memIn.size()>2);
    determineDir(colNum, rowNum, col, row, false, horizentalIn, order, dirIns);
    if(sel==0){
      if(!bufPlace1(builder, callOp, bankNum, col, row, horizentalIn, dirIns,
                    memIn, DMAINCnt, bufOffsets))
        return false;
    }else{
      if(!bufPlace2(builder, callOp, bankNum, col, row, horizentalIn, dirIns,
                    memIn, DMAINCnt, bufOffsets))
        return false;
    }
    
    // Place output buffer
    SmallVector<std::pair<Value, int64_t>, 4> memOut; // <mem, size in byte>
    for(unsigned i = 0; i < callOp.getNumResults(); i++){
      auto result = callOp.getResult(i);
      auto memrefType =  dyn_cast<MemRefType>(result.getType());
      auto EPB = memrefType.getElementTypeBitWidth()/8;
      auto sizeInBytes = memrefType.getNumElements() * EPB;
      if(sizeInBytes <= 1)
        continue;
      memOut.push_back(std::pair(result, sizeInBytes-1));
    }
    bool horizentalOut = (memOut.size()>2);
    determineDir(colNum, rowNum, col, row, true, horizentalOut, order, dirOuts);
    if(sel==0){
      if(!bufPlace1(builder, callOp, bankNum, col, row, horizentalOut, dirOuts, 
              memOut, DMAOUTCnt, bufOffsets))
        return false;
    }else{
      if(!bufPlace2(builder, callOp, bankNum, col, row, horizentalOut, dirOuts, 
              memOut, DMAOUTCnt, bufOffsets))
        return false;
    }
    return true;
  }

  // In this algorithm, the reduction dim is consecutive horizontally
  // J dim will first be placed vertically
  bool placementNaive1(OpBuilder builder, FuncOp func, 
                       const unsigned colNum, const unsigned rowNum, 
                       unsigned colOffset, unsigned rowOffset, unsigned colGap,
                       unsigned KSize, unsigned JSize, unsigned ISize){
    auto indexType = builder.getIndexType();
    unsigned rowStart = rowOffset;
    // Determine the height and formula for pid
    unsigned height;
    unsigned flag;
    unsigned realRowNum = rowNum - rowStart;
    if(JSize >= ISize){
      flag = 0;
      if(realRowNum>JSize && realRowNum%JSize==0)
        height = realRowNum;
      else
        height = std::min(JSize, realRowNum);
    }else{
      flag = 1;
      if(realRowNum>ISize && realRowNum%ISize==0)
        height = realRowNum;
      else
        height = std::min(ISize, realRowNum);
    }
    unsigned coreNum = JSize * ISize;
    unsigned colWidth = std::ceil(coreNum/(float)height) * (KSize+colGap);
    if(colWidth > colNum)
      return false;
    unsigned colStart = std::floor((colNum - colWidth) / 2.0) + colOffset;

    const unsigned bankNum = (8/2); // 2:Double buffer
    //Stores the start available offset of the current bank 
    std::vector<std::vector<std::vector<unsigned>>> bufOffsets(
      colNum, std::vector<std::vector<unsigned>>(
      rowNum, std::vector<unsigned>(bankNum, 0))); 
    
    unsigned numDMA = 2;
    //Stores the number of available DMAs in each tile
    std::vector<std::vector<int>> DMAINCnt(
      colNum, std::vector<int>(rowNum,numDMA)); 
    std::vector<std::vector<int>> DMAOUTCnt(
      colNum, std::vector<int>(rowNum,numDMA)); 
      
    auto result = func.walk([&](CallOp callOp){
      if(!callOp->hasAttr("adf.kernel"))
        return WalkResult::advance();
      if(!callOp->hasAttr("ivs"))
        return WalkResult::advance();
      auto ivArrayAttr = dyn_cast<ArrayAttr>(callOp->getAttr("ivs"));
      // Check if there are reduction loops need to be placed
      
      SmallVector<unsigned, 3> ivIdeices;
      for(auto attr : ivArrayAttr){
        auto intAttr = dyn_cast<IntegerAttr>(attr);
        ivIdeices.push_back((unsigned)intAttr.getInt());
      }
      unsigned kSize=0;
      unsigned jSize=0;
      unsigned iSize=0;
      if(ivIdeices.size()>3){
        WalkResult::interrupt();
      }else if(ivIdeices.size()==3){
        kSize = ivIdeices[0];
        jSize = ivIdeices[1];
        iSize = ivIdeices[2];
      }else if(ivIdeices.size()==2){
        if(KSize ==1){
          jSize = ivIdeices[0];
          iSize = ivIdeices[1];
        }else{
          kSize = ivIdeices[0];
          jSize = ivIdeices[1];
        }
      }else if(ivIdeices.size()==1){
        if(KSize ==1){
          jSize = ivIdeices[0];
        }else{
          kSize = ivIdeices[0];
        }
      }else{
        return WalkResult::advance();
      }
      
      unsigned rowIndex = 0;
      if(flag==1)
        rowIndex = jSize + iSize * JSize;
      else if(flag==0)
        rowIndex = iSize + jSize * ISize;
      unsigned remi = rowIndex % height;
      unsigned quot = std::floor(rowIndex / (float)height);
      unsigned pid = remi + kSize * height + quot * (KSize + colGap) * height;
      unsigned col = colStart + std::floor(pid / (float)height);
      unsigned row = rowStart + pid % height;
      if((col > colNum-1) || (row > rowNum-1)){
        llvm::errs() << "Placement exceeds array boundary";
        return WalkResult::interrupt();
      }
      auto colAttr = builder.getIntegerAttr(indexType, col);
      auto rowAttr = builder.getIntegerAttr(indexType, row);
      auto arrayAttr = builder.getArrayAttr({colAttr, rowAttr});
      callOp->setAttr("col, row", arrayAttr);
      if(!bufPlacement(builder, callOp, colNum, rowNum, bankNum, col, row, 0,
                       -1, DMAINCnt, DMAOUTCnt, bufOffsets))
        return WalkResult::interrupt();
      return WalkResult::advance();
    });
    if(result == WalkResult::interrupt())
      return false;
    return true;
  }

  // This algorithm is different from 0 and 1, as it is a specific zipzap
  // Placement algorithm
  bool placementNaive2(OpBuilder builder, FuncOp func, 
                       const unsigned colNum, const unsigned rowNum, 
                       unsigned colOffset, unsigned rowOffset,
                       unsigned realKSize, unsigned JSize, unsigned ISize){
    auto indexType = builder.getIndexType();
    unsigned rowStart = rowOffset;
    if(rowStart%2!=0){
      llvm::errs() << "Algorithm requires rowOffset is a even number\n";
      return false;
    }
    unsigned realRowNum = std::floor((rowNum-rowStart)/2);
    // Determine the height and formula for pid
    unsigned height;
    unsigned flag;
    if(JSize >= ISize){
      flag = 0;
      if(realRowNum>JSize && realRowNum%JSize==0)
        height = realRowNum;
      else
        height = std::min(JSize, realRowNum);
    }else{
      flag = 1;
      if(realRowNum>ISize && realRowNum%ISize==0)
        height = realRowNum;
      else
        height = std::min(ISize, realRowNum);
    }
    unsigned coreNum = JSize * ISize;
    unsigned KSize;
    unsigned halfKSize =  std::ceil(realKSize/2.0);
    if(realKSize == 1 || realKSize == 2)
      KSize = realKSize;
    else
      KSize = std::ceil(realKSize/2.0) + std::floor(realKSize/2.0) - 1;
    unsigned colWidth = std::ceil(coreNum/(float)height) * (KSize);
    if(colWidth > colNum)
      return false;
    unsigned colStart = std::floor((colNum - colWidth) / 2.0) + colOffset;

    const unsigned bankNum = (8/2); // 2:Double buffer
    //Stores the start available offset of the current bank 
    std::vector<std::vector<std::vector<unsigned>>> bufOffsets(
      colNum, std::vector<std::vector<unsigned>>(
      rowNum, std::vector<unsigned>(bankNum, 0))); 
    
    unsigned numDMA = 2;
    //Stores the number of available DMAs in each tile
    std::vector<std::vector<int>> DMAINCnt(
      colNum, std::vector<int>(rowNum,numDMA)); 
    std::vector<std::vector<int>> DMAOUTCnt(
      colNum, std::vector<int>(rowNum,numDMA));

    auto result = func.walk([&](CallOp callOp){
      if(!callOp->hasAttr("adf.kernel"))
        return WalkResult::advance();
      if(!callOp->hasAttr("ivs"))
        return WalkResult::advance();
      auto ivArrayAttr = dyn_cast<ArrayAttr>(callOp->getAttr("ivs"));
      // Check if there are reduction loops need to be placed
      
      SmallVector<unsigned, 3> ivIdeices;
      for(auto attr : ivArrayAttr){
        auto intAttr = dyn_cast<IntegerAttr>(attr);
        ivIdeices.push_back((unsigned)intAttr.getInt());
      }
      unsigned kSize=0;
      unsigned jSize=0;
      unsigned iSize=0;
      if(ivIdeices.size()>3){
        WalkResult::interrupt();
      }else if(ivIdeices.size()==3){
        kSize = ivIdeices[0];
        jSize = ivIdeices[1];
        iSize = ivIdeices[2];
      }else if(ivIdeices.size()==2){
        if(KSize ==1){
          jSize = ivIdeices[0];
          iSize = ivIdeices[1];
        }else{
          kSize = ivIdeices[0];
          jSize = ivIdeices[1];
        }
      }else if(ivIdeices.size()==1){
        if(KSize ==1){
          jSize = ivIdeices[0];
        }else{
          kSize = ivIdeices[0];
        }
      }else{
        return WalkResult::advance();
      }
      
      unsigned rowIndex = 0;
      if(flag==1)
        rowIndex = jSize + iSize * JSize;
      else if(flag==0)
        rowIndex = iSize + jSize * ISize;
      unsigned remi = rowIndex % height;
      unsigned quot = std::floor(rowIndex / (float)height);
      // Calculate if exceed the half of the Ksize, then need to go up
      unsigned upOffset = 0;
      unsigned newkSize = kSize;
      if(kSize >= halfKSize){
        upOffset = 1;
        newkSize = kSize - 1;
      }
      unsigned pid = remi * 2 + newkSize * (height*2) + upOffset 
                     + quot * (KSize) * height * 2;
      unsigned col = colStart + std::floor(pid / (float)(height*2));
      unsigned row = rowStart + pid % (height*2);
      if((col > colNum-1) || (row > rowNum-1)){
        llvm::errs() << "Placement exceeds array boundary";
        return WalkResult::interrupt();
      }
      auto colAttr = builder.getIntegerAttr(indexType, col);
      auto rowAttr = builder.getIntegerAttr(indexType, row);
      auto arrayAttr = builder.getArrayAttr({colAttr, rowAttr});
      callOp->setAttr("col, row", arrayAttr);
      int order = 1; // 0:head, 1:mid, 2:tail, 3:up
      if(kSize == 0)
        order = 0;
      else if(kSize == KSize-1)
        order = 2;
      else if(kSize == halfKSize-1)
        order = 3;
      if(!bufPlacement(builder, callOp, colNum, rowNum, bankNum, col, row, 1,
                       order, DMAINCnt, DMAOUTCnt, bufOffsets)){
        llvm::errs() << "Buffer placement failed";
        return WalkResult::interrupt();
      }
      return WalkResult::advance();
    });
    if(result == WalkResult::interrupt())
      return false;

    return true;
  }

  bool CorePlacement (ModuleOp mod) {
    auto builder = OpBuilder(mod);
    unsigned colNum = ColNum;
    unsigned rowNum = RowNum;
    unsigned colOffset = ColOffset;
    unsigned rowOffset = RowOffset;
    unsigned colGap = ColGap;

    auto flag = mod.walk([&](FuncOp func){
      if(!func->hasAttr("adf.cell") || !func->hasAttr("tripCount"))
        return WalkResult::advance();

      auto arrayAttr = dyn_cast<ArrayAttr>(func->getAttr("tripCount"));
      SmallVector<unsigned, 3> tripCounts;
      for(auto attr : arrayAttr){
        auto intAttr = dyn_cast<IntegerAttr>(attr);
        tripCounts.push_back((unsigned)intAttr.getInt());
      }
      // Here we need to identify the KSize, which assume should be innermost
      // but don't care about the order of ISize and JSize
      unsigned KSize = tripCounts[0];
      unsigned JSize = tripCounts[1];
      unsigned ISize = tripCounts[2];

      if(CoreAlgo == 0){
        if(!placementNaive0(builder, func, colNum, rowNum, colOffset, rowOffset,
                            KSize, JSize, ISize)){
          llvm::errs() << "Placement0 failed";
          return WalkResult::interrupt();
        }
      }else if(CoreAlgo == 1){
        if(!placementNaive1(builder, func, colNum, rowNum, colOffset, rowOffset,
                            colGap, KSize, JSize, ISize)){
          llvm::errs() << "Placement1 failed";
          return WalkResult::interrupt();
        }
      }else{
        if(!placementNaive2(builder, func, colNum, rowNum, colOffset, rowOffset,
                            KSize, JSize, ISize)){
          llvm::errs() << "Placement2 failed";
          return WalkResult::interrupt();
        }
      }
      return WalkResult::advance();
    });
    if(flag == WalkResult::interrupt())
      return false;
    return true;
  }

  void createBufLoc(OpBuilder builder, BufferOp buffer,
                    unsigned col, unsigned row){
    auto loc = builder.getUnknownLoc();
    auto indexType = builder.getIndexType();
    auto colAttr = builder.getIntegerAttr(indexType, col);
    auto rowAttr = builder.getIntegerAttr(indexType, row);
    auto zeroAttr = builder.getIntegerAttr(indexType, 0);
    builder.setInsertionPoint(buffer);
    auto colVal = builder.create<arith::ConstantOp>(loc, colAttr);
    auto rowVal = builder.create<arith::ConstantOp>(loc, rowAttr);
    auto zeroVal = builder.create<arith::ConstantOp>(loc, zeroAttr);
    builder.setInsertionPointAfter(buffer);
    builder.create<BuffLocOp>(loc, buffer, colVal, rowVal, zeroVal, zeroVal);
  }

  void NPUbufPlacement(OpBuilder builder, FuncOp func){
    func.walk([&](BufferOp buffer){
      auto buf = buffer.getResult();
      auto memType = dyn_cast<MemRefType>(buf.getType());
      auto space = memType.getMemorySpace();
      if(auto intSpaceAttr = dyn_cast<IntegerAttr>(space)){
        auto intSpace = intSpaceAttr.getInt();
        if(intSpace == (int)MemorySpace::L2){
          for(auto use : buf.getUsers()){
            if(auto dmaOp = dyn_cast<DmaOp>(use)){
              auto src = dmaOp.getSrc();
              auto dst = dmaOp.getDst();
              Value L1buf =src ;
              if(src == buf){
                L1buf = dst;
              }
              for(auto useOp : L1buf.getUsers()){
                if(auto call = dyn_cast<CallOp>(useOp)){
                  auto attr = dyn_cast<ArrayAttr>(call->getAttr("col, row"));
                  unsigned colInt = dyn_cast<IntegerAttr>(attr[0]).getInt();
                  createBufLoc(builder, buffer, colInt, 1);
                  break;
                }
              }
              break;
            }
          }
        }else{
          for(auto useOp : buf.getUsers()){
            if(auto call = dyn_cast<CallOp>(useOp)){
              auto attr = dyn_cast<ArrayAttr>(call->getAttr("col, row"));
              unsigned colInt = dyn_cast<IntegerAttr>(attr[0]).getInt();
              unsigned rowInt = dyn_cast<IntegerAttr>(attr[1]).getInt();
              createBufLoc(builder, buffer, colInt, rowInt);
              break;
            }
          }
        }
      }
    });
  }

  bool NPUPlacement0(OpBuilder builder, FuncOp func, 
                     const unsigned colNum, const unsigned rowNum, 
                     unsigned colOffset, unsigned rowOffset,
                     unsigned dim0, unsigned dim1){
    auto indexType = builder.getIndexType();
    auto result = func.walk([&](CallOp call){
      if(!call->hasAttr("adf.kernel"))
        return WalkResult::advance();
      if(!call->hasAttr("ivs")){
        return WalkResult::interrupt();
      }
      auto ivArrayAttr = dyn_cast<ArrayAttr>(call->getAttr("ivs"));
      call->removeAttr("ivs");
      // Check if there are reduction loops need to be placed
      SmallVector<unsigned, 3> ivIdeices;
      for(auto attr : ivArrayAttr){
        auto intAttr = dyn_cast<IntegerAttr>(attr);
        ivIdeices.push_back((unsigned)intAttr.getInt());
      }
      unsigned col = ivIdeices[dim0] + colOffset;
      unsigned row = ivIdeices[dim1] + rowOffset;
      if((col > colNum-1) || (row > rowNum-1)){
        llvm::errs() << "Placement exceeds array boundary";
        return WalkResult::interrupt();
      }
      auto colAttr = builder.getIntegerAttr(indexType, col);
      auto rowAttr = builder.getIntegerAttr(indexType, row);
      auto arrayAttr = builder.getArrayAttr({colAttr, rowAttr});
      call->setAttr("col, row", arrayAttr);
      return WalkResult::advance();
    });
    if (result == WalkResult::interrupt())
      return false;
    NPUbufPlacement(builder, func);
    return true;
  }

  bool NPUCorePlacement (ModuleOp mod) {
    auto builder = OpBuilder(mod);
    unsigned colNum = ColNum;
    unsigned rowNum = RowNum;
    unsigned colOffset = ColOffset;
    unsigned rowOffset = RowOffset;
    auto flag = mod.walk([&](FuncOp func){
      if(!func->hasAttr("adf.cell") || !func->hasAttr("tripCount"))
        return WalkResult::advance();
      auto arrayAttr = dyn_cast<ArrayAttr>(func->getAttr("tripCount"));
      SmallVector<unsigned, 3> tripCounts;
      for(unsigned i=0; i < 3; i++){
        auto attr = arrayAttr[i];
        auto intAttr = dyn_cast<IntegerAttr>(attr);
        tripCounts.push_back((unsigned)intAttr.getInt());
      }
      // Here we need to identify the KSize, which assume should be innermost
      // but don't care about the order of ISize and JSize
      unsigned dim0, dim1;
      if(tripCounts[0] == 1){
        dim0 = 1;
        dim1 = 2;
      }else if(tripCounts[1] == 1){
        dim0 = 0;
        dim1 = 2;
      }else if(tripCounts[2] == 1){
        dim0 = 0;
        dim1 = 1;
      }else{
        llvm::errs() << "Current only support 2D logic array for NPU\n";
        return WalkResult::interrupt();
      }
      if(!NPUPlacement0(builder, func, colNum, rowNum, colOffset, rowOffset,
                        dim0, dim1)){
        llvm::errs() << "NPUPlacement0 failed\n";
        return WalkResult::interrupt();
      }
      return WalkResult::advance();
    });
    if (flag == WalkResult::interrupt())
      return false;
    return true;
  }

};
} // namespace



namespace mlir {
namespace aries {

std::unique_ptr<Pass> createAriesCorePlacementPass() {
  return std::make_unique<AriesCorePlacement>();
}

std::unique_ptr<Pass> createAriesCorePlacementPass(const AriesOptions &opts) {
  return std::make_unique<AriesCorePlacement>(opts);
}

} // namespace aries
} // namespace mlir