# Run 7 — Balanced Clock Tree: Red-Line Macro Ring + Centered Clock + More Buffering (450 MHz)

## Origin: What the post-CTS image told us

Source image: `runs/run5_450mhz_minimal_sdc/reports/base/cts_default_core_clock_layout.webp`
(post-CTS clock layout — gray boxes = 132 SRAM macros, red = clock sinks/flops,
orange = clock tree routing).

### Issues visible in the image

| # | Observation in image | Metric backing it | Physical-design impact |
|---|----------------------|-------------------|------------------------|
| 1 | Large black (empty) regions across the die | Core utilization **36%**, std-cell util **19.9%** | Wires longer than necessary → extra RC delay |
| 2 | Logic (red) crammed top/center-left; lower-right is macros + empty | Non-uniform sink distribution | Uneven clock spans, longer data nets |
| 3 | 132 macros ringed around the periphery, lopsided | 416,463 µm² macro area on the edge | Logic pushed to center, long macro↔logic paths |
| 4 | Clock tree (orange) reaches all sinks cleanly, low skew | Setup skew **0.18 ns**, 0 CTS violations | **CTS is healthy — do NOT chase skew** |
| 5 | 4-iteration detailed route in this run | `-droute_end_iter 4`, 19 metal5/6 shorts | Under-optimized routing/post-route timing |

### Root-cause conclusion (from runs 2/5/6)

The reg-to-reg critical path through `issue_stage_i.i_scoreboard/mem_q[...]` is
**logic-depth (gate-delay) limited, ~270–283 MHz hard wall**. I/O constraints
(run5) and aggressive synthesis / +buffering (run6) each moved fmax by ≤3 MHz.

**Therefore run7 is scoped to the ONE physical-design lever the image shows is
still on the table: floorplan density + balanced macro placement + full routing.**
This is expected to recover single-digit MHz (run3 at 51% util hit 283 MHz vs
270 MHz at 36% util), NOT to close 450 MHz. Closing 450 MHz needs RTL retiming of
the scoreboard, which is out of scope for a PD run.

## Goals

1. Raise core utilization from ~36% toward ~50% to shorten average wire length.
2. **Put the 132 macros on a UNIFORM red-line ring** (33/side) so the clock-sink
   cloud is symmetric — kills the lopsided distribution from run5.
3. **Center the clock entry** (`clk_i` at the middle of the left edge, the only
   window the assignment pin exclusions leave open) so CTS builds a symmetric H-tree.
4. **More buffering in the placement stage** — extra cell padding + positive
   setup/hold slack margins so the resizer inserts more repair buffers.
5. **Balanced clock tree knobs** — tight, uniform TritonCTS sink clustering +
   level balancing for low, even insertion delay.
6. Enable timing-driven + routability-driven global placement.
7. Run full detailed routing (64 iters) to clear the 19 shorts and recover post-route timing.

## Balanced-clock-tree strategy (from the annotated image)

| Ask (annotation) | Implementation | File |
|------------------|----------------|------|
| Macros on the RED line, uniform | 132 macros, 33/side, hugging a central keep-clear box | `constraints/macro_placement.tcl` |
| Clock port in the middle | `clk_i` pinned to `left:700-800` (die-center on the open edge band) | `constraints/clock_placement.tcl` |
| More buffering at placement | `GPL_CELL_PADDING=4`, `CELL_PAD_*`, `SETUP/HOLD_SLACK_MARGIN=0.05` | `config.mk` |
| Balanced clock tree | `CTS_BALANCE_LEVELS`, `CTS_CLUSTER_*`, `CTS_SINK_CLUSTERING_*` | `config.mk` |

Rationale: a symmetric macro ring + centered clock + uniform CTS clustering are
the three levers that most directly reduce clock skew and even out insertion
delay. Extra placement buffering shortens high-fanout/long data nets feeding the
sinks. Together these give a balanced tree without touching the (already-healthy)
skew via CTS-only hacks.

## Non-goals

- Do NOT expect 450 MHz closure — that is architectural (scoreboard depth).
- No RTL changes in this run.
- The balanced-tree work targets skew *uniformity/insertion delay*, not raw
  fmax; skew was already low (0.18 ns), so the goal is to keep it low while the
  symmetric macro ring + centered clock make it structurally balanced.

## Success criteria

| Metric | Baseline (run5, 36% util) | run7 target |
|--------|---------------------------|-------------|
| Core utilization | 36% | 48–52% |
| Post-route WNS | -1.485 ns | ≥ -1.30 ns (improvement) |
| Achieved fmax | ~270 MHz | ≥ 278 MHz |
| Post-route DRC shorts | 19 | 0 |
| Clock skew (setup) | 0.18 ns | ≤ 0.20 ns (no regression) |

Run is a **success** if fmax improves toward the ~283 MHz architectural wall with
0 DRC violations. It **confirms the wall** (not a failure) if fmax stays ~270–283 MHz.

## Deliverables to capture from the run

- `reports/base/6_finish.rpt`, `logs/base/6_report.json` (final timing/power/area)
- `reports/base/5_route_drc.rpt` (must be 0 shorts)
- `reports/base/cts_default_core_clock_layout.webp` + `final_placement.webp`
  (compare density vs the run5 image side by side)
- `summary.md` filled in with the success-criteria table above.
