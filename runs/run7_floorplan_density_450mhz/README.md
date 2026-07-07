# Run 7 — Floorplan Density & Balanced Macro Placement (450 MHz)

Physical-design run derived from the issues seen in the run5 post-CTS layout
image. See `REQUIREMENTS.md` for the full image-issue analysis, goals, and
success criteria.

## What this run changes vs the 36%-utilization baseline (run2/run5)

| Lever | Baseline | Run 7 | Issue it addresses |
|-------|----------|-------|--------------------|
| `PLACE_DENSITY` | default (~0.36 effective) | **0.55** | #1 empty die / long wires |
| Macro placement | RTLMP (lopsided ring) | **uniform red-line ring, 33/side** | #2/#3 non-uniform macros |
| Clock port | edge (uncontrolled) | **`left:700-800` (die-center band)** | balanced clock tree |
| Placement buffering | default | **`GPL_CELL_PADDING=4`, slack margins 0.05** | more repair buffers |
| CTS clustering | default | **`CTS_CLUSTER_*` + `CTS_BALANCE_LEVELS=1`** | balanced clock tree |
| `GPL_TIMING_DRIVEN` | off | **1** | shorten critical nets |
| `GPL_ROUTABILITY_DRIVEN` | off | **1** | avoid congestion at higher density |
| `DETAILED_ROUTE_ARGS` | `-droute_end_iter 4` | **`64`** | #5 clear 19 shorts, recover timing |

Die/core area stays at the assignment spec (1500×1500 / 10 12 1448 1448).

## Files

```
run7_floorplan_density_450mhz/
├── REQUIREMENTS.md              # image-issue analysis + goals + success criteria
├── README.md                   # this file
├── summary.md                  # results template (fill in after the run)
├── config.mk                   # ORFS flow config (self-contained paths)
├── ariane_run7.sdc             # 450 MHz full constraints
└── constraints/
    ├── io.tcl                  # assignment pin exclusions (leaves left-center open)
    ├── macro_placement.tcl     # uniform red-line macro ring (33/side)
    └── clock_placement.tcl     # clk_i centered on the left edge
```

The folder is self-contained: every path in `config.mk` points inside
`/work/runs/run7_floorplan_density_450mhz/` (or the RTL under `/work/rtl/`).

## How to run (OpenROAD-flow-scripts, inside the Docker image)

```bash
docker run -it \
  -v $(pwd):/work \
  --memory=15g \
  openroad/flow-ubuntu22.04-builder:latest \
  bash

# inside the container:
export PATH=/OpenROAD-flow-scripts/tools/install/OpenROAD/bin:$PATH
DST=/OpenROAD-flow-scripts/flow/designs/nangate45/ariane_run7
mkdir -p $DST
cp /work/runs/run7_floorplan_density_450mhz/config.mk $DST/config.mk
cd /OpenROAD-flow-scripts/flow
make DESIGN_CONFIG=$DST/config.mk
```

Then copy `reports/`, `logs/`, and the routed DEF back under
`/work/runs/run7_floorplan_density_450mhz/` before the container is removed
(run4 lost its final metrics this way — mount and copy out).

## Verification checklist (fill into summary.md after the run)

- [ ] Core utilization landed in 48–52% (`6_report.json` → `finish__design__instance__utilization`)
- [ ] Post-route DRC = 0 shorts (`reports/base/5_route_drc.rpt`)
- [ ] WNS improved vs -1.485 ns; fmax ≥ 278 MHz
- [ ] Clock skew ≤ 0.18 ns and insertion delay even across quadrants (balanced tree)
- [ ] Macros form a uniform ring (no lopsided blobs) in `final_placement.webp`
- [ ] `clk_i` landed in the left-edge center band (y 700-800)
- [ ] Save `cts_default_core_clock_layout.webp` and diff density/symmetry vs run5 image

## Expected outcome

A modest fmax gain toward the ~283 MHz architectural wall with clean DRC.
This run does **not** attempt 450 MHz closure — that requires RTL retiming of the
issue-stage scoreboard, which is out of scope here.
