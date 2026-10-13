// Window glass/foam clamp (*not* the block and clip)


clamp_thick = 15;
base_dia = 25;
clamp_h = 65;
clamp_len = 60;

module clampRod3D(do_scale=true) {
    if (do_scale) {
    scale([1.01, 1.01, 1])
    translate([0,-76,-15.01])
    import("clamp-rodV3.4.8.stl");
    }
    else {
    translate([0,-76,-15.01])
    import("clamp-rodV3.4.8.stl");
    }
}

module clampThreads3D(do_scaling=false) {
    difference() {
        clampRod3D(do_scaling);
        translate([0,0,-25])
        cube(50, center=true);
        translate([0,0,25+53])
        cube(50, center=true);
    }
}

module clampEnd3D() {
    translate([clamp_len/2, 0, 0])
    linear_extrude(clamp_thick)
    offset(base_dia/2.001) offset(-base_dia/2.001)
    square([clamp_len+base_dia-0.8, base_dia], center=true);
}

module clampBase3D() {
    translate([0,0,clamp_thick]) {
    translate([clamp_len,0,0])
    cylinder(d=base_dia, h=clamp_h+clamp_thick);
    translate([0, 0, clamp_h])
    clampEnd3D();
    }
}

//translate([0,0,-15])
//difference() {
//clampBase3D();
//clampRod3D();
//translate([clamp_len,0,0])
//clampThreads3D(true);
//}

translate([0,50,0])
difference() {
    union() {
    clampEnd3D();
    translate([clamp_len,0,0])
    clampThreads3D();
    }
    clampRod3D();
}