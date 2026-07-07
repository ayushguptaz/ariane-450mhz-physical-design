# Assignment pin exclusions: leaves left:500-1000 (die-center band) open.
exclude_io_pin_region -region left:0-500 -region left:1000-1500: -region right:* \
  -region top:* -region bottom:*

# Clock entry centered in the open band for a balanced clock tree.
set_io_pin_constraint -pin_names {clk_i} -region left:700-800
puts "run8 io.tcl: exclusions applied; clk_i pinned to left:700-800"
