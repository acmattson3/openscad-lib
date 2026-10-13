// Ring

$fn = 64;

finger_dia = 19.5;
ring_thick = 2.4;

linear_extrude(ring_thick)
difference() {
    circle(d=ring_thick*2+finger_dia);
    circle(d=finger_dia);
}
