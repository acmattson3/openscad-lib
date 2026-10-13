// Ant tube

tube_inner_h = 80;
wall_thick = 0.8;
tube_inner_d = 18.0;

module antTube() {
    difference() {
        cylinder(d=tube_inner_d+2*wall_thick, h=tube_inner_h+wall_thick);
        translate([0,0,wall_thick])
        cylinder(d=tube_inner_d, h=tube_inner_h);
    }
}

uprighter_thick = 10;
uprighter_flare_dist = 5;
rounding = 0.6; // Also for clippy action, if desired
uprighter_wall_thick = 2.0;

module tubeUprighter() {
    linear_extrude(uprighter_thick)
    offset(-rounding) offset(rounding)
    offset(rounding) offset(-rounding)
    difference() {
        hull() {
            translate([0,-tube_inner_d/2-wall_thick-uprighter_wall_thick])
            square([tube_inner_d+2*wall_thick+uprighter_flare_dist*2, 0.01], center=true);
            circle(d=tube_inner_d+2*uprighter_wall_thick);
        }
        circle(d=tube_inner_d+2*wall_thick);
    }
}

tubeUprighter();