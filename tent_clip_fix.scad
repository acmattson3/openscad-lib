// Missing Tent Clip Replacement
$fn = 64;

// Base of clip (attaching to rod)
stock_dia = 18.0;
stock_rad = stock_dia/2;
stock_len = 35.0;
stock_to_pole_thick = 4.0;

// Clip
fork_len = 15.8;
fork_gap_base_dist = 4.0;
fork_gap_len = fork_len - fork_gap_base_dist;
barb_dist = 2.2;
barb_len = 8.0;
tip_shave_angle = 35;
fork_tip_w = 3.5;
fork_tip_h = 9.7;
forks_w = 9.7;
prong_w = 3.3;
forks_dist_base = 3.2;
forks_dist_tip = 2.2;
forks_tip_w = fork_tip_w*2 + forks_dist_tip;

// The clip without the gap for the forks
module solid_clip_2d() {
    hull () {
        square([forks_w, 0.01]);
        translate([(forks_w-forks_tip_w)/2,fork_len])
        square([forks_tip_w, 0.01]);
    }
}

module solid_clip_with_barbs_2d() {
    union() {
        solid_clip_2d();
        hull() {
            translate([(forks_w-forks_tip_w)/2,fork_len])
            square([forks_tip_w,0.01]);
            translate([-barb_dist+(forks_w-forks_tip_w),fork_len-barb_len])
            square([2*barb_dist+forks_tip_w,0.01]);
        }
    }
}

module forks_gap_2d() {
    hull () {
        translate([forks_w/2,fork_gap_base_dist+forks_dist_base/2])
        circle(forks_dist_base/2);
        translate([forks_w/2-forks_dist_tip/2,fork_len])
        square([forks_dist_tip, 0.01]);
    }
}

module forks_with_gap_2d() {
    difference() {
        solid_clip_with_barbs_2d();    
        forks_gap_2d();
    }
}

module forks_with_shaved_barbs() {
    difference() {
        forks_with_gap_2d();
        translate([(forks_w-forks_tip_w)/2,fork_len+1])
        rotate([0,0,tip_shave_angle])
        square([8.0, 4.0], true);
        translate([forks_tip_w,0])
        translate([(forks_w-forks_tip_w)/2,fork_len+1])
        rotate([0,0,-tip_shave_angle])
        square([8.0, 4.0], true);
    }
}

module forks_3d() {
    translate([-forks_w/2,0,0])
    linear_extrude(fork_tip_h)
    forks_with_shaved_barbs();
}


m3_shaft_len = 10.0;
m3_shaft_dia = 2.8;
m3_head_dia = 5.3;
m3_head_len = 3.0;
module m3_screw() {
    translate([0,0,m3_shaft_len+m3_head_len])
    rotate([180,0,0])
    union() {
    translate([0,0,m3_shaft_len])
    linear_extrude(m3_head_len)
    circle(m3_head_dia/2);
    linear_extrude(m3_shaft_len)
    circle(m3_shaft_dia/2);
    }
}

module m3_head_placed() {
    translate([0,m3_shaft_len/2,fork_tip_h/2])
    rotate([270,0,0])
    union() {
    linear_extrude(m3_head_len)
    circle(m3_head_dia/2);
    }
}

module m3_screw_placed() {
    translate([0,fork_gap_base_dist+m3_head_len,fork_tip_h/2])
    rotate([90,0,0])
    m3_screw();
}

difference() {
forks_3d();
m3_screw_placed();
hull() {
    m3_head_placed();
    translate([0,10,0])
    m3_head_placed();
}
}