#include "mlir/Support/FileUtilities.h"
#include "llvm/Support/MemoryBuffer.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/Debug.h"
#include "aries/Transform/Passes.h"

using namespace mlir;
using namespace aries;

namespace {

struct AriesFileSplit : public AriesFileSplitBase<AriesFileSplit> {
public:
  AriesFileSplit() = default;
  AriesFileSplit(const AriesOptions &opts) {
    inputfileName=opts.OptFileName;
    pathName=opts.OptPathName;
  }
  void runOnOperation() override {
    if (!FileSplit())
      signalPassFailure();
  }

private:
  bool FileSplit () {
    std::string filedir = pathName + inputfileName;
    llvm::ErrorOr<std::unique_ptr<llvm::MemoryBuffer>> fileOrErr = llvm::MemoryBuffer::getFile(filedir);
    if (std::error_code ec = fileOrErr.getError()) {
      llvm::errs() << "Could not open input file: " << filedir << "\n";
      return false;
    }
    llvm::MemoryBuffer *inputBuffer = fileOrErr->get();

    // Split the content based on the keyword "//_aries_split_//".
    llvm::StringRef content = inputBuffer->getBuffer();
    llvm::SmallVector<llvm::StringRef, 4> splitContents;
    content.split(splitContents, "//_aries_split_//");

    if(splitContents.size()%2!=1){
      llvm::errs() << "The number of the spliter is wrong\n";
      return false;
    }

    std::string outputFileName="";
    std::string outdir="";
    // Write each split section into separate output files.
    for (size_t i = 0; i < splitContents.size(); ++i) {
      
      if (i == 0)
        continue;
      else if (i%2==1){
        outputFileName= splitContents[i];
        outdir = pathName + outputFileName;
      }else{
        std::error_code ec;
        llvm::raw_fd_ostream outputFile(outdir, ec);
        if (ec) {
          llvm::errs() << "Could not open output file: " << outdir << "\n";
          return false;
        }
        outputFile << splitContents[i];
      }
    }
    return true;
  }

};
} // namespace



namespace mlir {
namespace aries {

std::unique_ptr<Pass> createAriesFileSplitPass() {
  return std::make_unique<AriesFileSplit>();
}

std::unique_ptr<Pass> createAriesFileSplitPass(const AriesOptions &opts) {
  return std::make_unique<AriesFileSplit>(opts);
}


} // namespace aries
} // namespace mlir