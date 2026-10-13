// Step stool feet casings/covers

$fn = 64;

stretch_inset = 4.0;
foot_dia_short = 36.0 - stretch_inset;
foot_dia_long = 52.1 - stretch_inset;
foot_h = 9.0;

rod_dia_short = 24 - 2.0;
rod_dia_long = 32 - 2.0;

wall_thick = 3.0;

module foot_casing() {
    scale([foot_dia_long/foot_dia_short,1.0,1.0])
    cylinder(d1=foot_dia_short, d2=foot_dia_short-1.5*foot_h, h=foot_h);
}

difference() {
minkowski() {
foot_casing();
sphere(r=wall_thick);
}
foot_casing();
translate([0,0,250+foot_h])
cube(500, center=true);
//cube(500);
}