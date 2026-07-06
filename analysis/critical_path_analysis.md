# Critical Path Analysis - Run 8 (Best Result: 284 MHz)

## Path Summary
**Startpoint:** `issue_stage_i.i_scoreboard/commit_pointer_q[1]` (flip-flop)  
**Endpoint:** `issue_stage_i.i_scoreboard/mem_q[1242]` (flip-flop)  
**Total Delay:** 4.12 ns  
**Required Time:** 2.82 ns (after clock latency)  
**Slack:** **-1.30 ns (VIOLATED)**  
**Clock Period:** 2.967 ns (337 MHz equivalent based on required time)

---

## Delay Breakdown

| Component | Delay | Percentage | Description |
|-----------|-------|------------|-------------|
| **Clock Network (Launch)** | 0.65 ns | 15.8% | Clock tree to launch flip-flop |
| **Clock-to-Q** | 0.13 ns | 3.2% | Flip-flop output delay |
| **Combinational Logic** | 3.34 ns | 81.0% | Gates + wires in data path |
| **Total Data Arrival** | 4.12 ns | 100% | — |

---

## Gate Types on Critical Path

### Summary by Gate Type:

| Gate Type | Count | Total Delay (ns) | Avg Delay (ps) | Purpose |
|-----------|-------|------------------|----------------|---------|
| **MUX2_X1** | 4 | 0.27 ns | 68 ps | Multiplexers (select logic) |
| **AOI21_X4** | 4 | 0.11 ns | 28 ps | And-Or-Invert (complex logic) |
| **NAND2_X4** | 2 | 0.06 ns | 30 ps | 2-input NAND |
| **NOR2_X4** | 3 | 0.08 ns | 27 ps | 2-input NOR |
| **AOI22_X4** | 1 | 0.03 ns | 30 ps | 4-input And-Or-Invert |
| **NAND3_X4** | 1 | 0.02 ns | 20 ps | 3-input NAND |
| **OAI211_X4** | 1 | 0.03 ns | 30 ps | Or-And-Invert |
| **NOR3_X4** | 1 | 0.04 ns | 40 ps | 3-input NOR |
| **NAND4_X4** | 1 | 0.03 ns | 30 ps | 4-input NAND |
| **AND4_X4** | 1 | 0.04 ns | 40 ps | 4-input AND |
| **INV_X4** | 1 | 0.01 ns | 10 ps | Inverter |
| **OR3_X4** | 1 | 0.07 ns | 70 ps | 3-input OR (slowest single gate!) |
| **HA_X1** | 1 | 0.06 ns | 60 ps | Half adder |
| **BUF_X4/X8** | 3 | 0.09 ns | 30 ps | Buffers (timing repair) |
| **Total Logic Gates** | **27** | **~0.94 ns** | **35 ps avg** | Pure gate delay |

### Wire Delay:
- **Interconnect + Capacitance:** ~2.40 ns (58% of combinational path delay)
- This is the CRITICAL bottleneck!

---

## Detailed Gate Sequence

### Section 1: Issue Scoreboard Arithmetic (0.78 → 1.10 ns)
```
commit_pointer_q[1] (FF)
  → HA_X1 (half adder - increment logic)          +60 ps
  → NAND2_X4                                       +30 ps  
  → BUF_X8                                         +30 ps
  → NAND3_X4                                       +20 ps
  → AOI21_X4 → AOI21_X4 → OAI21_X2                +70 ps
  → MUX2_X1 → MUX2_X1 → MUX2_X1 → MUX2_X1         +270 ps (4 muxes!)
```
**Time:** 0.32 ns, **Gates:** 12

**Problem:** 4 cascaded multiplexers = deep select logic

---

### Section 2: Control Logic (1.29 → 1.45 ns)
```
BUF_X4
  → OAI211_X4 (Or-And-Invert)                     +30 ps
  → AOI21_X4                                       +20 ps
  → AOI22_X4                                       +30 ps
  → NOR2_X4 → INV_X4 → AOI21_X4                   +30 ps
  → NAND2_X4                                       +30 ps
  → NOR2_X4                                        +10 ps
```
**Time:** 0.16 ns, **Gates:** 8

---

### Section 3: CSR Register File Logic (1.53 → 1.73 ns)
```
OR3_X4 (3-input OR - SLOW!)                       +70 ps
  → NOR3_X4                                        +40 ps
  → AOI21_X4 → NOR2_X4                            +60 ps
  → NAND4_X4                                       +30 ps
  → AND4_X4                                        +40 ps
  → NOR2_X4 → OR2_X4                              +50 ps
```
**Time:** 0.20 ns, **Gates:** 7

**Problem:** OR3_X4 gate takes 70ps - single slowest gate on path!

---

### Section 4: [Path continues through execute stage...]
*(Remaining gates follow similar pattern)*

---

## Key Findings

### 1. **Wire Delay Dominates (58%)**
- **Logic delay:** ~0.94 ns (gate propagation)
- **Wire + cap delay:** ~2.40 ns
- **Ratio:** Wire is 2.5x worse than gates!

**Why:**
- Scoreboard SRAMs likely placed far from scoreboard logic
- Long wires between `issue_stage → csr_regfile → execute_stage → back to scoreboard`

---

### 2. **Multiplexer Chain (4× MUX2_X1)**
Each MUX2_X1 adds ~68ps. 4 in a row = 270ps.

**Purpose:** Likely commit pointer selection logic (which scoreboard entry to commit)

**Optimization:**
- Replace with tree structure: 4 muxes serial → 2 levels parallel (135ps instead of 270ps)
- Use larger drive strength: MUX2_X2 or MUX2_X4
- **But:** This requires RTL change, outside our scope

---

### 3. **Complex Gates Are Slow**
- OR3_X4: 70 ps (slowest)
- NAND4_X4, AND4_X4, NOR3_X4: 30-40 ps each

These are necessary for the logic function but slower than 2-input gates.

---

### 4. **Fanout Issues**
Some gates drive high capacitance:
- `place48086/Z (BUF_X4)`: drives 20.08 fF
- `_05831_/ZN (NAND2_X4)`: drives 31.32 fF

This increases delay. Our `MAX_FANOUT=12` constraint didn't help because these specific nets weren't over the limit.

---

## What Can Be Fixed with Physical Design?

### ✅ Reducible (Physical Design):
1. **Wire delay (2.40 ns):**
   - Better macro placement → shorter wires
   - Scoreboard SRAMs closer to `issue_stage_i` logic
   - Estimated gain: **0.5-0.8 ns**

2. **High fanout buffers:**
   - More aggressive buffering on high-cap nets
   - Estimated gain: **0.1-0.2 ns**

### ❌ Not Reducible (Requires RTL):
1. **Logic depth (27 gates):**
   - Can't change the number of gates without RTL changes
   - 4× cascaded muxes = architectural decision
   - Estimated RTL fix: **Pipeline the scoreboard** (add 1 cycle latency) → removes 50% of gates from critical path

2. **Gate types:**
   - OR3, NAND4, etc. are the minimum gates needed for the logic function
   - Can't replace with faster gates without changing functionality

---

## Projected Improvement with Optimized Runs (12 & 13)

Our new runs have:
- Manual macro placement (top/bottom, right thin)
- Aggressive synthesis (ABC_AREA=0, fanout=12)
- Optimal die size (1700×1700)

**Expected wire delay reduction:**
- Current: 2.40 ns
- Optimized: 1.80-2.00 ns (25-30% reduction from better placement)
- **Improvement: 0.4-0.6 ns**

**Projected results:**
- Current WNS: -1.30 ns
- Optimized WNS: -0.7 to -0.9 ns
- **Target fmax: 350-380 MHz**

**To hit 450 MHz:**
- Need: WNS ≥ 0 → require 1.30 ns improvement
- Wire reduction gives: 0.6 ns
- **Shortfall: 0.7 ns = requires RTL change**

---

## Recommendations

### For Interviewer's 400 MHz Achievement:
He must have:
1. ✅ Manual macro placement based on connectivity (we're doing this now)
2. ✅ Pin optimization for critical paths
3. ✅ Possibly useful skew CTS (borrow ~0.1-0.2 ns from non-critical paths)
4. ✅ Multi-corner optimization (design at slow corner, gain 10-15% margin)

### For 450 MHz (If Required):
**Option A:** RTL modification
- Pipeline scoreboard commit logic (add 1 cycle)
- Reduces critical path gates from 27 → ~12
- **Impact:** +0.5-0.7 ns, but changes microarchitecture

**Option B:** Technology node change
- Nangate45 (45nm) → smaller node (28nm, 14nm)
- Gate delays scale by ~2x per node
- **Outside assignment scope**

### For Learning:
1. **Visualize the layout:**
   ```bash
   klayout -l nangate45.lef 6_final.def
   ```
   Trace where `issue_stage_i.i_scoreboard` cells are vs. the SRAM macros

2. **Calculate wire length:**
   ```bash
   grep "issue_stage_i.i_scoreboard" detailed_route.rpt
   ```

3. **Identify which SRAMs connect to scoreboard:**
   Parse netlist to find which of the 132 SRAMs are accessed by scoreboard logic

---

## Summary

| Bottleneck | Current | Optimizable? | Max Gain |
|------------|---------|--------------|----------|
| Wire delay | 2.40 ns | ✅ Yes (placement) | 0.6 ns |
| MUX cascade | 0.27 ns | ❌ RTL only | 0.15 ns |
| Other gates | 0.67 ns | ❌ Logic function | 0 ns |
| Clock tree | 0.65 ns | ⚠️ Useful skew | 0.1 ns |
| **Total** | **3.99 ns** | **Physical design** | **~0.7 ns** |

**Conclusion:** Physical design optimization can reach **~350-380 MHz**. 400+ MHz requires additional techniques (useful skew, multi-corner) or minor RTL tweaks.
