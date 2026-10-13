// Dashcam Lense Cap
$fn = 64;

lense_upper_d = 26.8-0.8;
tip_h = 4;
primary_taper_d = 28.7-0.8;
taper_h = 13;
bottom_taper_d = 29.75-0.8;
cap_thick = 3;
base_h = 6;
base_d = 34.5;

module spherinder(r, h) {
    union() {
        cylinder(r=r, h=h/2);
        scale([1,1,h/r/2])
        sphere(r=r);
    }
}
//spherinder(3,10);

module lense() {
    cylinder(d1=base_d, d2=bottom_taper_d, h=base_h);
    translate([0,0,base_h])
    cylinder(d1=bottom_taper_d, d2=primary_taper_d, h=taper_h);
    translate([0,0,base_h+taper_h])
    cylinder(d2=lense_upper_d, d1=primary_taper_d, h=tip_h);
}

module lenseCap() {
    difference() {
        minkowski() {
            lense();
            cylinder(r=cap_thick, h=cap_thick);
        }
        lense();
        translate([0,0,-50])
        cube(100, center=true);
    }
}
intersection() {
    lenseCap();
    cylinder(d=base_d+2, h=100);
}