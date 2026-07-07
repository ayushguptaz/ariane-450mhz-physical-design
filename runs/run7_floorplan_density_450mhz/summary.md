# Run 7 — Balanced Clock Tree (Red-Line Macro Ring + Centered Clock + More Buffering)

Full RTL-to-GDSII flow completed on EC2 (`ariane-run7`, exit 0, ~2 h wall clock).
See `REQUIREMENTS.md` for the image-issue analysis and `README.md` for how to run.

## Hypothesis

Fixing the non-uniform macro distribution seen in the run5 post-CTS image would
give a structurally balanced clock tree and shorter wires:
- 132 macros on a UNIFORM red-line ring → symmetric clock-sink cloud
- `clk_i` centered on the left edge → symmetric H-tree
- more placement-stage buffering → shorter high-fanout/data nets
- tight, uniform TritonCTS clustering → even insertion delay
- `PLACE_DENSITY=0.55` → raise utilization toward 50%

## Configuration
- Target: 450 MHz (2.222 ns), full SDC (`ariane_run7.sdc`)
- Die/core: assignment spec (1500×1500 / 10 12 1448 1448)
- Macro ring: `constraints/macro_placement.tcl` (33 macros/side)
- Clock port: `constraints/clock_placement.tcl` (`left:700-800`)
- Placement buffering: `GPL_CELL_PADDING=4`, `SETUP/HOLD_SLACK_MARGIN=0.05`
- CTS: `CTS_BALANCE_LEVELS=1`, `CTS_CLUSTER_*=30/100`, `CTS_SINK_CLUSTERING_*`
- Detailed route: `-droute_end_iter 64`
- Instance: c5.2xlarge (8 vCPU, 16 GB RAM), 2026-07-06

## Final results (post-route)

| Metric | Baseline (run2/run5) | Run 7 | Target | Pass? |
|--------|----------------------|-------|--------|-------|
| Post-route WNS | -1.485 ns | **-1.443 ns** | ≥ -1.30 ns | ~ partial (improved) |
| Post-route TNS | -4899 ns | **-4418 ns** | improve | ✅ better |
| Achieved fmax (core_clock) | 270 MHz | **272.8 MHz** | ≥ 278 MHz | ❌ below target |
| **Post-route DRC** | 19 shorts | **0** | 0 | ✅ **PASS** |
| Clock skew (setup) | 0.18 ns | **0.269 ns** | ≤ 0.18 ns | ❌ regressed |
| Core utilization | 36% | **36% (0.359)** | 48–52% | ❌ no change |
| Total power | 0.345 W | **0.328 W** | — | lower |
| Clock buffers | 5,356 | **964** | — | far fewer |
| Timing repair buffers | 25,347 | **27,187** | — | +7% (as intended) |

DRC convergence (64-iter route): 33662 → 4494 → 2378 → 23 → 9 → 9 → **0** (iter 6).

## Analysis — what worked and what didn't

**Worked**
- **DRC = 0** (vs 19 shorts baseline). Full 64-iteration route + routability-driven
  placement cleaned all shorts. This is the clearest win.
- **fmax +2.8 MHz** (272.8 vs 270) and **TNS improved ~10%** from timing-driven
  placement + extra repair buffering.
- **Macro distribution is visibly more uniform** — macros now sit in all four
  corners + side columns (see `reports/base/final_placement.webp`) instead of the
  lopsided run5 blobs. The centered `clk_i` landed on the left-edge middle.
- **Lower power** (0.328 vs 0.345 W), mostly from the much smaller clock tree.

**Didn't work**
- **Skew regressed (0.269 vs 0.18 ns).** The CTS clustering knobs
  (`CTS_CLUSTER_SIZE=30`, `CTS_SINK_CLUSTERING_*`) collapsed the clock tree from
  5,356 buffers to **964** — a sparser tree with longer, more uneven branches.
  The "balanced tree" intent backfired: fewer buffers → higher skew. The design
  isn't skew-limited, so WNS still improved, but the balance goal itself failed.
- **Utilization unchanged (36%).** `PLACE_DENSITY` only controls placement
  *spread*, not floorplan size. With `DIE_AREA` and cell count fixed,
  utilization = cell_area / core_area is fixed. Raising it needs a **smaller die**
  (`CORE_UTILIZATION=50`, as run3 did), not a density knob.

## Conclusion

Run 7 confirms the ~270–283 MHz architectural wall: even with a uniform macro
ring, centered clock, more buffering, and full routing, fmax only moved to
272.8 MHz. The real, bankable win is **0 DRC**. Two requirement levers were
mis-chosen — `PLACE_DENSITY` can't raise utilization, and aggressive CTS
clustering hurt (not helped) skew.

### Recommended next config (run8)
1. **Shrink the die** via `CORE_UTILIZATION=50` (drop explicit `DIE_AREA`) to
   actually reach ~50% util and shorten wires — this is what got run3 to 283 MHz.
2. **Revert the CTS clustering** to defaults (or `CTS_CLUSTER_SIZE` back up) so the
   tree keeps ~5k buffers and low skew.
3. Keep the **0-DRC** recipe (64-iter route + routability-driven placement) and
   the balanced macro ring.
4. For anything past ~283 MHz: RTL retiming of the issue-stage scoreboard.
