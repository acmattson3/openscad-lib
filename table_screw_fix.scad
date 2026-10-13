// Example table screw repair

$fn=32;

hole_inner_dia = 5.55;
hole_outer_dia = 10.15;
hole_depth = 46.0;
taper_len = hole_depth/2.0;
taper_dia = 7.5;
screw_hole_depth = 30.0;

difference() {
    union () {
        cylinder(h=hole_depth-taper_len, d=hole_outer_dia);
        translate([0,0,hole_depth-taper_len])
        cylinder(h=taper_len-taper_dia/2, d1=hole_outer_dia, d2=taper_dia);
        translate([0,0,hole_depth-taper_dia/2])
        //sphere(d=taper_dia);
        cylinder(h=taper_dia/2, d1=taper_dia, d2=0.01);
    }
    cylinder(h=screw_hole_depth, d=hole_inner_dia);
}