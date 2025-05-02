module{
  func.func @softmax(%arg0: memref<4x8x16xf32>, %arg1: memref<4x8x16xf32>) attributes {adf.pl} {
    %cst = arith.constant 0.000000e+00 : f32
    %cst_0 = arith.constant 0xFF800000 : f32   // Smallest number of fp32
    %buffer0 = memref.alloc() : memref<16xf32> // Store one row of input
    %buffer1 = memref.alloc() : memref<16xf32> // Store one row of exp
    %max_val = memref.alloc() : memref<1xf32>
    %exp_sum = memref.alloc() : memref<1xf32>

    affine.for %arg2 = 0 to 4 {
      affine.for %arg3 = 0 to 8 {

        // Load one row of data into buffer
        affine.for %arg4 = 0 to 16 {
          %0 = affine.load %arg0[%arg2, %arg3, %arg4] : memref<4x8x16xf32>
          affine.store %0, %buffer0[%arg4] : memref<16xf32>
        } {pipeline_ii = 1 : index}

        // Find the maximum of this row
        affine.store %cst_0, %max_val[0] : memref<1xf32>
        affine.for %arg4 = 0 to 16 {
          %0 = affine.load %buffer0[%arg4] : memref<16xf32>
          %1 = affine.load %max_val[0] : memref<1xf32>
          %2 = arith.maximumf %0, %1 : f32
          affine.store %2, %max_val[0] : memref<1xf32>
        } {pipeline_ii = 1 : index}

        // Calculate sub and exp
        affine.for %arg4 = 0 to 16 {
          %0 = affine.load %buffer0[%arg4] : memref<16xf32>
          %1 = affine.load %max_val[0] : memref<1xf32>
          %2 = arith.subf %0, %1 : f32
          %3 = math.exp %2 : f32
          affine.store %3, %buffer1[%arg4] : memref<16xf32>
        } {pipeline_ii = 1 : index}

        // Calculate exp sum
        affine.store %cst, %exp_sum[0] : memref<1xf32>
        affine.for %arg4 = 0 to 16 {
          %0 = affine.load %buffer1[%arg4] : memref<16xf32>
          %1 = affine.load %exp_sum[0] : memref<1xf32>
          %2 = arith.addf %0, %1 : f32
          affine.store %2, %exp_sum[0] : memref<1xf32>
        } {pipeline_ii = 1 : index}

        // Calculate division
        affine.for %arg4 = 0 to 16 {
          %0 = affine.load %buffer1[%arg4] : memref<16xf32>
          %1 = affine.load %exp_sum[0] : memref<1xf32>
          %2 = arith.divf %0, %1 : f32
          affine.store %2, %arg1[%arg2, %arg3, %arg4] : memref<4x8x16xf32>
        } {pipeline_ii = 1 : index}
        
      }
    }
    return
  }
}