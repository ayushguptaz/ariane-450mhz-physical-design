# Run 3: 333 MHz Target (ORFS Reference Settings)

## Instance
- Type: c5.2xlarge (8 vCPU, 16 GB RAM)
- Region: ap-south-1
- Date: 2026-07-03

## Configuration Changes (vs 450 MHz run)
- Clock period: 3.0 ns (333 MHz) instead of 2.222 ns (450 MHz)
- Floorplan: CORE_UTILIZATION=50% (auto-sized) instead of fixed 1500x1500
- Macro halo: 8 µm (instead of 10)
- Detailed route iterations: 64 (full) instead of 4
- SKIP_GATE_CLONING=1
- GPL_RANDOM_SEED=3

## Timing Results

| Metric | Value |
|--------|-------|
| Target Clock Period | 3.0 ns (333 MHz) |
| Achieved fmax | 283.2 MHz (period = 3.53 ns) |
| WNS | -0.531 ns |
| TNS | -1121.2 ns |
| Setup Violations | 3209 endpoints |
| Hold Violations | 0 |
| Clock Skew | 0.198 ns |

## Design Statistics

| Metric | Value |
|--------|-------|
| Die Area | 1.45 mm² |
| Core Area | 1.42 mm² |
| Core Utilization | 51.2% |
| Std Cell Utilization | 31.0% |
| Total Instances | 180,156 |
| SRAM Macros | 132 |
| Timing Repair Buffers | 15,570 |
| Total Power | 0.258 W |

## Comparison: 333 MHz vs 450 MHz Target

| Metric | 333 MHz Target | 450 MHz Target |
|--------|---------------|----------------|
| Achieved fmax | 283 MHz | 270 MHz |
| WNS | -0.531 ns | -1.485 ns |
| TNS | -1121 ns | -4899 ns |
| Setup Violations | 3209 | 6509 |
| Core Utilization | 51.2% | 36.1% |
| Power | 0.258 W | 0.345 W |

## Conclusion

The 333 MHz target produces better results (283 MHz achieved vs 270 MHz) because:
1. Tools optimize more effectively with a realistic slack budget
2. Full 64 detailed route iterations improve post-route timing
3. Utilization-based floorplan produces a more compact layout with shorter wires

The hard limit (~283 MHz) is set by the Ariane scoreboard critical path — this is an architectural constraint of the RTL that cannot be solved by physical design optimization alone.

## All Stages Completed
1. Synthesis ✅
2. Floorplan ✅
3. Placement ✅
4. CTS ✅
5. Global Route ✅
6. Detailed Route ✅
