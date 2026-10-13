// Dropper bulb (TPU print)

$fn = 32;
neck_inner_rad = 3.0;
neck_len = 7.0;
bulb_inner_rad = 5.5;
bulb_len = 22.0;
neck_bulb_diff = bulb_inner_rad - neck_inner_rad;
// The transition length between neck and bulb
curve_len = neck_bulb_diff;
wall_thick = 1.5    ;

p = [
    [neck_inner_rad+wall_thick/2, 0],
    [neck_inner_rad+wall_thick/2, neck_len],
    [bulb_inner_rad+wall_thick/2, neck_len+curve_len],
    [bulb_inner_rad+wall_thick/2, neck_len+curve_len+bulb_len],
    [1.3*(bulb_inner_rad/2+wall_thick/4), neck_len+curve_len+bulb_len+1.3*bulb_inner_rad/2],
    [0, neck_len+curve_len+bulb_len+bulb_inner_rad]
];

module line(points) {
    for (i = [0 : len(p)-2]) {
        translate(p[i])
        hull() {
            circle(d=wall_thick);
            translate([p[i+1][0]-p[i][0], p[i+1][1]-p[i][1]])
            circle(d=wall_thick);
        }
    }
    
}

module bulb2D() {
    difference() {
    line(p);
    translate([-50,,0])
    square(50);
    }
}

module bulb3D() {
    rotate_extrude()
    translate([0,0,0])
    rotate([0,0,0])
    bulb2D();
}
bulb3D();
