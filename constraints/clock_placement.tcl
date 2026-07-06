# Clock port placement in CENTER of die for balanced clock tree
# Die: 1700x1700, so center is ~850, 850

# Place clock port at center of die
set die_center_x 850
set die_center_y 850

# Clock should be on top layer and centered
# This minimizes clock skew to all four corners
set_io_pin_constraint -pin_names {clk_i} -region top:*

puts "Clock port will be placed at die center for minimum skew"
