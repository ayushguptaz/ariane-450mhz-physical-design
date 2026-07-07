# Assignment pin exclusions (from physical_hints.tcl).
# Blocks left:0-500, left:1000-1500, and all of right/top/bottom, which leaves
# left:500-1000 (the die-center band) open for all pins.
exclude_io_pin_region -region left:0-500 -region left:1000-1500: -region right:* \
  -region top:* -region bottom:*

# Clock entry centered: pin clk_i to the middle of the open band (die center
# y=750) so CTS grows a symmetric tree. NOTE: merged here (not a separate
# ADDITIONAL_IO_CONSTRAINTS file) because this ORFS version only sources
# IO_CONSTRAINTS.
set_io_pin_constraint -pin_names {clk_i} -region left:700-800
puts "io.tcl: exclusions applied; clk_i pinned to left:700-800 (die-center band)"
