// Stick to go behind drywall (holds patch)

$fn = 32;

screw_d = 3.0;
stick_thick = 4.0;
stick_len = 55;
stick_wid = 10;
rounding = 4;

difference() {
    linear_extrude(stick_thick)
    offset(rounding) offset(-rounding)
    square([stick_len, stick_wid], center=true);
    cylinder(h=stick_thick, d=screw_d);
    translate([3,0,0])
    #rotate([0,7,0])
    translate([0,0,9])
    cube([100, 100, 10], center=true);
    translate([-3,0,0])
    #rotate([0,-7,0])
    translate([0,0,9])
    cube([100, 100, 10], center=true);
}