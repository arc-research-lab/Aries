  func.func @softmax(%arg0: {{shapeType}}, %arg1: {{shapeType}}) attributes {adf.pl, adf.pl.lib} {
    %cst = arith.constant 0.000000e+00 : f32
    %cst_0 = arith.constant 0xFF800000 : f32   // Smallest number of fp32
    %buffer0 = memref.alloc() : memref<{{last_dim}}xf32> // Store one row of input
    %buffer1 = memref.alloc() : memref<{{last_dim}}xf32> // Store one row of exp
    %max_val = memref.alloc() : memref<1xf32>
    %exp_sum = memref.alloc() : memref<1xf32>

    {% for i in range(rank-1) -%}
    {% set loop_var = 'loop' ~ i -%}
    {% set loop_upper_bound = shape[i] -%}
    affine.for %{{ loop_var }} = 0 to {{ loop_upper_bound }} {
    {% endfor -%}
    
    {% set loop_vars = [] -%}
    {% for i in range(rank-1) -%}
    {% set loop_var = '%loop' ~ i -%}
    {% do loop_vars.append(loop_var) -%}
    {% endfor -%}
    {% set joined_indices = loop_vars|join(', ') %}
    // Load one row of data into buffer
    affine.for %arg4 = 0 to {{last_dim}} {
      %0 = affine.load %arg0[{{joined_indices}}, %arg4] : {{shapeType}}
      affine.store %0, %buffer0[%arg4] : memref<{{last_dim}}xf32>
    } {pipeline_ii = 1 : index}

    // Find the maximum of this row
    affine.store %cst_0, %max_val[0] : memref<1xf32>
    affine.for %arg4 = 0 to {{last_dim}} {
      %0 = affine.load %buffer0[%arg4] : memref<{{last_dim}}xf32>
      %1 = affine.load %max_val[0] : memref<1xf32>
      %2 = arith.maximumf %0, %1 : f32
      affine.store %2, %max_val[0] : memref<1xf32>
    } {pipeline_ii = 1 : index}

    // Calculate sub and exp
    affine.for %arg4 = 0 to {{last_dim}} {
      %0 = affine.load %buffer0[%arg4] : memref<{{last_dim}}xf32>
      %1 = affine.load %max_val[0] : memref<1xf32>
      %2 = arith.subf %0, %1 : f32
      %3 = math.exp %2 : f32
      affine.store %3, %buffer1[%arg4] : memref<{{last_dim}}xf32>
    } {pipeline_ii = 1 : index}

    // Calculate exp sum
    affine.store %cst, %exp_sum[0] : memref<1xf32>
    affine.for %arg4 = 0 to {{last_dim}} {
      %0 = affine.load %buffer1[%arg4] : memref<{{last_dim}}xf32>
      %1 = affine.load %exp_sum[0] : memref<1xf32>
      %2 = arith.addf %0, %1 : f32
      affine.store %2, %exp_sum[0] : memref<1xf32>
    } {pipeline_ii = 1 : index}

    // Calculate division
    affine.for %arg4 = 0 to {{last_dim}} {
      %0 = affine.load %buffer1[%arg4] : memref<{{last_dim}}xf32>
      %1 = affine.load %exp_sum[0] : memref<1xf32>
      %2 = arith.divf %0, %1 : f32
      affine.store %2, %arg1[{{joined_indices}}, %arg4] : {{shapeType}}
    } {pipeline_ii = 1 : index}
    {% for i in range(rank-1) -%}
    }
    {% endfor -%}
    return
  }