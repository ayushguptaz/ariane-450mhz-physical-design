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

# OPTIMAL FLOORPLAN
export DIE_AREA  = 0 0 1700 1700
export CORE_AREA = 10 12 1688 1688

# Optimal macro spacing
export MACRO_PLACE_HALO    = 15 15
export MACRO_PLACE_CHANNEL = 40 40

# Manual macro placement guidance
export MACRO_PLACEMENT = /work/constraints/macro_placement.tcl

# Pin placement with CLOCK AT CENTER
export IO_CONSTRAINTS = /work/constraints/io.tcl
export ADDITIONAL_IO_CONSTRAINTS = /work/constraints/clock_placement.tcl

# Routing layers
export MIN_ROUTING_LAYER = metal2
export MAX_ROUTING_LAYER = metal10

# AGGRESSIVE SYNTHESIS
export ABC_AREA = 0
export MAX_FANOUT_CONSTRAINT = 12
export SKIP_GATE_CLONING = 0
export SYNTH_HIERARCHICAL = 1

# AGGRESSIVE BUFFERING
export PLACE_DENSITY = 0.25
export GPL_CELL_PADDING = 6
export CELL_PAD_IN_SITES_DETAIL_PLACEMENT = 4
export CELL_PAD_IN_SITES_GLOBAL_PLACEMENT = 4
export PLACE_DENSITY_LB_ADDON = 0.05
export TNS_END_PERCENT = 100
export SETUP_SLACK_MARGIN = 0.05
export HOLD_SLACK_MARGIN = 0.05

# BALANCED CLOCK TREE SYNTHESIS
export CTS_BUF_DISTANCE = 100
export CTS_BALANCE_LEVELS = 1
export CTS_CLUSTER_SIZE = 30
export CTS_CLUSTER_DIAMETER = 100
export CTS_SINK_CLUSTERING_ENABLE = 1
export CTS_SINK_CLUSTERING_SIZE = 30
export CTS_SINK_CLUSTERING_MAX_DIAMETER = 100

# Macro placer tuning
export RTLMP_MAX_LEVEL = 1
export RTLMP_MAX_MACRO = 30
export RTLMP_MIN_MACRO = 10
export RTLMP_MAX_INST = 80000
export RTLMP_MIN_INST = 8000

export GPL_RANDOM_SEED = 3
