export DESIGN_NAME = ariane
export DESIGN_NICKNAME = ariane133
export PLATFORM    = nangate45

# RTL sources from the assignment
export VERILOG_FILES = /work/rtl/ariane.sv2v.v \
                       /work/rtl/macros.v

# Timing constraints — 333 MHz target
export SDC_FILE = /work/flow/ariane_333mhz.sdc

# SRAM macro (fakeram45_256x16)
export ADDITIONAL_LEFS = $(PLATFORM_DIR)/lef/fakeram45_256x16.lef
export ADDITIONAL_LIBS = $(PLATFORM_DIR)/lib/fakeram45_256x16.lib

# Floorplan — use utilization-based (like ORFS reference)
export CORE_UTILIZATION = 50
export CORE_ASPECT_RATIO = 1
export CORE_MARGIN = 5

# Macro placement (matching ORFS reference)
export MACRO_PLACE_HALO    = 8 8

# Pin placement exclusions
export IO_CONSTRAINTS = /work/constraints/io.tcl

# Routing layers: metal2 through metal10
export MIN_ROUTING_LAYER = metal2
export MAX_ROUTING_LAYER = metal10

# Global route — allow congestion per assignment hint
export GLOBAL_ROUTE_ARGS = -allow_congestion -verbose -congestion_iterations 5

# Detailed route — full iterations for best timing
export DETAILED_ROUTE_ARGS = -droute_end_iter 64

# Placement tuning
export PLACE_DENSITY_LB_ADDON = 0.10
export TNS_END_PERCENT = 100

# Skip gate cloning (matches ORFS reference)
export SKIP_GATE_CLONING = 1

# Hierarchical synthesis
export SYNTH_HIERARCHICAL = 1

# Macro placer tuning (from ORFS reference)
export RTLMP_MAX_LEVEL = 1
export RTLMP_MAX_MACRO = 30
export RTLMP_MIN_MACRO = 10
export RTLMP_MAX_INST = 80000
export RTLMP_MIN_INST = 8000

export GPL_RANDOM_SEED = 3
