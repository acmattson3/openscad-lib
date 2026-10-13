// Screen door latch spacer
// For example screen door

$fn = 32;

hole_dist = 45.4;
hole_dia = 4.6;
spacer_thick = 8.7;
latch_len = 57.3+0.4;
latch_wid = 12.7+0.4;
latch_base_thick = 2.0;
spacer_border_thick = 2.5;

module latchRect() {
    square([latch_len, latch_wid], center=true);
}
//latchRect();

module spacer2D() {
    offset(spacer_border_thick)
    latchRect();
}
//spacer2D();

module spacerHoles2D() {
    translate([hole_dist/2,0])
    circle(d=hole_dia);
    translate([-hole_dist/2,0])
    circle(d=hole_dia);
}
//#spacerHoles2D();

module cutSpacer2D() {
    difference() {
        spacer2D();
        spacerHoles2D();
    }
}
//cutSpacer2D();

module spacer() {
    difference() {
        linear_extrude(spacer_thick+latch_base_thick)
        cutSpacer2D();
        translate([0,0,spacer_thick])
        linear_extrude(latch_base_thick)
        latchRect();
    }
}
//spacer();


shaft_dia = 3.5;
head_dia = 8.3-0.2;
head_len = 3.9+1.0;
module tpuScrewSpacer() {
    difference() {
        linear_extrude(head_len)
        offset(1.0)
        square(latch_wid-1.0, center=true);
        
        cylinder(d1=shaft_dia, d2=head_dia, h=head_len);
    }
}
tpuScrewSpacer();



