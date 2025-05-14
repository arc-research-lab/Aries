## GEMM Performance Test on Ryzen AI NPU (`int16`)

The following is the directory structure for the performance testing of GEMM with the `int16` data type on the Ryzen AI NPU:

- `gen_design.sh`  
  *Script to generate ARIES Python designs with various matrix and PE sizes.*

- `run_design.sh`  
  *Script to run all generated designs on the NPU.*

- `collect_result.sh`  
  *Script to collect experimental results into `summary_results.txt`.*

- `Makefile`  
  *Provides `make gen`, `make run`, and `make collect` to invoke the corresponding scripts.*

- `template_gemm.py`  
  *Template for the ARIES Python design.*

- `generate_gemm.py`  
  *Python script called by `gen_design.sh` to generate GEMM designs.*

- `summary_results.txt`  
  *File containing collected results.*

---

### Usage

To run the full test workflow, generating designs, executing them, and collecting results, use the following commands:

```sh
make gen
make run
make collect
```

This example generates square GEMM designs with sizes ranging from powers of two between 256 and 4096, using NPU with shapes of 2×2, 2×4, and 4×4.