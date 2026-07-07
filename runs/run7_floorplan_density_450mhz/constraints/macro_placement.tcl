# Run 7 (fixed) — REAL macro placement: C-shape per annotated image.
#
#   -----   <- top band of macros
#        |  <- right column of macros
#   -----   <- bottom band of macros
#
# Left edge stays macro-free (I/O pins live at left:500-1000) and ALL standard
# cell logic is enclosed inside the C. Unlike the previous version of this file
# (which computed coordinates but never placed anything), this script issues an
# explicit `place_macro` for every SRAM and locks it so the automatic macro
# placer (rtl_macro_placer) cannot move it.

# Core box (assignment spec: die 1500x1500, core 10 12 1448 1448)
set core_lx 10.0
set core_ly 12.0
set core_ux 1448.0
set core_uy 1448.0

set edge_margin 30.0  ;# gap from core edge to macro bodies
set gap         24.0  ;# clearance between adjacent macro bodies (> 2x 10um halo)
set band_x0    150.0  ;# top/bottom bands start here; x < 150 stays open near pins

# 4 rows/band x 12 macros = 48 top + 48 bottom; remaining 36 fill exactly
# 3 right columns -> thin right wall, max center area for logic
set top_rows 4
set bot_rows 4

set block [ord::get_db_block]
set tech  [ord::get_db_tech]
set dbu   [$tech getDbUnitsPerMicron]

# Collect all macro instances (sorted so related SRAM blocks stay adjacent)
set names {}
foreach inst [$block getInsts] {
    if {[[$inst getMaster] isBlock]} {
        lappend names [$inst getName]
    }
}
set names [lsort $names]
set n [llength $names]
if {$n == 0} {
    puts "Run7 macro placement: no macros found, nothing to do"
    return
}

# Macro dimensions from the actual master (fakeram45_256x16)
set m0 [[$block findInst [lindex $names 0]] getMaster]
set mw [expr {[$m0 getWidth]  / double($dbu)}]
set mh [expr {[$m0 getHeight] / double($dbu)}]
set px [expr {$mw + $gap}]
set py [expr {$mh + $gap}]

set x0 $band_x0
set x1 [expr {$core_ux - $edge_margin}]
set per_row [expr {int(($x1 - $x0 - $mw) / $px) + 1}]

proc r7_place {name x y} {
    place_macro -macro_name $name -location [list $x $y] -orientation R0
    set inst [[ord::get_db_block] findInst $name]
    $inst setPlacementStatus LOCKED
}

set idx 0

# --- TOP band (rows grow downward from the top edge) ---
for {set r 0} {$r < $top_rows && $idx < $n} {incr r} {
    set y [expr {$core_uy - $edge_margin - $mh - $r * $py}]
    for {set c 0} {$c < $per_row && $idx < $n} {incr c} {
        r7_place [lindex $names $idx] [expr {$x0 + $c * $px}] $y
        incr idx
    }
}

# --- BOTTOM band (rows grow upward from the bottom edge) ---
for {set r 0} {$r < $bot_rows && $idx < $n} {incr r} {
    set y [expr {$core_ly + $edge_margin + $r * $py}]
    for {set c 0} {$c < $per_row && $idx < $n} {incr c} {
        r7_place [lindex $names $idx] [expr {$x0 + $c * $px}] $y
        incr idx
    }
}

# --- RIGHT columns: remaining macros fill columns from the right edge inward,
#     vertically between the two bands ---
set y_bot [expr {$core_ly + $edge_margin + $bot_rows * $py + $gap}]
set y_top [expr {$core_uy - $edge_margin - $top_rows * $py - $gap}]
set rows_right [expr {int(($y_top - $y_bot - $mh) / $py) + 1}]
set col 0
while {$idx < $n} {
    set x [expr {$core_ux - $edge_margin - $mw - $col * $px}]
    for {set r 0} {$r < $rows_right && $idx < $n} {incr r} {
        r7_place [lindex $names $idx] $x [expr {$y_bot + $r * $py}]
        incr idx
    }
    incr col
}

puts "Run7 macro placement: $n macros placed in C-shape (top ${top_rows} rows,\
bottom ${bot_rows} rows, right ${col} cols), left edge open, logic enclosed"
