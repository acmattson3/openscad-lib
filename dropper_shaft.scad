// Dropper Shaft (PLA/PETG print)

$fn = 32;
shaft_len = 50.0;
shaft_outer_rad = 6.1/2;
tip_inner_rad = 2.0/2;
tip_len = 0.0;
curve_len = 5.0; // Transition length between tip and shaft
wall_thick = 1.5;
tip_rad = tip_inner_rad + wall_thick/2;
shaft_rad = shaft_outer_rad - wall_thick/2;

p = [
    [shaft_rad, 0],
    [shaft_rad, shaft_len],
    [tip_rad, shaft_len+curve_len],
    [tip_rad, shaft_len+curve_len+tip_len]
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

module shaft2D() {
    line(p);
}

module shaft3D() {
    rotate_extrude()
    shaft2D();
}

shaft3D();