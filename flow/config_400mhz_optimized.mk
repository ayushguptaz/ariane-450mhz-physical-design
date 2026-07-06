export DESIGN_NAME = ariane
export DESIGN_NICKNAME = ariane133
export PLATFORM    = nangate45

# RTL sources
export VERILOG_FILES = /work/rtl/ariane.sv2v.v \
                       /work/rtl/macros.v

# 400 MHz SDC
export SDC_FILE = /work/flow/ariane_400mhz.sdc

# SRAM macro
export ADDITIONAL_LEFS = $(PLATFORM_DIR)/lef/fakeram45_256x16.lef
export ADDITIONAL_LIBS = $(PLATFORM_DIR)/lib/fakeram45_256x16.lib

# OPTIMAL FLOORPLAN (from Run 8 - proven sweet spot)
export DIE_AREA  = 0 0 1700 1700
export CORE_AREA = 10 12 1688 1688

# Optimal macro spacing
export MACRO_PLACE_HALO    = 15 15
export MACRO_PLACE_CHANNEL = 40 40

# Manual macro placement guidance
export MACRO_PLACEMENT = /work/constraints/macro_placement.tcl

# Pin placement - spread pins in center, avoid corners
export IO_CONSTRAINTS = /work/constraints/io.tcl

# Routing layers
export MIN_ROUTING_LAYER = metal2
export MAX_ROUTING_LAYER = metal10

# Aggressive global routing
export GLOBAL_ROUTE_ARGS = -allow_congestion -verbose -congestion_iterations 10

# Full detailed route
export DETAILED_ROUTE_ARGS = -droute_end_iter 64

# AGGRESSIVE SYNTHESIS FOR TIMING
export ABC_AREA = 0                    # Timing-only optimization
export MAX_FANOUT_CONSTRAINT = 12      # Force buffering on high-fanout nets
export SKIP_GATE_CLONING = 0           # Enable gate duplication
export SYNTH_HIERARCHICAL = 1

# OPTIMIZED PLACEMENT FOR WIRE LENGTH MINIMIZATION
export PLACE_DENSITY = 0.30            # Slightly higher density (more room in center)
export PLACE_DENSITY_LB_ADDON = 0.08
export TNS_END_PERCENT = 100

# Macro placer tuning
export RTLMP_MAX_LEVEL = 1
export RTLMP_MAX_MACRO = 30
export RTLMP_MIN_MACRO = 10
export RTLMP_MAX_INST = 80000
export RTLMP_MIN_INST = 8000

export GPL_RANDOM_SEED = 3
