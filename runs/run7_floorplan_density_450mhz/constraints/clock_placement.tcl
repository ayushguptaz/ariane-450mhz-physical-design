# Run 7 — center the clock entry point for a balanced clock tree
#
# Goal: the clock port should enter near the MIDDLE of the die so CTS builds a
# symmetric H-tree with equal insertion delay to all four quadrants (low skew).
#
# The assignment pin exclusions (constraints/io.tcl) block left:0-500 and
# left:1000-1500, which leaves left:500-1000 — the MIDDLE of the left edge —
# as the only open window. That is exactly where we want the clock: as close to
# die-center as the edge-pin PDK allows. We pin clk_i to the center of that band.
#
# Die is 1500 x 1500 -> vertical center = 750. Constrain clk_i to left:700-800.

set_io_pin_constraint -pin_names {clk_i} -region left:700-800

puts "Run7: clk_i constrained to left-edge center (y 700-800) for balanced CTS"
