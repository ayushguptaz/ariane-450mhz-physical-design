# Run 6: Aggressive Synthesis Parameters — 450 MHz

## Hypothesis
With only 36% core utilization, trade unused area for timing by making synthesis more aggressive:
- Reduce max fanout to force buffer insertion
- Disable area optimization (ABC_AREA=0)
- Enable gate cloning

## Configuration
- Target: 450 MHz (2.222 ns)
- SDC: Full constraints (I/O delays + clock latency)
- **ABC_AREA = 0** (timing-only, ignore area cost)
- **MAX_FANOUT_CONSTRAINT = 12** (force buffering on high-fanout nets)
- **SKIP_GATE_CLONING = 0** (enable gate duplication)
- **PLACE_DENSITY_LB_ADDON = 0.05** (denser placement for more buffers)
- Die/core area: assignment spec (1500×1500, 10 12 1448 1448)
- Instance: c5.2xlarge (8 vCPU, 16 GB RAM)
- Date: 2026-07-05

## Results

### Final Timing (Post-Route)
| Metric | Value |
|--------|-------|
| WNS | **-1.515 ns** |
| TNS | -4688.1 ns |
| fmax | **268 MHz** |
| Setup violations | 5905 |
| Hold violations | 0 |

### Post-CTS Timing
| Metric | Value |
|--------|-------|
| WNS (setup) | -1.473 ns |
| WNS (hold) | 0.000 ns |

### Design Statistics
| Metric | Value |
|--------|-------|
| Timing repair buffers | 27,096 |
| Clock buffers | 5,533 |
| Total std cells | 194,110 |
| Logic gates | 113,560 |
| Utilization | 36% |

## Comparison with Baseline

| Metric | Run 5 (baseline) | Run 6 (aggressive) | Change |
|--------|------------------|-------------------|--------|
| Timing repair buffers | 25,347 | 27,096 | **+1,749 (+6.9%)** |
| Clock buffers | 5,356 | 5,533 | **+177 (+3.3%)** |
| Total std cells | 192,177 | 194,110 | **+1,933 (+1.0%)** |
| **WNS** | -1.510 ns | -1.515 ns | **-0.005 ns (worse)** |
| **fmax** | 268 MHz | 268 MHz | **0 MHz** |

## Analysis

**What worked:**
- Synthesis successfully added 6.9% more timing repair buffers
- Clock tree buffering increased by 3.3%
- Total cell count increased by 1.0%

**Why it didn't help timing:**
1. **Bottleneck is logic depth, not wire delay** — the critical path has ~70 gates in series through the scoreboard
2. **Buffers were added to non-critical paths** — the worst path remained the same
3. **Gate delay dominates** — buffering helps wire RC delay, but the scoreboard path is limited by gate propagation delay

## Conclusion

Aggressive synthesis parameters (reduced fanout, area-agnostic optimization, gate cloning) added more buffers as intended, but produced **zero timing improvement**. The ~270 MHz limit is architectural, not physical design.

The 1.5 ns gap to 450 MHz cannot be closed with synthesis tuning, buffering, or area relaxation. It requires RTL changes to reduce the combinational logic depth in the issue scoreboard.
