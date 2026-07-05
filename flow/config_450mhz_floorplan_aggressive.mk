export DESIGN_NAME = ariane
export DESIGN_NICKNAME = ariane133
export PLATFORM    = nangate45

# RTL sources
export VERILOG_FILES = /work/rtl/ariane.sv2v.v \
                       /work/rtl/macros.v

# Full SDC with I/O delays
export SDC_FILE = /work/flow/ariane_450mhz.sdc

# SRAM macro
export ADDITIONAL_LEFS = $(PLATFORM_DIR)/lef/fakeram45_256x16.lef
export ADDITIONAL_LIBS = $(PLATFORM_DIR)/lib/fakeram45_256x16.lib

# FLOORPLAN OPTIMIZATION: Aggressive approach (target 450 MHz)
# Significantly larger die area to eliminate macro congestion
export DIE_AREA  = 0 0 2000 2000
export CORE_AREA = 10 12 1988 1988

# Wide macro spacing for optimal routing
export MACRO_PLACE_HALO    = 20 20      # 2x original (10 → 20)
export MACRO_PLACE_CHANNEL = 50 50      # 2.5x original (20 → 50)

# Pin placement
export IO_CONSTRAINTS = /work/constraints/io.tcl

# Routing layers
export MIN_ROUTING_LAYER = metal2
export MAX_ROUTING_LAYER = metal10

# Increased global routing iterations
export GLOBAL_ROUTE_ARGS = -allow_congestion -verbose -congestion_iterations 10

# Full detailed route
export DETAILED_ROUTE_ARGS = -droute_end_iter 64

# Target lower utilization for timing (CORE_UTILIZATION conflicts with explicit CORE_AREA, using density only)
export PLACE_DENSITY = 0.25
export PLACE_DENSITY_LB_ADDON = 0.05
export TNS_END_PERCENT = 100

# Enable timing-driven placement
export GPL_TIMING_DRIVEN = 1
export GPL_ROUTABILITY_DRIVEN = 1

# Hierarchical synthesis
export SYNTH_HIERARCHICAL = 1

# Macro placer tuning
export RTLMP_MAX_LEVEL = 1
export RTLMP_MAX_MACRO = 30
export RTLMP_MIN_MACRO = 10
export RTLMP_MAX_INST = 80000
export RTLMP_MIN_INST = 8000

export SKIP_GATE_CLONING = 1
export GPL_RANDOM_SEED = 3
