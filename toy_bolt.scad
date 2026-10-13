$fn = 64;

use <spiral_extrude.scad>;

// General
bolt_h = 46.1; // Total height of the bolt
// Head
head_h = 13.1; // The height of the bolt head (includes washer)
washer_h = 2.4; // The height of the washer portion
bolt_hex_lower_wid = 25.2; // The hex part tapers
bolt_hex_upper_wid = 24.0;
hex_h = head_h-washer_h; // Height of hex portion
// Bit hole
bit_upper_dist = 16.3; // So does the bit hole
bit_lower_dist = 15.4;
bit_plus_upper_wid = 6.7; // The skinny part of the + bit
bit_plus_lower_wid = 6.2; // does too
// Shaft
shaft_upper_dia = 14.5; // Before threads start
shaft_lower_dia = 11.3; // After threads end
shaft_h = bolt_h - head_h; // Length of shaft
shaft_inner_dia = 8.9;
bit_shaft_hole_dia = 5.8;
// Threads
thread_peak_dist = 5.4; // Distance between high points of threads
thread_end_dist = 3.2; // Dist between thread end and shaft end
thread_begin_dist = 3.9; // Dist between thread begin and shaft end
thread_h = shaft_h-thread_end_dist-thread_begin_dist; // Thread len
thread_thick = 3.6; // Thickness of thread teeth
thread_dist = 1.5; // Dist between thread teeth
thread_tooth_h = shaft_upper_dia-shaft_lower_dia; // height of teeth
thread_rot_num = 5; // Number of thread rotations

rounding = 0.6;
// One segment of the bit cross
module bit_lower_2d() {
    offset(-rounding) offset(rounding)
    offset(rounding) offset(-rounding)
    union() {
    square([bit_plus_lower_wid, bit_lower_dist],center=true);
    rotate([0,0,90])
    square([bit_plus_lower_wid, bit_lower_dist],center=true);
    }
}

// The plus-bit for the bolt
module bit_plus() {
    lu_scale = bit_plus_upper_wid/bit_plus_lower_wid;
    linear_extrude(height=hex_h,scale=lu_scale)
    bit_lower_2d();
}

module bolt_head() {
    lu_scale = bolt_hex_upper_wid/bolt_hex_lower_wid;
    union() {
    linear_extrude(height=head_h,scale=lu_scale)
    circle(d=bolt_hex_lower_wid,$fn=6);
    linear_extrude(washer_h,scale=0.86)
    circle(d=bolt_hex_lower_wid);
    }
}

module bitted_bolt_head() {
    difference() {
    bolt_head();
    translate([0,0,washer_h])
    bit_plus();
    }
}

module threads() {
    spiral_extrude(Radius=shaft_upper_dia/2,Height=thread_h+2,Pitch=4.9)
    rotate([0,0,45])
    square([thread_thick,thread_thick], center=true);
}



module bolt_shaft() {
    cylinder(h=shaft_h, d=shaft_lower_dia);
    difference() {
    translate([0,0,thread_end_dist])
    cylinder(h=shaft_h-thread_end_dist, d=shaft_upper_dia);
    //difference() {
    translate([0,0,thread_thick/2-2])
    threads();
    //translate([0,0,-250+thread_end_dist])
    //cube(500, center=true);
    //}
    }
}

union() {
bolt_shaft();
translate([0,0,shaft_h])
bitted_bolt_head();
}








