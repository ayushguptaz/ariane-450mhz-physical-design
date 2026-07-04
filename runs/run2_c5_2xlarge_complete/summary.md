# Run 2: 450 MHz Target — Complete Flow on c5.2xlarge

## Instance
- Type: c5.2xlarge (8 vCPU, 16 GB RAM)
- Region: ap-south-1
- Date: 2026-07-03
- Docker Image: openroad/flow-ubuntu22.04-builder:latest
- Tools: Yosys 0.63, OpenROAD 26Q1-2900-gdf79404cd8

## Configuration
- Target: 450 MHz (2.222 ns clock period)
- Clock: `core_clock` on port `clk_i`
- Clock latency: 0.535 ns
- I/O delay: 20% of period (0.444 ns)
- Die area: 0 0 1500 1500 µm
- Core area: 10 12 1448 1448 µm
- Macro halo: 10 µm
- Macro channel: 20 µm
- Routing layers: metal2–metal10
- Global route: allow_congestion, 5 congestion iterations
- Detailed route: droute_end_iter 4
- SRAM macro: fakeram45_256x16 (132 instances)

## All Stages Completed
1. Synthesis ✅ (~5 min)
2. Floorplan ✅ (~1 min)
3. Placement ✅ (~40 min)
4. CTS ✅ (~20 min)
5. Global Route ✅ (~10 min)
6. Detailed Route ✅ (~30 min)

Total runtime: ~3 hours

## Timing Results

| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| Clock period | 2.222 ns | 2.222 ns | ✅ Set correctly |
| WNS (setup) | -1.485 ns | ≥ 0 | ❌ Violated |
| TNS (setup) | -4898.9 ns | = 0 | ❌ Violated |
| Setup violation count | 6509 endpoints | 0 | ❌ Violated |
| WNS (hold) | +0.011 ns | ≥ 0 | ✅ Met |
| TNS (hold) | 0 | = 0 | ✅ Met |
| Hold violation count | 0 | 0 | ✅ Met |
| Clock skew | 0.181 ns | — | Acceptable |
| Achieved fmax | 269.8 MHz | 450 MHz | ❌ 60% of target |

## Worst Critical Paths

| # | Start → End | Slack | Module |
|---|-------------|-------|--------|
| 1 | `scoreboard/commit_pointer_q[1]` → `scoreboard/mem_q[2693]` | -1.48 ns | Issue scoreboard (reg-to-reg) |
| 2 | `nbdcache/miss_handler/state_q[2]` → `axi_req_o[130]` | -0.89 ns | Cache → AXI output port |

### Worst Path Detail (Path #1)
- Data arrival time: 4.31 ns
- Data required time: 2.83 ns
- Slack: 2.83 - 4.31 = -1.48 ns
- Logic depth: ~70 gates
- Crosses modules: scoreboard → CSR regfile → execute stage → issue_read_operands → scoreboard

## Design Statistics

| Metric | Value |
|--------|-------|
| Die area | 1500 × 1500 µm (2.25 mm²) |
| Core area | 1438 × 1436 µm (2.06 mm²) |
| Core utilization | 36.1% |
| Std cell utilization | 19.9% |
| Total instances (with fill) | 573,166 |
| Functional instances | 193,566 |
| Standard cells | 193,434 |
| SRAM macros | 132 |
| Clock buffers | 5,337 |
| Clock inverters | 1,341 |
| Timing repair buffers | 26,535 |
| Sequential cells (flip-flops) | 20,622 |
| Combinational cells | 113,560 |

## Physical Design Quality

| Check | Result | Status |
|-------|--------|--------|
| Routing congestion (overflow) | 0 on all layers | ✅ Clean |
| Max routing usage | 40.8% (metal2) | ✅ Healthy |
| DRC violations (post-route) | 19 shorts (metal5/6) | ⚠️ Minor |
| Hold timing | 0 violations | ✅ Clean |
| CTS skew | 0.181 ns | ✅ Acceptable |
| Synthesis | ABC speed-optimized | ✅ Correct |

## Power

| Component | Value |
|-----------|-------|
| Internal power | 0.265 W |
| Switching power | 0.051 W |
| Leakage power | 0.029 W |
| **Total power** | **0.345 W** |

## What Was Met vs Not Met

### ✅ Constraints Met
- Clock definition (name, port, latency)
- Input/output delays (20% of period)
- Hold timing (zero violations)
- Routing layers (metal2–metal10)
- Routing congestion (zero overflow)
- SRAM macro instantiation (132 × fakeram45_256x16)
- Die/core area (assignment spec)
- Macro halo (10 µm) and channel (20 µm)
- Pin exclusion (io.tcl applied)
- Full flow completion (synthesis through detailed routing)

### ❌ Constraints Not Met
- **Setup timing**: WNS = -1.48 ns (target: ≥ 0)
- **Frequency**: achieved 270 MHz vs 450 MHz target
- **DRC**: 19 minor shorts (could be fixed with more routing iterations)

