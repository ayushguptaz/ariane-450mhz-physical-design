export DESIGN_NAME = ariane
export DESIGN_NICKNAME = ariane133
export PLATFORM    = nangate45

# RTL sources from the assignment
export VERILOG_FILES = /work/rtl/ariane.sv2v.v \
                       /work/rtl/macros.v

# 400 MHz target (2.5 ns) — realistic aggressive budget per research
export SDC_FILE = /work/runs/run8_human_placement_400mhz/ariane_run8.sdc

# SRAM macro (fakeram45_256x16)
export ADDITIONAL_LEFS = $(PLATFORM_DIR)/lef/fakeram45_256x16.lef
export ADDITIONAL_LIBS = $(PLATFORM_DIR)/lib/fakeram45_256x16.lib

# --- SYNTHESIS: hierarchical (flat is BROKEN for this netlist) ---
# Tested SYNTH_HIERARCHICAL=0: Yosys flatten+opt DELETED all 88 nbdcache SRAMs
# (only the 44 icache fakerams survived — caught by the macro-count assertion
# in macro_placement.tcl). Flat synthesis is not usable on this testcase.
export SYNTH_HIERARCHICAL = 1

# Assignment floorplan (die/core fixed)
export DIE_AREA  = 0 0 1500 1500
export CORE_AREA = 10 12 1448 1448

# --- LEVER 2: HUMAN (JUNG-STYLE) DATAFLOW MACRO PLACEMENT ---
# Ported from TILOS MacroPlacement place_srams.tcl: dataflow grouping,
# R0/MY pin-side mirroring, tight arrays, center open toward the left pins.
export MACRO_PLACEMENT_TCL = /work/runs/run8_human_placement_400mhz/constraints/macro_placement.tcl
export MACRO_PLACE_HALO    = 5 5

# Pin placement: assignment exclusions + clk_i centered (balanced clock entry)
export IO_CONSTRAINTS = /work/runs/run8_human_placement_400mhz/constraints/io.tcl

# Routing layers: metal2 through metal10
export MIN_ROUTING_LAYER = metal2
export MAX_ROUTING_LAYER = metal10

# --- proven knobs from run7 (timing-driven, buffering headroom) ---
export GPL_TIMING_DRIVEN = 1
export GPL_ROUTABILITY_DRIVEN = 1
export TNS_END_PERCENT = 100
export PLACE_DENSITY_LB_ADDON = 0.10
export CELL_PAD_IN_SITES_GLOBAL_PLACEMENT = 4
export CELL_PAD_IN_SITES_DETAIL_PLACEMENT = 2
export SETUP_SLACK_MARGIN = 0.05
export HOLD_SLACK_MARGIN  = 0.05

# --- LEVER 3: BALANCED CLOCK TREE = TritonCTS DEFAULTS ---
# run7 proved custom CTS clustering hurts (964-buffer tree, skew 0.27 vs 0.18).
# Defaults + centered clk_i give the balanced tree. No CTS_* overrides.

# Global route — more effort
export GLOBAL_ROUTE_ARGS = -allow_congestion -verbose -congestion_iterations 10

# Full detailed routing (proved 0-DRC in run7)
export DETAILED_ROUTE_ARGS = -droute_end_iter 64

# Macro placer tuning (harmless; our TCL locks all macros so RTLMP is a no-op)
export RTLMP_MAX_LEVEL = 1
export RTLMP_MAX_MACRO = 30
export RTLMP_MIN_MACRO = 10
export RTLMP_MAX_INST = 80000
export RTLMP_MIN_INST = 8000

export SKIP_GATE_CLONING = 1
export GPL_RANDOM_SEED = 3
