// Handle (for foam insert glass/foam inserts)

$fn = 64;

// Hand-insert hole dimensions
hole_l = 90.0;
hole_w = 20.0;
hole_d = 20.0;

handle_thick = 10.0;
handle_rounding = 5.0;

module handleHole2D() {
    translate([0,hole_d/2,0])
    offset(handle_rounding) offset(-handle_rounding)
    square([hole_l, hole_d], center=true);
}

module outerFillets2D() {
    difference() {
    translate([0,(hole_d+handle_thick)/2,0])
    difference() {
        square([hole_l+2*handle_thick+2*handle_rounding, hole_d+handle_thick], center=true);
        offset(handle_rounding) offset(-handle_rounding)
        translate([-2*handle_rounding-handle_thick-hole_l/2,0,0])
        square([handle_rounding*4,hole_d+handle_thick], center=true);
        offset(handle_rounding) offset(-handle_rounding)
        translate([2*handle_rounding+handle_thick+hole_l/2,0,0])
        square([handle_rounding*4,hole_d+handle_thick], center=true);
    }
    handleHole2D();
    translate([0, hole_d-handle_rounding/2+handle_thick])
    square([hole_l+2*handle_thick+2*handle_rounding, handle_rounding], center=true);
    }
}

module handleBody2D() {
    translate([0,(hole_d+handle_thick)/2,0])
    offset(handle_rounding) offset(-handle_rounding)
    square([hole_l+2*handle_thick, hole_d+handle_thick], center=true);
}

module filletedHandle2D() {
    outerFillets2D();
    difference() {
    handleBody2D();
    handleHole2D();
    }
}

linear_extrude(hole_w, convexity=6)
filletedHandle2D();