// Hook for example water bottle on stroller
$fn = 48;

//nub_d = 15.9;
flex_gap_dist = 13.5;
flexy_gap = 2.4;
flex_nub_d = 5;
nub_dist_from_top = 15.9;
flare_dist = 21.3;
wall_thick = 2.4;
//disc_thick = 3.8; // Actual 3.94, but we want it to fit
rib_h = 3.4;

disc_thick = 3;
disc_dist = 2.8;
disc_d = 25;
disc_shaft_d = disc_d - 4.62*2+0.14;
mount_dia = 36;

slot_len = 33-disc_d/2;

bottle_strap_wid = 16.6;
bottle_strap_thick = 4.0;

echo(disc_shaft_d);

module front_cutout() {
    hull() {
        circle(d=disc_shaft_d);
        translate([0,-disc_shaft_d/2-0.01])
        square([8.5, 0.01], center=true);
    }
    hull() {
        translate([0,-slot_len/2-disc_shaft_d/4])
        square([8.5, slot_len-disc_shaft_d/2], center=true);
        translate([0,-1-slot_len])
        square([flare_dist,2], center=true);
    }
    
    translate([flex_gap_dist/2,disc_shaft_d/2-nub_dist_from_top])
    #circle(d=flex_nub_d);
}
front_cutout();