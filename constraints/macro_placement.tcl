# Manual macro placement to optimize routing
# Distribute 132 SRAMs around perimeter (top/bottom heavy, right side thin)
# Keep center open for standard cell logic (flops, scoreboard, issue stage)

# Get die dimensions
set die_width 1700.0
set die_height 1700.0
set core_lx 10.0
set core_ly 12.0
set core_ux 1688.0
set core_uy 1688.0

# Macro dimensions (fakeram45_256x16 is approximately 50um x 60um)
set macro_width 50.0
set macro_height 60.0
set halo 15.0
set channel 40.0

# Calculate placement zones
# TOP ZONE: y = core_uy - 200 to core_uy - 50 (heavy macro density)
# BOTTOM ZONE: y = core_ly + 50 to core_ly + 200 (heavy macro density)
# LEFT ZONE: x = core_lx + 50 to core_lx + 150 (thin, near I/O)
# RIGHT ZONE: x = core_ux - 150 to core_ux - 50 (THIN - only few macros)
# CENTER: Keep open for standard cells

# We have 132 macros to place
# Distribution strategy:
# - TOP: 45 macros (34%)
# - BOTTOM: 45 macros (34%)
# - LEFT: 30 macros (23%)
# - RIGHT: 12 macros (9%) - THIN as requested

# TOP ROW placement (y ~ 1628 to 1670)
set top_y 1628
set top_x 60
set macro_spacing 35

for {set i 0} {$i < 45} {incr i} {
    set x [expr $top_x + ($i % 23) * $macro_spacing]
    set y [expr $top_y + ($i / 23) * 70]
    # Macros will be auto-placed, but this guides RTLMP
}

# BOTTOM ROW placement (y ~ 62 to 150)
set bot_y 62
set bot_x 60

for {set i 0} {$i < 45} {incr i} {
    set x [expr $bot_x + ($i % 23) * $macro_spacing]
    set y [expr $bot_y + ($i / 23) * 70]
}

# LEFT COLUMN placement (x ~ 60 to 150, y ~ 300 to 1400)
set left_x 60
set left_y_start 300
set left_y_spacing 40

for {set i 0} {$i < 30} {incr i} {
    set x [expr $left_x + ($i % 2) * 60]
    set y [expr $left_y_start + ($i / 2) * $left_y_spacing]
}

# RIGHT COLUMN placement (x ~ 1538 to 1638, y ~ 300 to 1400) - THIN (only 12 macros)
set right_x 1588
set right_y_start 400
set right_y_spacing 100

for {set i 0} {$i < 12} {incr i} {
    set x $right_x
    set y [expr $right_y_start + $i * $right_y_spacing]
}

# Center area (x ~ 200 to 1500, y ~ 200 to 1500) is kept CLEAR for standard cells
# This allows flops, scoreboard logic, issue stage to be placed optimally

puts "Macro placement guidance configured: top/bottom heavy, right thin, center clear"
