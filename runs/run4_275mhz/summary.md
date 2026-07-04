# Run 4: 275 MHz Target — Assignment Constraints

## Instance
- Type: c5.2xlarge (8 vCPU, 16 GB RAM)
- Region: ap-south-1
- Date: 2026-07-04

## Configuration
- Target: 275 MHz (3.636 ns clock period)
- All assignment constraints used (die 1500x1500, core 10 12 1448 1448, halo 10µm, channel 20µm)
- Full detailed routing (droute_end_iter 64)
- Clock latency: 0.535 ns
- I/O delay: 20% of period

## Stages Completed
1. Synthesis ✅
2. Floorplan ✅
3. Placement ✅
4. CTS ✅
5. Global Route ✅
6. Detailed Route ✅ (0 DRC violations after routing)
7. Final Report ✅

## Timing (Partial — container removed before report extraction)
- Placement stage worst slack: -1.26 ns (pre-CTS, pre-route — typically improves after)
- Detailed routing: 0 DRC violations at completion
- Full 6_report.json not captured (container auto-removed)

## Runtime
- Total: ~8191 seconds (~2.3 hours)
- Peak memory: 8094 MB (during detailed routing)
- Detailed route: 2268 seconds (64 iterations, 0 violations)

## Notes
- The flow completed successfully with zero routing violations
- Final timing metrics not available due to container cleanup before extraction
- Based on placement slack (-1.26 ns on 3.636 ns period), timing closure at 275 MHz is uncertain
- A re-run with proper output mounting would confirm final WNS
