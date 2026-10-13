// Drywall plug (bc the coat rack wasn't put into studs and me no want patch holes)

use <fillets.scad>

$fn = 48;

hole_d = 17.0; // Example measurements: right is 14, left is 13.
drywall_thick = 15.88;
plug_inner_overlap = 1.0;
plug_outer_overlap = 8.0;
plug_outer_thick = 1.0;
screw_len = 62.0;
screw_hole_d = 2.9; // Small so screw can bite but still be guided


module plugSolid() {
    // Round top
    translate([0,0,screw_len-0.4])
    sphere(d=hole_d);

    // Inner plug portion
    translate([0,0,plug_outer_thick+drywall_thick])
    cylinder(d1=hole_d+2*plug_inner_overlap, d2=hole_d, h=screw_len-(plug_outer_thick+drywall_thick));

    // Drywall portion
    translate([0,0,plug_outer_thick])
    linear_extrude(drywall_thick)
    circle(d=hole_d);

    // Outer stop
    linear_extrude(plug_outer_thick)
    offset(plug_outer_overlap)
    circle(d=hole_d);
    
    // Fillet on outer stop and drywall portion
    translate([0,0,plug_outer_thick])
    fillet(plug_outer_overlap/2, hole_d/2, inward = true, upward = false, scl = 0.5);
    // Fillet on inner stop and drywall portion
    translate([0,0,plug_outer_thick+drywall_thick-plug_inner_overlap*2/3])
    cylinder(d1=hole_d, d2=hole_d+2*plug_inner_overlap, h=plug_inner_overlap*2/3);
    
}

slot_h = (screw_len-(plug_outer_thick+drywall_thick))/1.6;

difference() {
    plugSolid();
    cylinder(d=screw_hole_d, h=screw_len+10);
    
    hull() {
        translate([-(hole_d+2*plug_inner_overlap)/2,0,plug_outer_thick+drywall_thick+slot_h+screw_hole_d])
        rotate([0,90,0])
        cylinder(h=hole_d+2*plug_inner_overlap, d=screw_hole_d*2);
        translate([-(hole_d+2*plug_inner_overlap)/2,0,plug_outer_thick+drywall_thick+screw_hole_d])
        rotate([0,90,0])
        cylinder(h=hole_d+2*plug_inner_overlap, d=screw_hole_d*2);
    }
    
    translate([50+hole_d/2-3,0,50])
    cube(100, center=true);
    translate([-50-hole_d/2+3,0,50])
    cube(100, center=true);
}