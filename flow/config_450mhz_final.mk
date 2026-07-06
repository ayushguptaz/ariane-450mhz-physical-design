export DESIGN_NAME = ariane
export DESIGN_NICKNAME = ariane133
export PLATFORM    = nangate45

# RTL sources
export VERILOG_FILES = /work/rtl/ariane.sv2v.v \
                       /work/rtl/macros.v

# 450 MHz SDC
export SDC_FILE = /work/flow/ariane_450mhz.sdc

# SRAM macro
export ADDITIONAL_LEFS = $(PLATFORM_DIR)/lef/fakeram45_256x16.lef
export ADDITIONAL_LIBS = $(PLATFORM_DIR)/lib/fakeram45_256x16.lib

# OPTIMAL FLOORPLAN (from Run 8)
export DIE_AREA  = 0 0 1700 1700
export CORE_AREA = 10 12 1688 1688

# Optimal macro spacing
export MACRO_PLACE_HALO    = 15 15
export MACRO_PLACE_CHANNEL = 40 40

# Manual macro placement guidance (top/bottom heavy, right thin)
export MACRO_PLACEMENT = /work/constraints/macro_placement.tcl

# Pin placement with CLOCK AT CENTER
export IO_CONSTRAINTS = /work/constraints/io.tcl
export ADDITIONAL_IO_CONSTRAINTS = /work/constraints/clock_placement.tcl

# Routing layers
export MIN_ROUTING_LAYER = metal2
export MAX_ROUTING_LAYER = metal10

# Routing optimization (FAST validation mode)
export GLOBAL_ROUTE_ARGS = -allow_congestion -verbose -congestion_iterations 5
export DETAILED_ROUTE_ARGS = -droute_end_iter 4  # Fast validation (was 64 in slow runs)

# AGGRESSIVE SYNTHESIS FOR TIMING
export ABC_AREA = 0                    # Timing-only optimization
export MAX_FANOUT_CONSTRAINT = 12      # Force buffering on high-fanout nets
export SKIP_GATE_CLONING = 0           # Enable gate duplication
export SYNTH_HIERARCHICAL = 1

# AGGRESSIVE BUFFERING AT PLACEMENT (Ritik's suggestion)
export PLACE_DENSITY = 0.25            # Lower density for buffer space
export GPL_CELL_PADDING = 6            # Increased spacing (was 4)
export CELL_PAD_IN_SITES_DETAIL_PLACEMENT = 4  # More padding
export CELL_PAD_IN_SITES_GLOBAL_PLACEMENT = 4
export PLACE_DENSITY_LB_ADDON = 0.05
export TNS_END_PERCENT = 100
export SETUP_SLACK_MARGIN = 0.05       # Aggressive timing repair
export HOLD_SLACK_MARGIN = 0.05

# BALANCED CLOCK TREE SYNTHESIS (Ritik's suggestion)
export CTS_BUF_DISTANCE = 100          # Closer buffer spacing for balanced tree
export CTS_BALANCE_LEVELS = 1          # Force level balancing
export CTS_CLUSTER_SIZE = 30           # Smaller clusters = more balanced
export CTS_CLUSTER_DIAMETER = 100      # Tighter clustering
export CTS_SINK_CLUSTERING_ENABLE = 1  # Enable sink clustering
export CTS_SINK_CLUSTERING_SIZE = 30
export CTS_SINK_CLUSTERING_MAX_DIAMETER = 100

# Macro placer tuning
export RTLMP_MAX_LEVEL = 1
export RTLMP_MAX_MACRO = 30
export RTLMP_MIN_MACRO = 10
export RTLMP_MAX_INST = 80000
export RTLMP_MIN_INST = 8000

export GPL_RANDOM_SEED = 3
