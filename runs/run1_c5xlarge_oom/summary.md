# Run 1: c5.xlarge — OOM at Detailed Routing

## Instance
- Type: c5.xlarge (4 vCPU, 8 GB RAM)
- Region: ap-south-1
- Date: 2026-07-03

## Result
- Flow reached **stage 5_2 (detailed routing)** before OOM kill
- Signal 9 (killed by kernel OOM killer)
- Peak memory: 7.45 GB (exhausted 8 GB available)
- Runtime before kill: 30 min 39 sec in detailed routing alone
- CPU usage: 388% (using all 4 cores)

## Timing at post-placement repair (before routing)
- WNS: -1.249 ns
- TNS: -3529.8 ns
- Violating endpoints: 7612
- Worst path: `issue_stage_i.i_scoreboard/mem_q[158]$_DFF_PN0_/D`

## Stages Completed
1. Synthesis ✅
2. Floorplan ✅
3. Placement ✅
4. CTS ✅
5. Global Route ✅
6. Detailed Route ❌ (OOM killed)

## Fix
Upgrade to c5.2xlarge (16 GB RAM) for detailed routing.
