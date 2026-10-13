// Solenoid-screw connector
$fn = 64;


screw_dia = 3.5;
solenoid_screw_dia = 3.9;
wall_thick = 5.0;
connector_h = solenoid_screw_dia+2*wall_thick;
extra = 0.8;

module connector() {
    difference() {
        cylinder(d=screw_dia+2*wall_thick, h=connector_h-4, $fn=6);
        cylinder(d=screw_dia, h=connector_h);
        translate([0,0,connector_h/2])
        rotate([90,0,0])
        translate([0,0,-screw_dia/2-wall_thick])
        cylinder(h=screw_dia+wall_thick*2, d=solenoid_screw_dia);
        //cube(1000);
    }
}
connector();

washer_h = 2.2;
hole_d = 4.6;
washer_len = 6.8;
washer_wid = 6.2;

module washer() {
    linear_extrude(washer_h)
    difference() {
        square([washer_len, washer_wid], center=true);
        circle(d=hole_d);
    }
}