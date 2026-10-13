// FRED Motor Holdy thingy

$fn = 64;

rod_outer_d = 4.5+0.2;
screw_hole_d = 2.4+0.2;
hole_outer_dist = 48.3;
rod_offset_d = 7.4;
rod_thick = 3.0;
x_offset = hole_outer_dist/2 - rod_outer_d/2;


module holes2D() {
    difference() {
        hull() {
            translate([x_offset,0,0])
            circle(d=rod_offset_d);
            translate([-x_offset,0,0])
            circle(d=rod_offset_d);
        }
        translate([x_offset,0,0])
        circle(d=screw_hole_d);
        translate([-x_offset,0,0])
        circle(d=screw_hole_d);
        
    }
}
difference() {
    linear_extrude(rod_thick)
    holes2D();
    linear_extrude(rod_thick/2) {
        translate([x_offset,0,0])
        circle(d=rod_outer_d);
        translate([-x_offset,0,0])
        circle(d=rod_outer_d);
    }
}