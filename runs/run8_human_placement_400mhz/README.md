# Run 8 — Human Macro Placement + Flat Synthesis (400 MHz target)

Combines every lever validated so far, plus the two new ones from the research
(TILOS MacroPlacement, ORFS reference metrics, AuDoPEDA paper):

| Lever | Setting | Source of evidence |
|---|---|---|
| **Flat synthesis** | `SYNTH_HIERARCHICAL=0` | critical path crosses 4 modules; Genus-style cross-module restructuring is the main commercial advantage |
| **Human dataflow macro placement** | port of Dr. Jinwook Jung's `place_srams.tcl` (TILOS) | best human baseline: WNS -0.107 @ 1.3 ns with Innovus |
| Pin-side mirroring | R0/MY pairs, 20 µm pin channels, backs abutted | Jung's script |
| Balanced clock tree | TritonCTS **defaults** + clk_i pinned `left:700-800` | run7: custom clustering hurt (skew 0.27 vs 0.18) |
| Timing-driven placement | `GPL_TIMING_DRIVEN=1`, routability-driven, TNS 100% | run7: +3 MHz, 0 DRC |
| Buffering headroom | cell padding 4/2, slack margins 0.05 | run7 |
| Full routing | `-droute_end_iter 64`, congestion iters 10 | run7: DRC 19 → 0 |
| Target | **2.5 ns (400 MHz)**, full ORFS-style SDC | realistic-aggressive budget (run3 showed too-tight targets degrade results) |

## Expectations (honest)

- Published open-flow ceiling on this design: ~279–292 MHz (ORFS reference / AuDoPEDA).
- run8 goal: **beat 292 MHz** — flat synthesis is the biggest untested lever.
- 400 MHz closure itself is unlikely with Yosys+OpenROAD; it is the *target* to
  pressure the optimizer, not the success bar. Success = fmax > 292 MHz, DRC 0,
  skew ≤ 0.2 ns.

## Files

```
run8_human_placement_400mhz/
├── config.mk                    # flat synth + all proven knobs
├── ariane_run8.sdc              # 2.5 ns, latency 0.535, 20% I/O
└── constraints/
    ├── io.tcl                   # exclusions + centered clk_i
    └── macro_placement.tcl      # Jung-style human placement (132 macros, LOCKED)
```

## Risk note

Flat synthesis renames nothing critical for the SRAMs (hierarchy prefixes are
preserved in Yosys flatten), but `macro_placement.tcl` hard-fails if it doesn't
find 132/133 macros — check `logs/base/2_2_floorplan_macro.log` after ~20 min.
