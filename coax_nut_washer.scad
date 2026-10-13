// Coax Nut/Washer cover
// For holding the shelf against the wall without extra bolts/screws

$fn = 32;

coax_dia = 9.4;
coax_h = 12.0;
washer_dia = 25.0;
nut_dia = 15.0;
nut_h = coax_h+1.0;
washer_h = 1.0;

difference() {
    union() {
        linear_extrude(nut_h)
        circle(d=nut_dia, $fn=6);
        cylinder(h=washer_h, d=washer_dia);
        translate([0,0,washer_h])
        cylinder(h=5, d1=washer_dia, d2=coax_dia);
    }
    cylinder(d1=coax_dia, d2=coax_dia-0.2, h=coax_h);
    cylinder(d1=coax_dia+5, d2=coax_dia, h=2);
}