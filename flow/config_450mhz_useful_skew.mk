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

# OPTIMAL FLOORPLAN (Run 8 proven)
export DIE_AREA  = 0 0 1700 1700
export CORE_AREA = 10 12 1688 1688
export MACRO_PLACE_HALO    = 15 15
export MACRO_PLACE_CHANNEL = 40 40

# Pin/IO
export IO_CONSTRAINTS = /work/constraints/io.tcl

# Routing
export MIN_ROUTING_LAYER = metal2
export MAX_ROUTING_LAYER = metal10
export GLOBAL_ROUTE_ARGS = -allow_congestion -verbose -congestion_iterations 5
export DETAILED_ROUTE_ARGS = -droute_end_iter 4

# SYNTHESIS
export ABC_AREA = 0
export MAX_FANOUT_CONSTRAINT = 12
export SKIP_GATE_CLONING = 0
export SYNTH_HIERARCHICAL = 1

# PLACEMENT
export PLACE_DENSITY = 0.30
export PLACE_DENSITY_LB_ADDON = 0.08
export TNS_END_PERCENT = 100

# USEFUL SKEW CTS - THE KEY OPTIMIZATION
# Allow clock skew to help setup timing (borrow time from non-critical paths)
export CTS_CLUSTER_SIZE = 20                       # Smaller clusters = more skew control
export CTS_CLUSTER_DIAMETER = 60                   # Tighter = more useful skew
export ENABLE_CTS_USEFUL_SKEW = 1                  # Enable useful skew
export CTS_TARGET_SKEW = 0.15                      # Allow up to 150ps skew
export CTS_SINK_CLUSTERING_ENABLE = 1
export CTS_SINK_CLUSTERING_SIZE = 20
export CTS_SINK_CLUSTERING_MAX_DIAMETER = 60

# AGGRESSIVE TIMING REPAIR
export SETUP_SLACK_MARGIN = 0.1                    # Very aggressive
export HOLD_SLACK_MARGIN = 0.05
export RECOVER_POWER = 0                           # Disable power recovery (pure timing)

# Macro placer
export RTLMP_MAX_LEVEL = 1
export RTLMP_MAX_MACRO = 30
export RTLMP_MIN_MACRO = 10
export RTLMP_MAX_INST = 80000
export RTLMP_MIN_INST = 8000

export GPL_RANDOM_SEED = 3
