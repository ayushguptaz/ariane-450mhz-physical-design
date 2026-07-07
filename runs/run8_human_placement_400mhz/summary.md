# Run 8 — Human (Jung-style) Macro Placement + 400 MHz target: Results

Full flow completed (exit 0, ~2.3 h on c5.2xlarge). Two attempts:
1. **Attempt 1 (flat synthesis) — aborted by design**: `SYNTH_HIERARCHICAL=0`
   caused Yosys to delete 88 of 132 SRAMs (all nbdcache macros). Caught in
   ~20 min by the macro-count assertion in `macro_placement.tcl`
   (`found 44 — aborting`). Log: `flow_flat_synth_failed.log`.
   **Conclusion: flat synthesis is unusable on this netlist.**
2. **Attempt 2 (hierarchical) — completed**, results below.

## Final results (post-route)

| Metric | run8 | Best prior (run) | Verdict |
|---|---|---|---|
| Target | 2.5 ns (400 MHz) | — | — |
| **fmax** | **263.9 MHz** | 283.2 (run3), 272.8 (run7a) | below best |
| WNS | -1.289 ns @ 2.5 ns | — | (different target, use fmax) |
| TNS | **-3,689 ns** | -4,418 (run7a) | best 400/450-class run |
| **Clock skew (setup)** | **0.161 ns** | 0.18 (run5) | **best of all runs** |
| DRC | **0** | 0 (run7) | clean |
| Power | 0.313 W | — | lowest of 450/400-class |
| Utilization | 36% | — | unchanged (die fixed) |

## Macro placement scoreboard (like-for-like, fixed 1500×1500 die)

| Macro placement | Run | fmax |
|---|---|---|
| RTLMP (auto, dataflow-driven) | run7a | **272.8 MHz** |
| Human Jung-style (this run) | run8 | 263.9 MHz |
| Uniform C-shape ring | run7c | 255.5 MHz |

## Analysis

**What worked**
- The Jung floorplan materialized exactly as designed (see
  `reports/base/final_placement.webp`): dcache data bands top/bottom, dcache
  tags left corners, icache cluster right-center, logic pocket at the left pins.
- **Best clock skew of any run (0.161 ns)** — CTS defaults + centered `clk_i`
  + compact logic pocket = the balanced tree we were after.
- Best TNS and power in the 400/450 class; DRC stayed 0.

**What didn't**
- fmax (263.9) trails RTLMP (272.8). Human dataflow placement helped vs the
  naive C-ring (+8 MHz) but still loses to the tool's connectivity-driven
  optimization by ~9 MHz. Consistent with TILOS data where placement variants
  only span ~5%: **macro placement is a second-order lever on this design.**
- The critical path is unchanged (`issue_stage_i.i_scoreboard/mem_q[...]`),
  and at 36% utilization the wirelength overhead dominates.

## Standing conclusions after 8 runs

1. Open-flow fmax ceiling observed: **283 MHz** (run3, tighter core at 51% util).
2. Macro placement (RTLMP vs human vs ring) moves fmax ≤ 17 MHz; synthesis
   quality and utilization dominate.
3. Flat synthesis — the only Yosys lever resembling commercial restructuring —
   is broken for this testcase.
4. 400+ MHz closure requires commercial synthesis/phys-opt (TILOS: ~700 MHz
   with Genus+Innovus) or RTL retiming of the scoreboard commit-flush loop.
5. Best-practice combo for this repo: **run3 floorplan (CORE_UTILIZATION=50) +
   RTLMP + timing-driven GPL + 64-iter routing + CTS defaults + centered clk_i**.
