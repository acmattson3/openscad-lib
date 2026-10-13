// Sink Drain Insert

$fn = 32;

drain_dia = 30.0/2;

spacing = 0.5;
outer_ring_dia = drain_dia+5.0;
outer_ring_h = 0.4;
cone_upper_dia = drain_dia - spacing;
cone_lower_dia = cone_upper_dia / 2.0;
cone_h = 20.0;
cone_thick = 0.8;
hole_dia = 2.5; // Diameter of the drainage holes
hole_spacing = 15.0; // Angular spacing between holes in degrees
rows = 10; // Number of rows of holes

module coverOuterRing3D() {
    linear_extrude(outer_ring_h)
    difference() {
        circle(outer_ring_dia);
        circle(drain_dia - spacing - cone_thick );
    }
}

module coverConeInsert3D() {
    translate([0,0,-cone_h])
    difference() {
        cylinder(cone_h, cone_lower_dia, cone_upper_dia);
        cylinder(cone_h, cone_lower_dia-cone_thick, cone_upper_dia-cone_thick);
    }
}

module coverConeInsertHoles3D() {
    for (row = [0 : rows - 1]) {
        for (angle = [0 : hole_spacing : 360 - hole_spacing]) {
            // Calculate the radius and vertical position for each row of holes
            z = -cone_h * (row / (rows - 1))+(hole_dia-row*0.15); // Linear spacing along cone height
            r = cone_lower_dia + (cone_upper_dia - cone_lower_dia) * (1 + z / cone_h); // Correct taper alignment
            
            // Place and subtract a cylindrical hole
            rotate([0, 0, angle+row*7.5])
            translate([r, 0, z])
            rotate([0, 90, 0])
            cylinder(h=cone_thick * 5, d=hole_dia-row*0.12, center=true, $fn = 6);
        }
    }
}

module coverConeInsertBottom3D() {
    translate([0, 0, -cone_h-0.4]) {
    //difference() {
    //    cylinder(h=cone_thick, r=((2*cone_lower_dia)/3));
    //    cylinder(h=cone_thick, r=((2*cone_lower_dia)/3)-1);
    //}
    cylinder(h=0.4+cone_thick/2.4, r=cone_lower_dia/2.5);
    difference() {
        // Create the base cap
        cylinder(h=0.4+cone_thick/2.4, r=cone_lower_dia);

        // Subtract radial slits
        for (angle = [0 : 30 : 360 - 30]) { // Adjust 30 for more or fewer slits
            rotate([0, 0, angle])
            translate([0, 0, -cone_thick+1.6])
            cube([cone_lower_dia * 1.8, cone_thick * 0.8, cone_thick * 2], center=true); // Long enough to cut through
        }
    }
    }
}

// Use the modules
difference() {
    coverConeInsert3D();
    coverConeInsertHoles3D();
}
coverOuterRing3D();
coverConeInsertBottom3D();
