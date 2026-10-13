// Nilight LED Bar Mount Spacer
// Mounts that came with the bar are attached with
// bolts that are too long. Solutions are:
// * Get a shorter bolt (cut existing ones or buy new)
// * Get/make a spacer
// It is not feasible to cut the bolts, and going to
// buy a new one seems unnecessary when I can 3D print
// a spacer out of PETG!

$fn = 256;

spacer_thick = 3.5; // The extra space needed
bar_dia = 76.0; // |OOOOO| by (_) <- Dia of that!
washer_dia = 16.0;
//bolt_wall_dist = 2.8;
spacer_dia = washer_dia;// + bolt_wall_dist;
bolt_hole_dia = 8.2;


module ledBarSection() {
    translate([-spacer_dia/2, 0, -bar_dia/2])
    rotate([0,90,0])
    cylinder(h=spacer_dia, r=bar_dia/2);
}

module boltHole() {
    translate([0,0,-5])
    cylinder(h=10, r=bolt_hole_dia/2);
}

difference() {
    translate([0,0,-10])
    cylinder(h=spacer_thick+10, r=spacer_dia/2);
    ledBarSection();
    boltHole();
}