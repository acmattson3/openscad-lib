// AriZona tea bottle shower head
$fn = 48;

cap_mouth_d = 42.0;
thread_h = 1.1;
// Two below are opposite of bottle
thread_wid = 1.0;
thread_gap = 2.45;
thread_h_gain = thread_gap+thread_wid;
thread_stop_bottom_dist = 3.0;
thread_stop_top_dist = 1.0;
cap_depth = 10.8;
wall_thick = 1.2;

module unthreadedCap() {
    difference() {
        cylinder(h=cap_depth+wall_thick, d=cap_mouth_d+2*wall_thick);
        translate([0,0,wall_thick])
        cylinder(h=cap_depth, d=cap_mouth_d);
    }
}
//unthreadedCap();

module thread() {
    scale([1.8,1.8,1])
    sphere(d=thread_wid);
}

module threads() {
    turns = cap_depth/thread_h_gain;
    steps = ceil($fn*turns);
    for (i=[0:steps-1]) {
        curr_r = 360*(i/$fn);
        curr_h = wall_thick+thread_h_gain*(curr_r/360);
        next_r = 360*((i+1)/$fn);
        next_h = wall_thick+thread_h_gain*(next_r/360);
        if (curr_h>=thread_stop_bottom_dist && curr_h<=cap_depth-thread_stop_top_dist) {
        hull() {
            rotate([0,0,curr_r])
            translate([cap_mouth_d/2,0,curr_h])
            thread();
            rotate([0,0,next_r])
            translate([cap_mouth_d/2,0,next_h])
            thread();
        }
        }
    }
}
//threads();

module threadedCap() {
    difference() {
        union() {
            unthreadedCap();
            threads();
        }
        translate([0,0,500+wall_thick+cap_depth])
        cube(1000, center=true);
    }
}
//threadedCap();

shower_head_h = 20.0;
shower_head_d = 50.0;
cap_rim_d = 34.0;
shower_hole_d = 0.8;
shower_hole_rings = 6;
shower_hole_gap = shower_hole_d/2;
center_hole = true;
module showerHeadHoles() {
    if (shower_hole_d > 0.001) {
        r_offset = shower_head_d/2/shower_hole_rings;
        for (i=[0:shower_hole_rings-1]) {
            curr_r = i*r_offset;
            steps = ceil(curr_r*PI*2/(1/shower_hole_gap));
            for (i=[0:steps-1]) {
                rotate([0,0,360*i/steps])
                translate([curr_r, 0,0])
                cylinder(d=shower_hole_d, h=wall_thick);
            }
        }
        if (center_hole) cylinder(d=shower_hole_d, h=wall_thick);
    }
}

module showerCap() {
    translate([0,0,shower_head_h])
    difference() {
        threadedCap();
        cylinder(h=wall_thick, d=cap_rim_d);
    }
    difference() {
        cylinder(h=shower_head_h, d1=shower_head_d, d2=cap_mouth_d+2*wall_thick);
        translate([0,0,wall_thick])
        cylinder(h=shower_head_h-wall_thick, d1=shower_head_d-2*wall_thick, d2=cap_rim_d);
        showerHeadHoles();
    }

}

//difference() {
showerCap();
//cube(1000);
//}