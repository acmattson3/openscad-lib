// Pebble Fred Arm(s)
use <springs.scad>

$fn = 32;

ball_dia = 7.5;
connection_dia = 5.35;
arm_dia = 9.0;
arm_len = 32.0; // From center of ball
arm_offset = 9.5; // Center of ball to center of arm
pad_h = 3.0;
cable_dia = 2.0;

difference() {
union() {
sphere(d=ball_dia);
rotate([-90,0,0])
cylinder(d=connection_dia, h=arm_offset);
translate([0,arm_offset,0]) {
    sphere(d=arm_dia);
    //translate([0,0,-arm_dia/2])
    //cylinder(d=arm_dia, h=arm_dia);
    intersection() {
        translate([15.5,0,0])
        rotate([0,0,90])
        translate([0,0,-arm_dia/2])
        linear_extrude(arm_dia)
        spring(arm_dia, 5.4, 1.5, 4);
        
        rotate([0,90,0])
        #cylinder(d=arm_dia, h=arm_len);
    }
    translate([arm_len-2,0,0])
    rotate([0,90,0])
    cylinder(d=arm_dia, h=pad_h);
    
    rotate([0,90,0])
    cylinder(d=arm_dia, h=5.1);
}
}
translate([0,arm_offset,0]) {
rotate([0,90,0])
cylinder(d=cable_dia, h=arm_len+pad_h);
sphere(d=cable_dia);
}

translate([0,-ball_dia/2,0])
rotate([-90,0,0])
cylinder(h=2*arm_offset+ball_dia/2, d=cable_dia);

translate([0,0,-50-connection_dia/2])
#cube(100, center=true);
}