// Light switch cover (body parameters)
cover_w=115.2; // Cover width
cover_l=113.2; // Cover length
cover_h=5.5; // Cover height
cover_thick=2; // Cover thickness
grad_dist=cover_h; // Edge taper distance

// Switch hole parameters
switch_hole_l=10.9; // Switch hole length
switch_hole_w=24.0; // Switch hole width
switch_hole_sep=34.9; // Dist between switch holes

// Screw hole parameters
screw_dist_from_hole_top=14.4; // Dist from top of switch hole
screw_hole_rad_upper=7.0/2; // Upper screw radius
screw_hole_rad_lower=4.5/2; // Lower screw radius
screw_grad_dist=1.8; // Screw inset distance

module wantCube(l, w, h) {
    translate([-w/2,-l/2,0])
        cube([w, l, h]);
}

module wantRect(l, w) {
    translate([-l/2,-w/2,0])
    square([l, w]);
}

module switch_body() {
    hull() {
        wantCube(cover_l, cover_w, 0.001);
        translate([0,0,cover_h])
        wantCube(cover_l-2*grad_dist, cover_w-2*grad_dist, 0.001);
    }
}

module switch_hole() {
    wantCube(switch_hole_w, switch_hole_l, 30);
}

module switch_holes() {
    x=switch_hole_sep/2+switch_hole_l/2;
    translate([x,0,-15])
        switch_hole();
    //translate([-x,0,-15])
    //    switch_hole();
}

module screw_hole() {
    union() {
        translate([0,0,cover_h-screw_grad_dist+0.001])
            cylinder(h=screw_grad_dist, r2=screw_hole_rad_upper, r1=screw_hole_rad_lower, $fn=60);
        translate([0,0,cover_h-20])
            cylinder(h=20, r=screw_hole_rad_lower, $fn=60);
    }
}

module screw_holes() {
    y=screw_dist_from_hole_top+screw_hole_rad_upper+switch_hole_w/2;
    x=switch_hole_sep/2+switch_hole_l/2;
    translate([x,y,0])
        screw_hole();
    //translate([-x,y,0])
    //    screw_hole();
    translate([x,-y,0])
        screw_hole();
    //translate([-x,-y,0])
    //    screw_hole();
}

module switch_cover_final() {
    difference() {
        switch_body();
        translate([0,0,-cover_thick])
            switch_body();
        screw_holes();
        switch_holes();
    }
}

switch_cover_final();