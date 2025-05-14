# The shell script you want to run
GEN_SCRIPT = gen_design.sh
RUN_SCRIPT = run_design.sh
COLLECT_SCRIPT := collect_result.sh

# Default target
all: gen run collect

# Run the script
gen:
	@chmod +x $(GEN_SCRIPT)
	@./$(GEN_SCRIPT)

run:
	@chmod +x $(RUN_SCRIPT)
	@./$(RUN_SCRIPT)

collect:
	@chmod +x $(COLLECT_SCRIPT)
	@./$(COLLECT_SCRIPT)

# Clean generated files
clean:
	rm -rf gemm_*