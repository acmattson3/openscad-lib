$fn = 64;

// 7.4: 
// * Two endcaps (DONE)
// * One spacer (DONE)
// 3.6: Two endcaps (DONE)
// 6.0: One spacer (DONE)
// 3.0: Two spacers

thing_h = 3.0;
is_spacer=true;

rod_dia = 4.0;
wall_thick = 2.6;
clip_gap = 3.0;
clip_rounding = 1.0;

union() {
    linear_extrude(thing_h) {
        offset(clip_rounding) offset(-clip_rounding)
        offset(-clip_rounding) offset(clip_rounding)
        difference() {
        circle(d=rod_dia+2*wall_thick);
        circle(d=rod_dia);
        if (is_spacer) {
            translate([rod_dia,0])
            #square([rod_dia/2+wall_thick*2, clip_gap], center=true);
        }
        }
    }
    if (!is_spacer) {
        translate([0,0,thing_h])
        linear_extrude(wall_thick)
        circle(d=rod_dia+2*wall_thick);
    }
}