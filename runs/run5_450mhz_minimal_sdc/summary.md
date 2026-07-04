# Run 5: Minimal SDC — Isolating Reg-to-Reg Timing

## Hypothesis (Ritik's Suggestion)

Before concluding that 450 MHz is impossible, prove it cleanly:
1. Remove all I/O delays (input_delay, output_delay) — eliminates port-to-reg paths from analysis
2. Remove clock latency — no artificial skew influencing the optimizer
3. Run only clock constraint — isolates pure register-to-register timing
4. Check post-CTS WNS — first point where clock tree is real

If WNS is still negative with only a clock definition, the bottleneck is **internal logic depth** — no constraint tuning or I/O changes can help.

## SDC Used

```tcl
create_clock -name core_clock -period 2.222 [get_ports clk_i]
```

Nothing else. No I/O delays. No latency. No virtual clock.

## Configuration
- Target: 450 MHz (2.222 ns)
- Die area: 0 0 1500 1500 (assignment spec)
- Core area: 10 12 1448 1448 (assignment spec)
- Macro halo: 10 µm, channel: 20 µm
- Instance: c5.2xlarge (8 vCPU, 16 GB RAM)
- Date: 2026-07-04

## Result (Post-CTS)

| Metric | Value |
|--------|-------|
| WNS | **-1.472 ns** |
| TNS | -4777.5 ns |
| Violating endpoints | 4890 |
| Worst path | `issue_stage_i.i_scoreboard/mem_q[2731]$_DFF_PN0_/D` |
| Calculated fmax | 271 MHz |

## Comparison with Full-Constraint Run (Run 2)

| | Run 2 (full SDC) | Run 5 (minimal SDC) | Difference |
|--|-------------------|---------------------|------------|
| I/O delays | 20% of period | None | — |
| Clock latency | 0.535 ns | None | — |
| Virtual clock | Yes | None | — |
| **WNS** | **-1.485 ns** | **-1.472 ns** | 0.013 ns |
| **fmax** | **270 MHz** | **271 MHz** | ~1 MHz |
| Worst path | scoreboard/mem_q | scoreboard/mem_q | Same |

## Conclusion

The WNS is nearly identical (within 0.013 ns) whether we use full I/O constraints or just a bare clock. This proves:

1. **I/O delays are NOT the bottleneck** — removing them doesn't help
2. **Clock latency is NOT confusing the optimizer** — removing it makes no difference
3. **The bottleneck is purely reg-to-reg** through the issue scoreboard
4. **~271 MHz is the hard architectural limit** of this RTL on Nangate45

No physical design constraint change can close timing at 450 MHz. The gap (1.47 ns) requires RTL modification.
