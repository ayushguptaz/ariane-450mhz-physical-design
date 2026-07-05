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

# FLOORPLAN OPTIMIZATION: Conservative approach
# Increase die area to reduce macro congestion
export DIE_AREA  = 0 0 1700 1700
export CORE_AREA = 10 12 1688 1688

# Increase macro spacing for better routing
export MACRO_PLACE_HALO    = 15 15      # Increased from 10 (50% more space around macros)
export MACRO_PLACE_CHANNEL = 40 40      # Increased from 20 (2x wider channels between macros)

# Pin placement
export IO_CONSTRAINTS = /work/constraints/io.tcl

# Routing layers
export MIN_ROUTING_LAYER = metal2
export MAX_ROUTING_LAYER = metal10

# Increase global routing iterations for better congestion resolution
export GLOBAL_ROUTE_ARGS = -allow_congestion -verbose -congestion_iterations 10

# Full detailed route
export DETAILED_ROUTE_ARGS = -droute_end_iter 64

# Placement optimization for timing
export PLACE_DENSITY_LB_ADDON = 0.10
export TNS_END_PERCENT = 100

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
