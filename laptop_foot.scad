// Replacement Laptop Foot

$fn = 64;

taper = 0.2;
foot_slot_depth = 2.0;
foot_h = 4.35-foot_slot_depth;
foot_w = 25.5; 
foot_l = 7.0;
union() {
translate([0,0,foot_slot_depth])
minkowski() {
cylinder(foot_h, foot_l/2, foot_l/2-taper);
cube([foot_w-foot_l, 0.01, 0.01]);
}
minkowski() {
cylinder(foot_slot_depth, foot_l/2, foot_l/2);
cube([foot_w-foot_l, 0.01, 0.01]);
}
}
