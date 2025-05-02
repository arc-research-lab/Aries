import numpy as np

# This is a naive DDR BW model
def DDR_GET_BW(DDR_HIGH, dim, BPE, AXI_WIDTH_Bytes):
  burst = dim * BPE // AXI_WIDTH_Bytes
  # print("Burst:", burst)
  if(burst >= 16):
    return DDR_HIGH
  elif(burst >= 8):
    return DDR_HIGH * 0.85
  elif(burst >= 4):
    return DDR_HIGH * 0.3
  else:
    return DDR_HIGH * 0.1

def mm_pat(array):
    # Assuming array = [I, J, K]
    assert len(array) == 3, "Input array must have exactly 3 elements (I, J, K)"
    I, J, K = array
    array_out = np.array([I * K, K * J, I * J])
    return array_out

def gemm_result(array_size, tile_l0, tile_l1, tile_l2, BPE, AXI_WIDTH, IO_WIDTH, buf_sel):
  array_size = np.array(array_size)
  tile_l0 = np.array(tile_l0)
  tile_l1 = np.array(tile_l1)
  tile_l2 = np.array(tile_l2)
  buf_sel = np.array(buf_sel)
  
  tile_chip = tile_l0 * tile_l1 * tile_l2
  assert np.all(array_size % tile_chip == 0), "Schedule fails due to non-evenly divisible factors."
  tile_l3 = array_size // tile_chip
  
  # Set axi and plio width
  AXI_WIDTH_Bytes = AXI_WIDTH // 8
  IO_WIDTH_Bytes = IO_WIDTH // 8
  assert (AXI_WIDTH_Bytes%IO_WIDTH_Bytes == 0), "AXI width must be multiple of IO width."
  assert (tile_l0[2]*BPE%AXI_WIDTH_Bytes==0), "Packing LHS failed."
  assert (tile_l0[1]*BPE%AXI_WIDTH_Bytes==0), "Packing RHS & OUT failed."
  
  # Set buffer selection strategy
  BRAM_Depth = 512
  URAM_Depth = 4096
  RAM_WIDTH = 72
  buf_double = np.array([2, 2, 1])
  
  # Set DDR bandwidth (GB/s)
  DDR_I = 7
  DDR_O = 7
  DDR_LHS = DDR_GET_BW(DDR_I, tile_chip[2], BPE, AXI_WIDTH_Bytes)
  DDR_RHS = DDR_GET_BW(DDR_I, tile_chip[1], BPE, AXI_WIDTH_Bytes)
  DDR_OUT = DDR_GET_BW(DDR_O, tile_chip[1], BPE, AXI_WIDTH_Bytes)
  DDR_BW = np.array([DDR_LHS, DDR_RHS, DDR_OUT])
  
  # AIE Eff
  AIE_EFF = 0.9
  AIE_Freq = 1.25 # GHz
  if BPE == 4:
    SIMD = 8
  elif BPE == 2:
    SIMD = 32
  elif BPE == 1:
    SIMD = 128
  
  ###########################################################
  # Model Local RAM in AIE in KB
  Local_Mem = mm_pat(tile_l0) * BPE * 2 // 1024
  
  # Model PLIO
  PLIO = mm_pat(tile_l1)
  
  # Model AIE
  AIE = np.prod(tile_l1)
  
  # Model SRAM in PL
  AXI_BRAM = np.array([15, 15, 15])
  BRAM = mm_pat(tile_l1) * np.ceil(mm_pat(tile_l0 * tile_l2) * BPE / BRAM_Depth / IO_WIDTH_Bytes) * np.ceil(IO_WIDTH/RAM_WIDTH) * buf_double * buf_sel + AXI_BRAM 
  URAM = mm_pat(tile_l1) * np.ceil(mm_pat(tile_l0 * tile_l2) * BPE / URAM_Depth / IO_WIDTH_Bytes) * np.ceil(IO_WIDTH/RAM_WIDTH) * buf_double * (1-buf_sel)
  
  # Performance Cycle @ 1GHz => 1 ns
  l3_cycle = mm_pat(tile_chip) * BPE / DDR_BW
  # print("L3 Time:", np.ceil(l3_cycle))
  comp_cycle = np.prod(tile_chip) / SIMD / AIE / AIE_EFF / AIE_Freq
  max_read = np.max([l3_cycle[0], l3_cycle[1]])
  max_cycle = np.max([max_read, comp_cycle]) # Max among read LHS, RHS, comp
  all_cycle = max_read + (max_cycle * tile_l3[2] + l3_cycle[2]) * tile_l3[0] * tile_l3[1]
  gops = np.prod(array_size) * 2 / all_cycle
  peak_gops = AIE * SIMD * 2 * AIE_Freq
  utilization = gops / peak_gops
  print("LHS, RHS, OUT:")
  print("BRAM usage:", BRAM)
  print("URAM usage:", URAM)
  print("PLIO usage:", PLIO)
  print("\nOverall:")
  print("Total BRAM 18K usage:", np.sum(BRAM)*2)
  print("Total URAM usage:", np.sum(URAM))
  print("AIE core usage:", AIE)
  print("Total PLIO usage:", np.sum(PLIO))
  print(f"Throughput (GOPS): {gops:.2f}")
  print(f"MAC utilization: {utilization * 100:.2f}%")

############################# Below is for test ################################
def main():
    BPE = 4 # Byte per element
    AXI_WIDTH = 512
    IO_WIDTH = 128
    
    array_size = np.array([2816, 3072, 8192])  # I, J, K
    tile_l0 = np.array([32, 32, 32]) # TI, TJ, TK
    tile_l1 = np.array([11, 8, 4])   # PI, PJ, PK
    tile_l2 = np.array([4, 6, 1]) # BI, BJ, BK
    buf_sel = np.array([1, 1, 0]) # 0:URAM, 1:BRAM
    
    array_size = np.array([6144, 6144, 6144])  # I, J, K
    tile_l0 = np.array([32, 32, 32]) # TI, TJ, TK
    tile_l1 = np.array([12, 8, 3])   # PI, PJ, PK
    tile_l2 = np.array([4, 8, 1]) # BI, BJ, BK
    buf_sel = np.array([1, 1, 0]) # 0:URAM, 1:BRAM
    
    tile_l0 = np.array([32, 32, 32]) # TI, TJ, TK
    tile_l1 = np.array([7, 11, 4])   # PI, PJ, PK
    tile_l2 = np.array([7, 4, 2]) # BI, BJ, BK
    buf_sel = np.array([0, 1, 0]) # 0:URAM, 1:BRAM
    array_size = tile_l0 * tile_l1 * tile_l2 * np.array([2,2,64])
    
    # Case AIE=2
    array_size = np.array([6144, 6144, 6144])  # I, J, K
    tile_l0 = np.array([32, 32, 32]) # TI, TJ, TK
    tile_l1 = np.array([1, 2, 1])   # PI, PJ, PK
    tile_l2 = np.array([4, 4, 4]) # BI, BJ, BK
    buf_sel = np.array([0, 0, 0]) # 0:URAM, 1:BRAM
    
    # Case AIE=4
    array_size = np.array([6144, 6144, 6144])  # I, J, K
    tile_l0 = np.array([32, 32, 32]) # TI, TJ, TK
    tile_l1 = np.array([1, 2, 2])   # PI, PJ, PK
    tile_l2 = np.array([8, 8, 1]) # BI, BJ, BK
    buf_sel = np.array([1, 1, 0]) # 0:URAM, 1:BRAM
    
    # Case AIE=8
    array_size = np.array([6144, 6144, 6144]) # I, J, K
    tile_l0 = np.array([32, 32, 32]) # TI, TJ, TK
    tile_l1 = np.array([1, 4, 2]) # PI, PJ, PK
    tile_l2 = np.array([8, 4, 1]) # BI, BJ, BK
    buf_sel = np.array([1, 1, 0]) # 0:URAM, 1:BRAM
    
    # Case AIE=16
    array_size = np.array([6144, 6144, 6144])  # I, J, K
    tile_l0 = np.array([32, 32, 32]) # TI, TJ, TK
    tile_l1 = np.array([2, 4, 2])   # PI, PJ, PK
    tile_l2 = np.array([3, 3, 1]) # BI, BJ, BK
    buf_sel = np.array([1, 1, 1]) # 0:URAM, 1:BRAM
    
    # Case AIE=32
    array_size = np.array([6144, 6144, 6144])  # I, J, K
    tile_l0 = np.array([32, 32, 32]) # TI, TJ, TK
    tile_l1 = np.array([2, 8, 2])   # PI, PJ, PK
    tile_l2 = np.array([4, 2, 1]) # BI, BJ, BK
    buf_sel = np.array([1, 1, 1]) # 0:URAM, 1:BRAM
    
    # Case AIE=64
    array_size = np.array([6144, 6144, 6144])  # I, J, K
    tile_l0 = np.array([32, 32, 32]) # TI, TJ, TK
    tile_l1 = np.array([4, 8, 2])   # PI, PJ, PK
    tile_l2 = np.array([3, 3, 1]) # BI, BJ, BK
    buf_sel = np.array([1, 1, 1]) # 0:URAM, 1:BRAM
    
    # Case AIE=128
    array_size = np.array([6144, 6144, 6144])  # I, J, K
    tile_l0 = np.array([32, 32, 32]) # TI, TJ, TK
    tile_l1 = np.array([8, 8, 2])   # PI, PJ, PK
    tile_l2 = np.array([3, 6, 1]) # BI, BJ, BK
    buf_sel = np.array([1, 1, 0]) # 0:URAM, 1:BRAM
    
    # Case AIE=256
    array_size = np.array([6144, 6144, 6144])  # I, J, K
    tile_l0 = np.array([32, 32, 32]) # TI, TJ, TK
    tile_l1 = np.array([8, 8, 4])   # PI, PJ, PK
    tile_l2 = np.array([6, 6, 1]) # BI, BJ, BK
    buf_sel = np.array([1, 1, 0]) # 0:URAM, 1:BRAM
    
    # Case AIE=288
    array_size = np.array([6144, 6144, 6144])  # I, J, K
    tile_l0 = np.array([32, 32, 32]) # TI, TJ, TK
    tile_l1 = np.array([12, 6, 4])   # PI, PJ, PK
    tile_l2 = np.array([4, 8, 2]) # BI, BJ, BK
    buf_sel = np.array([1, 0, 0]) # 0:URAM, 1:BRAM
    
    
    # Case AIE=32_1
    array_size = np.array([6144, 6144, 6144])  # I, J, K
    tile_l0 = np.array([32, 32, 32]) # TI, TJ, TK
    tile_l1 = np.array([1, 8, 4])   # PI, PJ, PK
    tile_l2 = np.array([8, 4, 1]) # BI, BJ, BK
    buf_sel = np.array([1, 1, 1]) # 0:URAM, 1:BRAM
    
    # Case AIE=64_1
    array_size = np.array([6144, 6144, 6144])  # I, J, K
    tile_l0 = np.array([32, 32, 32]) # TI, TJ, TK
    tile_l1 = np.array([2, 8, 4])   # PI, PJ, PK
    tile_l2 = np.array([8, 4, 1]) # BI, BJ, BK
    buf_sel = np.array([1, 1, 0]) # 0:URAM, 1:BRAM
    
    # Case AIE=128_1
    array_size = np.array([6144, 6144, 6144])  # I, J, K
    tile_l0 = np.array([32, 32, 32]) # TI, TJ, TK
    tile_l1 = np.array([4, 8, 4])   # PI, PJ, PK
    tile_l2 = np.array([8, 4, 1]) # BI, BJ, BK
    buf_sel = np.array([1, 1, 0]) # 0:URAM, 1:BRAM
    
    # Case AIE=256_1
    array_size = np.array([6144, 6144, 6144])  # I, J, K
    tile_l0 = np.array([32, 32, 32]) # TI, TJ, TK
    tile_l1 = np.array([8, 8, 4])   # PI, PJ, PK
    tile_l2 = np.array([4, 8, 1]) # BI, BJ, BK
    buf_sel = np.array([1, 1, 0]) # 0:URAM, 1:BRAM
    
    # Case AIE=256_2
    array_size = np.array([6144, 6144, 6144])  # I, J, K
    tile_l0 = np.array([32, 32, 32]) # TI, TJ, TK
    tile_l1 = np.array([8, 8, 4])   # PI, PJ, PK
    tile_l2 = np.array([4, 8, 2]) # BI, BJ, BK
    buf_sel = np.array([1, 0, 0]) # 0:URAM, 1:BRAM
    
    print(array_size)
    gemm_result(array_size, tile_l0, tile_l1, tile_l2, BPE, AXI_WIDTH, IO_WIDTH, buf_sel)

if __name__ == "__main__":
    main()