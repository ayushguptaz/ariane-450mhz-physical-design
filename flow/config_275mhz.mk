export DESIGN_NAME = ariane
export DESIGN_NICKNAME = ariane133
export PLATFORM    = nangate45

# RTL sources from the assignment
export VERILOG_FILES = /work/rtl/ariane.sv2v.v \
                       /work/rtl/macros.v

# Timing constraints — 275 MHz target
export SDC_FILE = /work/flow/ariane_275mhz.sdc

# SRAM macro (fakeram45_256x16)
export ADDITIONAL_LEFS = $(PLATFORM_DIR)/lef/fakeram45_256x16.lef
export ADDITIONAL_LIBS = $(PLATFORM_DIR)/lib/fakeram45_256x16.lib

# Floorplan — explicit die/core area from assignment
export DIE_AREA  = 0 0 1500 1500
export CORE_AREA = 10 12 1448 1448

# Macro placement from assignment
export MACRO_PLACE_HALO    = 10 10
export MACRO_PLACE_CHANNEL = 20 20

# Pin placement exclusions from assignment
export IO_CONSTRAINTS = /work/constraints/io.tcl

# Routing layers: metal2 through metal10 (assignment spec)
export MIN_ROUTING_LAYER = metal2
export MAX_ROUTING_LAYER = metal10

# Global route — allow congestion per assignment hint
export GLOBAL_ROUTE_ARGS = -allow_congestion -verbose -congestion_iterations 5

# Detailed route — full iterations for best timing
export DETAILED_ROUTE_ARGS = -droute_end_iter 64

# Placement tuning
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
