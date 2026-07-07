# Run 8 — Human macro placement, ported from Dr. Jinwook Jung's place_srams.tcl
# (TILOS MacroPlacement, Ariane133-NG45) and adapted to our die/macros.
#
# Jung's principles kept:
#   1. Dataflow grouping: icache cluster together, dcache tag/data grouped by way
#   2. Pin-side mirroring: pairs [MY | 20um pin channel | R0] so pin faces share
#      a channel and pin-less backs abut -> fewer, shorter escape routes
#   3. Tight arrays at the periphery, logic area contiguous and open toward pins
#
# Adapted geometry (die 1500x1500, core 10 12 1448 1448, macro ~77.7 x 40.6):
#   - dcache DATA  (64): top edge 2 rows x 16 (ways 0-3), bottom edge 2 rows x 16 (ways 4-7)
#   - dcache TAG   (24): top-left corner 4x3 (ways 0-3), bottom-left corner 4x3 (ways 4-7)
#   - icache all   (44): right-center block, 4 cols x 11 rows (data w0-1, tags, data w2-3)
#   - LEFT-MIDDLE (y ~365..1120) kept fully open: pins live at left:500-1000,
#     so the core logic sits between the pins and the caches.
#
# Every macro is placed with place_macro and LOCKED so rtl_macro_placer cannot
# move it. Fails hard if any expected macro is missing.

set core_lx 10.0
set core_ly 12.0
set core_ux 1448.0
set core_uy 1448.0

set pin_ch 20.0   ;# channel between pin faces of a mirrored pair
set vgap    5.0   ;# vertical gap between stacked rows
set edge   30.0   ;# margin from core edge

set block [ord::get_db_block]
set dbu   [[ord::get_db_tech] getDbUnitsPerMicron]

# ---- collect and classify -------------------------------------------------
set ic_tag {}; set ic_data {}; set dc_tag {}; set dc_data {}
foreach inst [$block getInsts] {
    if {![[$inst getMaster] isBlock]} { continue }
    set n [$inst getName]
    if {[string match *i_icache* $n]} {
        if {[string match *tag_sram* $n]} { lappend ic_tag $n } else { lappend ic_data $n }
    } elseif {[string match *i_nbdcache* $n]} {
        if {[string match *tag_sram* $n]} { lappend dc_tag $n } else { lappend dc_data $n }
    } else {
        # valid_dirty or anything else -> treat as icache-cluster member
        lappend ic_tag $n
    }
}
set ic_tag [lsort $ic_tag]; set ic_data [lsort $ic_data]
set dc_tag [lsort $dc_tag]; set dc_data [lsort $dc_data]

set total [expr {[llength $ic_tag]+[llength $ic_data]+[llength $dc_tag]+[llength $dc_data]}]
puts "Run8 macro classify: icache_tag=[llength $ic_tag] icache_data=[llength $ic_data]\
 dcache_tag=[llength $dc_tag] dcache_data=[llength $dc_data] total=$total"
if {$total != 132 && $total != 133} {
    error "Run8 macro placement: expected 132/133 macros, found $total — naming changed, aborting"
}

# macro dimensions from the actual master
set m0 [[$block findInst [lindex $dc_data 0]] getMaster]
set mw [expr {[$m0 getWidth]  / double($dbu)}]
set mh [expr {[$m0 getHeight] / double($dbu)}]
set rowpitch [expr {$mh + $vgap}]

# ---- placement helpers ----------------------------------------------------
proc r8_place {name x y orient} {
    place_macro -macro_name $name -location [list $x $y] -orientation $orient
    set inst [[ord::get_db_block] findInst $name]
    $inst setPlacementStatus LOCKED
}

# Place a horizontal row left->right with Jung's pair mirroring:
# [MY][pin_ch][R0][MY][pin_ch][R0]... backs abut, pin faces share the channel.
proc r8_row {names x0 y} {
    global mw pin_ch
    set x $x0
    set i 0
    foreach n $names {
        if {$i % 2 == 0} {
            r8_place $n $x $y MY
            set x [expr {$x + $mw + $pin_ch}]
        } else {
            r8_place $n $x $y R0
            set x [expr {$x + $mw}]
        }
        incr i
    }
}

# take k names off the front of a list variable
proc r8_take {listVar k} {
    upvar $listVar L
    set out [lrange $L 0 [expr {$k-1}]]
    set L [lrange $L $k end]
    return $out
}

# ---- 1. dcache DATA: top band (ways 0-3) and bottom band (ways 4-7) --------
# row of 16 = 8 pairs: width = 16*mw + 8*pin_ch
set row_w [expr {16*$mw + 8*$pin_ch}]
set x0 [expr {$core_lx + ($core_ux - $core_lx - $row_w)/2.0}]

set dd $dc_data
set y [expr {$core_uy - $edge - $mh}]
r8_row [r8_take dd 16] $x0 $y
set y [expr {$y - $rowpitch}]
r8_row [r8_take dd 16] $x0 $y
set top_band_bot $y

set y [expr {$core_ly + $edge}]
r8_row [r8_take dd 16] $x0 $y
set y [expr {$y + $rowpitch}]
r8_row [r8_take dd 16] $x0 $y
set bot_band_top [expr {$y + $mh}]

# ---- 2. dcache TAG: top-left (ways 0-3) and bottom-left (ways 4-7) ---------
set dt $dc_tag
set y [expr {$top_band_bot - 30.0 - $mh}]
for {set r 0} {$r < 4} {incr r} {
    r8_row [r8_take dt 3] [expr {$core_lx + 15.0}] $y
    set y [expr {$y - $rowpitch}]
}
set y [expr {$bot_band_top + 30.0}]
for {set r 0} {$r < 4} {incr r} {
    r8_row [r8_take dt 3] [expr {$core_lx + 15.0}] $y
    set y [expr {$y + $rowpitch}]
}

# ---- 3. icache cluster: right-center, 4 cols x 11 rows ----------------------
# order: data way0-1 (16) on top rows, tags+vd (13) middle, data way2-3 (16) bottom
set ic_all [concat [r8_take ic_data 16] $ic_tag [r8_take ic_data 16]]
set blk_w [expr {4*$mw + 2*$pin_ch}]
set nrows [expr {int(ceil([llength $ic_all] / 4.0))}]
set blk_h [expr {$nrows * $rowpitch - $vgap}]
set x0 [expr {$core_ux - $edge - $blk_w}]
set y  [expr {($core_ly + $core_uy)/2.0 + $blk_h/2.0 - $mh}]
set ic $ic_all
while {[llength $ic] > 0} {
    r8_row [r8_take ic 4] $x0 $y
    set y [expr {$y - $rowpitch}]
}

puts "Run8 human macro placement done: $total macros LOCKED\
 (dcache data top/bottom 16x2 each, dcache tags corners 4x3 each, icache right-center)"
