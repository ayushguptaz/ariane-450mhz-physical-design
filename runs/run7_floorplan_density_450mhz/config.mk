export DESIGN_NAME = ariane
export DESIGN_NICKNAME = ariane133
export PLATFORM    = nangate45

# RTL sources from the assignment
export VERILOG_FILES = /work/rtl/ariane.sv2v.v \
                       /work/rtl/macros.v

# Timing constraints — 450 MHz target (full SDC)
export SDC_FILE = /work/runs/run7_floorplan_density_450mhz/ariane_run7.sdc

# SRAM macro (fakeram45_256x16)
export ADDITIONAL_LEFS = $(PLATFORM_DIR)/lef/fakeram45_256x16.lef
export ADDITIONAL_LIBS = $(PLATFORM_DIR)/lib/fakeram45_256x16.lib

# --- ISSUE #1/#2: raise density to shrink wires ---
# Assignment die is 1500x1500 (kept). Instead of changing area, push the
# placer to a higher target density so logic packs tighter (run3 showed
# ~51% util -> +13 MHz over the 36% runs).
export DIE_AREA  = 0 0 1500 1500
export CORE_AREA = 10 12 1448 1448
export PLACE_DENSITY = 0.55
export PLACE_DENSITY_LB_ADDON = 0.10

# --- ISSUE #3: macros on a UNIFORM red-line ring (fixes non-uniform macros) ---
export MACRO_PLACE_HALO    = 10 10
export MACRO_PLACE_CHANNEL = 20 20
export MACRO_PLACEMENT_TCL = /work/runs/run7_floorplan_density_450mhz/constraints/macro_placement.tcl

# Pin placement: assignment exclusions + clock port centered on left edge
# (self-contained copies live in this run's constraints/ folder)
export IO_CONSTRAINTS = /work/runs/run7_floorplan_density_450mhz/constraints/io.tcl
export ADDITIONAL_IO_CONSTRAINTS = /work/runs/run7_floorplan_density_450mhz/constraints/clock_placement.tcl

# Routing layers: metal2 through metal10
export MIN_ROUTING_LAYER = metal2
export MAX_ROUTING_LAYER = metal10

# --- timing- and routability-driven placement ---
export GPL_TIMING_DRIVEN = 1
export GPL_ROUTABILITY_DRIVEN = 1
export TNS_END_PERCENT = 100

# --- MORE BUFFERING in the placement stage (resizer repair_design) ---
# Extra cell padding opens room so the resizer can insert more repair buffers,
# and positive slack margins push it to buffer more aggressively.
export GPL_CELL_PADDING = 4
export CELL_PAD_IN_SITES_GLOBAL_PLACEMENT = 4
export CELL_PAD_IN_SITES_DETAIL_PLACEMENT = 2
export SETUP_SLACK_MARGIN = 0.05
export HOLD_SLACK_MARGIN  = 0.05

# --- BALANCED CLOCK TREE (TritonCTS) ---
# Tight, uniform sink clustering + level balancing => symmetric H-tree, low skew.
export CTS_BALANCE_LEVELS = 1
export CTS_CLUSTER_SIZE = 30
export CTS_CLUSTER_DIAMETER = 100
export CTS_SINK_CLUSTERING_ENABLE = 1
export CTS_SINK_CLUSTERING_SIZE = 30
export CTS_SINK_CLUSTERING_MAX_DIAMETER = 100

# Global route — allow congestion, more iterations for the denser layout
export GLOBAL_ROUTE_ARGS = -allow_congestion -verbose -congestion_iterations 10

# --- ISSUE #5: full detailed routing to clear shorts + recover timing ---
export DETAILED_ROUTE_ARGS = -droute_end_iter 64

# Hierarchical synthesis (helps with large designs)
export SYNTH_HIERARCHICAL = 1

# Macro placer tuning (from ORFS reference)
export RTLMP_MAX_LEVEL = 1
export RTLMP_MAX_MACRO = 30
export RTLMP_MIN_MACRO = 10
export RTLMP_MAX_INST = 80000
export RTLMP_MIN_INST = 8000

export SKIP_GATE_CLONING = 1
export GPL_RANDOM_SEED = 3
