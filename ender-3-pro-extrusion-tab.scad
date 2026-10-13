// Ender 3 Pro extrusion tab

$fn=64;

trap_top_wid = 12.2;
trap_bot_wid = 5.2;
trap_h = 4.6;
gap_wid = 6.2;
hole_d = 3.0;

module trap(rotation=360) {
    rotate_extrude(rotation)
    polygon([
        [0,0],
        [trap_top_wid/2,0],
        [trap_bot_wid/2,trap_h],
        [0,trap_h]
    ]);
}

difference() {
    intersection() {
        trap(360);
        linear_extrude(trap_h)
        square([trap_top_wid, gap_wid], center=true);
    }
    cylinder(d=hole_d, h=trap_h);
}