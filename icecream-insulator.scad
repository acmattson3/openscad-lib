// Ice cream tub insulator (idk)

$fn = 64;

tub_dia = 120.0;
tub_h = 114.5;
wall_thick = 10.0; // Chonk to keep cold in

minkowski() {
    difference() {
        translate([0,0,wall_thick/2])
        cylinder(d=tub_dia+wall_thick+0.01, h=tub_h);
        translate([0,0,wall_thick])
        cylinder(d=tub_dia+wall_thick, h=tub_h);
    }
    sphere(d=wall_thick);
}

