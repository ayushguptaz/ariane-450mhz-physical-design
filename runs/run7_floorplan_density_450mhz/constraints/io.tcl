# Assignment pin exclusions (from physical_hints.tcl).
# Blocks left:0-500, left:1000-1500, and all of right/top/bottom, which leaves
# left:500-1000 (the die-center band) open for the clock port — see
# clock_placement.tcl.
exclude_io_pin_region -region left:0-500 -region left:1000-1500: -region right:* \
  -region top:* -region bottom:*
