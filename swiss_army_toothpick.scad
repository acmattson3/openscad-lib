// Swiss Army Knife Toothpick

pick_len = 45.0;
pick_wid = 3.0;
pick_thick = 1.25;
head_thick = 2.5;
head_len = 4.25;
point_ratio = 8.0;

module pickShaft3D() {
    difference() {
    linear_extrude(pick_thick)
    polygon([
        [0, pick_wid/2],[(point_ratio-1)*pick_len/point_ratio, pick_wid/2],
        [pick_len, 0],
        [(point_ratio-1)*pick_len/point_ratio, -pick_wid/2], [0, -pick_wid/2]
    ]);
    translate([5+(point_ratio-1)*pick_len/point_ratio,0,pick_thick/2+4.63])
    rotate([0,atan2(pick_thick, pick_len/point_ratio),0])
    #cube([pick_len/point_ratio+5, 10, 10], center=true);
    }
}

module pickHead3D() {
    difference() {
        translate([head_len,0,0])
        rotate([90,0,0])
        scale([head_len/head_thick, 1, 1])
        cylinder(r=head_thick, h=pick_wid, $fn = 64, center=true);
        translate([0,0,-10])
        cube([100, 100, 20], center=true);
        translate([head_len+5,0,5])
        cube([10, 10, 10], center=true);
    }
}

translate([1,0,0])
pickShaft3D();
pickHead3D();