// Toothpick Holder/Dispenser
// Created out of necessity; everything online is gimmicky
// and overcomplicated. Just gimme a box, please!

$fn=16;

toothpick_len = 65.0;
toothpick_dia = 1.9;
tolerance = 0.3;

inner_rounding = 2.0;
box_needed_volume = 2*120.0*(toothpick_len+0.2)*30.0; // 2x bc tria
box_inner_len = toothpick_len+tolerance;
box_inner_wid = 120.0;
box_inner_h = (box_needed_volume/box_inner_wid)/box_inner_len;
wall_thick = 1.2;

outer_rounding = 0.8;
box_outer_len = box_inner_len + wall_thick*2;
box_outer_wid = box_inner_wid + wall_thick*2;
box_outer_h = box_inner_h + wall_thick*2;

module boxWedgeHole() {
    rotate([180,90,-90]) 
    translate([-box_inner_h-wall_thick,-box_inner_len/2,-box_inner_wid/2])
    linear_extrude(box_inner_wid, convexity=6)
    offset(inner_rounding) offset(-inner_rounding)
    offset(-inner_rounding) offset(inner_rounding)
    polygon([[0, 0], [0, box_inner_len], [box_inner_h, 0]]);
}

module boxBody() {
    linear_extrude(box_outer_h, convexity=6)
    offset(outer_rounding) offset(-outer_rounding)
    square([box_outer_len, box_outer_wid], center=true);
}

module boxComplete() {
    difference() {
        boxBody();
        boxWedgeHole();
    }
}

difference() {
boxComplete();
cube(200);
}