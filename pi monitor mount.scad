// Pi Screen Rail Mount

$fn = 64;

block_wid = 19.1;
block_h = 20.4;
block_dep = 18.0;
hole_dia = 6.4;

screen_screw_hole_dia = 4.0;
screen_hole_dist = 71.6;

module block_with_hole() {
    translate([0,0,block_h/2])
    cube([block_dep, block_wid, block_h], center=true);
    translate([block_dep/2, 0, block_h/2])
    rotate([0,90,0])
    cylinder(d=6.5, h=10.0);
}

module screen_attachment() {
    
    
}

block_with_hole();