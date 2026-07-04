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

# Floorplan — assignment spec
export DIE_AREA  = 0 0 1500 1500
export CORE_AREA = 10 12 1448 1448

# Macro placement
export MACRO_PLACE_HALO    = 10 10
export MACRO_PLACE_CHANNEL = 20 20

# Pin placement
export IO_CONSTRAINTS = /work/constraints/io.tcl

# Routing layers
export MIN_ROUTING_LAYER = metal2
export MAX_ROUTING_LAYER = metal10

# Global route
export GLOBAL_ROUTE_ARGS = -allow_congestion -verbose -congestion_iterations 5

# Detailed route
export DETAILED_ROUTE_ARGS = -droute_end_iter 64

# AGGRESSIVE SYNTHESIS PARAMETERS FOR TIMING
# Trade area for speed — we have 64% unused area
export ABC_AREA = 0                    # Disable area optimization (default is 1)
export MAX_FANOUT_CONSTRAINT = 12      # Force buffering on high-fanout nets
export SYNTH_HIERARCHICAL = 1
export PLACE_DENSITY_LB_ADDON = 0.05   # Reduce from 0.10 — allow denser placement for buffers
export TNS_END_PERCENT = 100

# Macro placer
export RTLMP_MAX_LEVEL = 1
export RTLMP_MAX_MACRO = 30
export RTLMP_MIN_MACRO = 10
export RTLMP_MAX_INST = 80000
export RTLMP_MIN_INST = 8000

export SKIP_GATE_CLONING = 0           # Enable gate cloning for timing
export GPL_RANDOM_SEED = 3
