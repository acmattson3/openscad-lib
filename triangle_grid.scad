// Oragami Truss Grid

$fn = 64;

tube_rad = 2.0;
tria_base_len = 40.0;
tria_angle = 30.0;
tria_h_len = tria_base_len*tan(tria_angle);

gap_size = 0.4;

module triangle3D() {
    translate([tube_rad+gap_size, tube_rad+gap_size, 0])
    union() {
    hull() {
        sphere(tube_rad);
        translate([0,tria_h_len,0])
        sphere(tube_rad);
    }
    hull () {
        sphere(tube_rad);
        translate([tria_base_len,0,0])
        sphere(tube_rad);
    }
    hull() {
        translate([0,tria_h_len,0])
        sphere(tube_rad);
        translate([tria_base_len,0,0])
        sphere(tube_rad);
    }
    }
}

module triangle_unit() {
    triangle3D();
    translate([tria_base_len+4*tube_rad,tria_h_len+4*tube_rad,0])
    rotate([0,0,180])
    triangle3D();
}

module dupe_x() {
    for (i=[0:1]) {
        mirror([i, 0, 0])
        children();
    }
}

module dupe_y() {
    for (i=[0:1]) {
        mirror([0, i, 0])
        children();
    }
}

module triangle_quad() {
    translate([tria_base_len+4*tube_rad,-(tria_h_len+4*tube_rad),0])
    dupe_y() dupe_x() triangle_unit();
}

module triangle_grid(num) {
    dupe_x() dupe_y() triangle_quad();
}

triangle_grid();

clip_thick = 0.9;
clip_hand_rounding = clip_thick/2 - 0.01;
module triangleClipHand2D() {
    translate([-tube_rad-clip_thick/2,0,0])
    offset(clip_hand_rounding) offset(-clip_hand_rounding)
    difference() {
    circle(tube_rad+clip_thick);
    circle(tube_rad-0.02);
    translate([-tube_rad-clip_thick/4,0,0])
    square(2.2*clip_thick, center=true);
    }
}

module triangleClip2D() {
    
    triangleClipHand2D();
    mirror([1,0,0])
    triangleClipHand2D();
}

clip_h = 4;
module triangleClip3D() {
    linear_extrude(clip_h)
    triangleClip2D();
}

//triangleClip3D();
