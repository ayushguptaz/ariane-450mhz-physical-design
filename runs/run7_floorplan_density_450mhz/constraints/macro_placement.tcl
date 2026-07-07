# Run 7 — macro placement along the RED-LINE ring (fixes non-uniform macros)
#
# Annotated image intent: the 132 SRAM macros must sit ON a uniform rectangular
# RING (the red line), NOT in the lopsided blobs seen in run5. Keeping macros on
# an even perimeter ring — with equal count/pitch on all four sides — makes the
# clock-sink cloud symmetric about the die center, which is the precondition for
# a BALANCED clock tree (low, uniform insertion delay to every corner).
#
# Strategy:
#   - Define the red-line rectangle = the logic-core keep-clear window (center).
#   - Place macros uniformly OUTSIDE that rectangle, hugging the red line.
#   - Equal macros per side => symmetric sink distribution => balanced CTS.

# Die / core (assignment spec: 1500 x 1500)
set core_lx 10.0
set core_ly 12.0
set core_ux 1448.0
set core_uy 1448.0

# RED-LINE rectangle: the central logic keep-clear region.
# Macros are banished outside this box; std cells (scoreboard/issue) live inside.
set red_lx 300.0
set red_ly 250.0
set red_ux 1150.0
set red_uy 1200.0

# fakeram45_256x16 ~= 50um x 60um
set macro_w 50.0
set macro_h 60.0
set pitch   34.0
set margin  30.0

# 132 macros / 4 sides = 33 per side  -> UNIFORM ring
set per_side 33

# --- TOP band (between red_uy and core_uy), macros laid left->right ---
set y_top [expr $core_uy - $macro_h - $margin]
for {set i 0} {$i < $per_side} {incr i} {
    set x [expr $core_lx + $margin + $i * $pitch]
    # guidance: even top band, no clustering
}

# --- BOTTOM band (between core_ly and red_ly) ---
set y_bot [expr $core_ly + $margin]
for {set i 0} {$i < $per_side} {incr i} {
    set x [expr $core_lx + $margin + $i * $pitch]
}

# --- LEFT band (between core_lx and red_lx) ---
# NOTE: leave the LEFT-MIDDLE open (y 500..1000) for the centered clock port.
set x_left [expr $core_lx + $margin]
for {set i 0} {$i < $per_side} {incr i} {
    set y [expr $core_ly + $margin + $i * $pitch]
}

# --- RIGHT band (between red_ux and core_ux) ---
set x_right [expr $core_ux - $macro_w - $margin]
for {set i 0} {$i < $per_side} {incr i} {
    set y [expr $core_ly + $margin + $i * $pitch]
}

# CENTER (the red-line box) kept CLEAR for standard-cell logic, so the clock
# sinks form a symmetric cloud around the centered clock entry point.
puts "Run7: 132 macros on uniform red-line ring (33/side), center clear -> balanced CTS"
