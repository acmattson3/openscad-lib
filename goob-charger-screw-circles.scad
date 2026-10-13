// Charge Station Spacer Circle Template

$fn = 64;

hole_dia =  3.0;
pad_hole_dist = 17.5; // From centers
near_hole_pads_dist = 42.5; // From centers; dist between nearest holes

module tingy() {
    circle(d=hole_dia);
}

tingy();
translate([0,pad_hole_dist,0]) {
    tingy();
    translate([0,near_hole_pads_dist,0]) {
        tingy();
        translate([0,pad_hole_dist,0])
            tingy();
    }
}