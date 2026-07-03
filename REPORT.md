# Ariane133 Physical Design Report — 450 MHz Target on Nangate45

## Tool Versions & Setup

| Tool | Version |
|------|---------|
| Yosys | 0.63 (git sha1 70a11c6bf) |
| OpenROAD | 26Q1-2900-gdf79404cd8 |
| Platform | Nangate45 / FreePDK45 |
| Docker Image | openroad/flow-ubuntu22.04-builder:latest |
| Compute | AWS EC2 c5.2xlarge (8 vCPU, 16 GB RAM) |
| OS | Ubuntu 22.04 LTS |

## Flow Summary

The design was run through the full RTL-to-GDSII flow using OpenROAD-flow-scripts (Makefile-based):

| Stage | Tool | Runtime | Status |
|-------|------|---------|--------|
| 1. Synthesis | Yosys | ~5 min | ✅ Complete |
| 2. Floorplan | OpenROAD | ~1 min | ✅ Complete |
| 3. Placement | OpenROAD (GPL) | ~40 min | ✅ Complete |
| 4. CTS | OpenROAD (TritonCTS) | ~20 min | ✅ Complete |
| 5. Global Route | OpenROAD (FastRoute) | ~10 min | ✅ Complete |
| 6. Detailed Route | OpenROAD (TritonRoute) | ~30 min | ✅ Complete |

Total wall-clock time: approximately 3 hours (including timing repair iterations).

## Commands Used

```bash
# Inside Docker container
export PATH=/OpenROAD-flow-scripts/tools/install/OpenROAD/bin:$PATH
cd /OpenROAD-flow-scripts/flow
make DESIGN_CONFIG=./designs/nangate45/ariane_archgen/config.mk
```

The flow configuration (`config.mk`) and SDC are provided in the `flow/` directory.

## Timing Results

| Metric | Value |
|--------|-------|
| **Target Clock Period** | 2.222 ns (450 MHz) |
| **Achieved fmax** | 269.8 MHz (period = 3.71 ns) |
| **WNS (Worst Negative Slack)** | -1.485 ns |
| **TNS (Total Negative Slack)** | -4898.9 ns |
| **Setup Violations** | 6509 endpoints |
| **Hold Violations** | 0 |
| **Clock Skew** | 0.181 ns |

**The design does not close timing at 450 MHz.** The achieved frequency is ~270 MHz. This is expected — the OpenROAD-flow-scripts reference for Ariane133 targets 333 MHz (3.0 ns period), and even that is challenging. Pushing to 450 MHz (35% faster) exceeds what the Nangate45 standard cells and this floorplan can deliver without architectural changes.

### Worst Path

The critical path runs through the scoreboard in the issue stage:
```
issue_stage_i.i_scoreboard/mem_q[...]$_DFF_PN0_/D
```

This is a large register file with deep combinational logic — the bottleneck is inherent to the Ariane microarchitecture at this technology node.

## Design Statistics

| Metric | Value |
|--------|-------|
| Die Area | 1500 × 1500 µm (2.25 mm²) |
| Core Area | 1438 × 1436 µm (2.06 mm²) |
| Core Utilization | 36.1% |
| Standard Cell Utilization | 19.9% |
| Total Instances | 193,566 (std cells: 193,434 + macros: 132) |
| SRAM Macros | 132 × fakeram45_256x16 |
| Clock Buffers | 5,337 |
| Timing Repair Buffers | 26,535 |
| Total Power | 0.345 W |
| DRC Violations (post-route) | 19 shorts (metal5/metal6) |

## Constraints Used

Based on the assignment-provided `physical_hints.tcl`:

- **Die area**: 0 0 1500 1500
- **Core area**: 10 12 1448 1448
- **Macro halo**: 10 µm
- **Macro channel**: 20 µm
- **Routing layers**: metal2 – metal10
- **Global route**: allow_congestion, 5 congestion iterations
- **Detailed route**: droute_end_iter 4
- **Pin exclusion**: left:0-500, left:1000-1500, right:*, top:*, bottom:*

### SDC Constraints

```tcl
set clk_period 2.222
create_clock -name core_clock -period $clk_period [get_ports clk_i]
set_clock_latency 0.535 [get_clocks core_clock]
set_input_delay  [expr $clk_period * 0.20] -clock vclk_core_clock [all_inputs -no_clocks]
set_output_delay [expr $clk_period * 0.20] -clock vclk_core_clock [all_outputs]
```

A virtual clock (`vclk_core_clock`) was used for I/O timing, following the OpenROAD-flow-scripts convention.

## Changes from Provided Constraints

1. **SDC expanded**: The provided `constraints/ariane_450mhz.sdc` only had a clock definition. I added input/output delays (20% of clock period), clock source latency (0.535 ns), and a virtual clock for I/O timing — all per the assignment specification.

2. **SYNTH_HIERARCHICAL = 1**: Enabled hierarchical synthesis to help Yosys handle the large design more efficiently.

3. **RTLMP macro placer tuning**: Added parameters (`RTLMP_MAX_LEVEL=1`, `RTLMP_MAX_MACRO=30`, etc.) from the OpenROAD-flow-scripts reference to guide SRAM macro placement.

4. **No die/core area changes**: Used the exact areas specified in the assignment.

## What Would Improve Timing

To close at 450 MHz, the following approaches could be explored:

1. **Increase die area** (e.g., 1800×1800) — more space reduces wire delay and congestion
2. **Multi-corner optimization** — run with fast/slow corners for better hold/setup balance
3. **Pipeline the scoreboard** — the critical path is architectural; retiming or adding pipeline stages in the issue scoreboard would be needed
4. **Higher droute iterations** — we used 4; increasing to 16-32 may fix DRC violations and improve post-route timing
5. **Target 333 MHz first** — validate the flow at the reference clock, then incrementally tighten

## Artifacts

```
runs/run2_c5_2xlarge_complete/
├── flow.log              — Full flow output log
├── reports/base/         — All stage reports + timing
│   ├── 6_finish.rpt     — Final timing/power/area report
│   ├── 5_route_drc.rpt  — Post-route DRC violations
│   └── *.webp           — Layout visualizations
├── logs/base/            — Per-stage logs and metrics JSON
│   ├── 6_report.json    — Machine-readable final metrics
│   └── *.log            — Individual stage logs
flow/
├── config.mk            — Flow configuration
└── ariane_450mhz.sdc    — Timing constraints (450 MHz)
```

The routed DEF (`6_final.def`, 213 MB) and ODB are available on request but excluded from the repository due to size.

## Prior Run (OOM)

An initial attempt on c5.xlarge (8 GB RAM) completed through global routing but was OOM-killed during detailed routing (peak memory: 7.45 GB). The run was retried on c5.2xlarge (16 GB) which completed successfully.
