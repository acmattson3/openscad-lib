// Computer case cover TPU protector

$fn = 64;

inside_d = 12.0;
inside_h = 0.8;
hole_d = 5.8;
hole_h = 3.3;
outer_d = 7.0;
outer_h = 0.6;
inner_hole_d = 3.4;

difference() {
    union() {
        cylinder(d=inside_d, h=inside_h);
        translate([0,0,inside_h])
        cylinder(d=hole_d, h=hole_h);
        translate([0,0,inside_h+hole_h])
        cylinder(d1=hole_d, d2=outer_d, h=outer_h);
    }
    cylinder(d=inner_hole_d, h=inside_h+hole_h+outer_h);
}