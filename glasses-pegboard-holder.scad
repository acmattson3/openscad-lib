// Pegboard Glasses Holder (nose)

$fn = 64;

nose_len = 3.1;
nose_wid = 5;
nose_h = 5.0;
nose_scale = 9;
arms_nose_rest_dist = 33.0;
nose_ext_len = arms_nose_rest_dist+22.0;
back_thick = 5;
peg_hole_sep = 25.4;
peg_hole_dia = 6.0;


module noseIntersectCube() {
    scale(nose_scale)
    linear_extrude(nose_h)
    translate([0,-nose_wid/2])
    square([nose_len,nose_wid]);
}

module nose() {
    intersection() {
        scale(nose_scale)
        translate([-10.5,0,1.8])
        scale(100)
        rotate([90,0,-1.4])
        import("lawlorhead_10k.stl");
        noseIntersectCube();
    }
}
//nose();

rounding = 0;
module noseBaseProjection() {
    offset(-rounding) offset(rounding)
    offset(rounding) offset(-rounding)
    projection(cut=true)
    translate([0,0,-0.01])
    rotate([0,-90,0])
    nose();
}

module noseExtension() {
    translate([-nose_ext_len-back_thick,0,0])
    rotate([0,90,0])
    linear_extrude(nose_ext_len+back_thick)
    noseBaseProjection();
}
//noseExtension();
//nose();

module cutNoseExtension() {
    difference() {
        noseExtension();
        translate([-nose_ext_len,-nose_scale*nose_wid/2,nose_h/2*nose_scale])
        scale(nose_scale)
        linear_extrude(nose_h/2)
        square([(nose_ext_len-arms_nose_rest_dist)/nose_scale, nose_wid]);
    }
}
//cutNoseExtension();

module pegHoles() {
    translate([-nose_ext_len-back_thick+peg_hole_sep,0,nose_h*nose_scale/2])
    rotate([0,-90,0]) {
        translate([peg_hole_sep/2,0,0])
        cylinder(h=peg_hole_sep, d=peg_hole_dia);
        translate([-peg_hole_sep/2,0,0])
        cylinder(h=peg_hole_sep, d=peg_hole_dia);
    }
}

module noseGlassesHolder() {
    difference() {
        translate([0,2,0])
        union() {
            nose();
            cutNoseExtension();
        }
        pegHoles();
    }
}
//noseGlassesHolder();

peg_rod_dia = 4.7625;
peg_insert_dist = 10;
module pegRod() {
    cylinder(d=peg_rod_dia, h=back_thick+peg_rod_dia/2+2);
    translate([-peg_insert_dist/2,0,peg_rod_dia/4])
    cube([peg_insert_dist,peg_rod_dia,peg_rod_dia/2], center=true);
}
//pegRod();

cylinder(d=peg_rod_dia, h=25.4+4);