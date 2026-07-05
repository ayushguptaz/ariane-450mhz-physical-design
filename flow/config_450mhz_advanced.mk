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

# OPTIMAL FLOORPLAN (from Run 8 - proven sweet spot)
export DIE_AREA  = 0 0 1700 1700
export CORE_AREA = 10 12 1688 1688

# Optimal macro spacing (from Run 8)
export MACRO_PLACE_HALO    = 15 15
export MACRO_PLACE_CHANNEL = 40 40

# Allow routing over macros on upper metal layers
export MACRO_PLACE_ALLOW_ROUTING_OVER = 1

# Pin placement
export IO_CONSTRAINTS = /work/constraints/io.tcl

# Routing layers
export MIN_ROUTING_LAYER = metal2
export MAX_ROUTING_LAYER = metal10

# Increased global routing iterations
export GLOBAL_ROUTE_ARGS = -allow_congestion -verbose -congestion_iterations 10

# Full detailed route with post-route optimization
export DETAILED_ROUTE_ARGS = -droute_end_iter 64

# AGGRESSIVE SYNTHESIS (from Run 6/7)
export ABC_AREA = 0                    # Timing-only optimization
export MAX_FANOUT_CONSTRAINT = 12      # Force buffering on high-fanout nets
export SKIP_GATE_CLONING = 0           # Enable gate duplication for timing
export SYNTH_HIERARCHICAL = 1

# ADVANCED PLACEMENT OPTIMIZATION
export GPL_TIMING_DRIVEN = 1           # Enable timing-driven placement
export GPL_ROUTABILITY_DRIVEN = 1      # Enable routability-driven placement
export GPL_CELL_PADDING = 4            # More space between cells for buffers
export GPL_ROUTABILITY_CHECK_OVERFLOW = 0.10

# Placement density
export PLACE_DENSITY = 0.25
export PLACE_DENSITY_LB_ADDON = 0.05
export TNS_END_PERCENT = 100

# Detailed placement optimization
export CELL_PAD_IN_SITES_DETAIL_PLACEMENT = 2

# ADVANCED CTS OPTIMIZATION
export CTS_CLUSTER_SIZE = 30           # Allow useful skew optimization
export CTS_CLUSTER_DIAMETER = 100

# POST-ROUTE OPTIMIZATION
export ENABLE_DPO = 1                  # Enable detailed placement optimization after routing
export DPO_MAX_DISPLACEMENT = 15       # Allow small cell moves to fix timing

# Macro placer tuning
export RTLMP_MAX_LEVEL = 1
export RTLMP_MAX_MACRO = 30
export RTLMP_MIN_MACRO = 10
export RTLMP_MAX_INST = 80000
export RTLMP_MIN_INST = 8000

export GPL_RANDOM_SEED = 3
