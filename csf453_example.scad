// CS F453 S26 Showcase Print
// 2026-01-13
//
// Print features:
// * Long, breakable rod (to be broken) (with and without fillet)
// * Long, not-so-breakable rod (combined with peeling example)
// * Progressively steeper overhang (combined with bridge and breakable rod)
// * Long bridge (combined with steep overhangs, breakable rod, fillet)
// * Small portion with poor adhesion (with and without brim)
// * Small portion prone to peeling/lifting (with and without brim)
// * Holes parallel and perpendicular to build plate (combined with d profile)
// * Thing that holds everything together is sparse, not sheet
// * Progressively larger text to showcase resolution (horiz and vert)

layer_thick = 0.2;
nozzle_dia = 0.4;

rod_size = 5.2;
fillet_rad = 1.6;
bridge_len = 60.0;
bridge_h = 20.0;
bridge_thick = 3*layer_thick;

// Modules can act on geometry!
module moveToBridgeEnd() {
    translate([0,bridge_len+rod_size])
    children(); // Says "any geometry following a call to this module"
}


module filletedRodBase() {
    translate([0,bridge_len+rod_size])
    offset(fillet_rad, $fn=24)
    square(rod_size);
}

module rodsAndBridgeBase() {
    square(rod_size);
    filletedRodBase();
}
//rodsAndBridgeBase();

module trapezoidTranslate() {
    translate([2*rod_size+4*nozzle_dia,trapezoid_len/2,0])
    children();
}

trapezoid_base = rod_size;
trapezoid_top = 1.5*nozzle_dia;
trapezoid_len = 40.0;
module flippedTrapezoidBase() {
    trapezoidTranslate()
    square([trapezoid_top, trapezoid_len], center=true);
}

module flippedTrapezoid() {
    hull() {
        linear_extrude(0.01)
        flippedTrapezoidBase();
        translate([0,0,trapezoid_base-0.01])
        trapezoidTranslate()
        linear_extrude(0.01)
        square([trapezoid_base, trapezoid_len], center=true);
    }
}
//flippedTrapezoid();

module brimmedTrapezoidTranslate() {
    translate([-rod_size-4*nozzle_dia,trapezoid_len/2,0])
    children();
}

module brimmedFlippedTrapezoidBase() {
    brimmedTrapezoidTranslate()
    square([trapezoid_top, trapezoid_len], center=true);
}

module brimmedFlippedTrapezoid() {
    hull() {
        linear_extrude(0.01)
        brimmedFlippedTrapezoidBase();
        translate([0,0,trapezoid_base-0.01])
        brimmedTrapezoidTranslate()
        linear_extrude(0.01)
        square([trapezoid_base, trapezoid_len], center=true);
    }
    
    brimmedTrapezoidTranslate()
    linear_extrude(layer_thick)
    offset(2.0, $fn=32) // Add a custom 2mm brim
    square([trapezoid_top, trapezoid_len], center=true);
}

//brimmedFlippedTrapezoid();

module rodsAndBridge3D() {
    // The diameter of the bridge's overhang
    overhang_dia = 2*(bridge_h-bridge_thick);
    
    difference() {
        // Bridge starts as a long rectangular prism
        linear_extrude(bridge_h)
        square([rod_size, bridge_len+2*rod_size]);
        
        // Cut out the arch (two hulled sideways cylinders)
        hull() {
            translate([0,rod_size+overhang_dia/2, overhang_dia/4])
            scale([1,1,0.5])
            rotate([0,90,0])
            cylinder(d=overhang_dia, h=rod_size, $fn=64);
            translate([0,rod_size+overhang_dia/2+bridge_len-overhang_dia,overhang_dia/4])
            scale([1,1,0.5])
            rotate([0,90,0])
            cylinder(d=overhang_dia, h=rod_size, $fn=20);
        }
        translate([0,rod_size,0])
        cube([rod_size, bridge_len, bridge_h/2]);
    }
    
    // Bridge fillet (more like a chamfer; not pretty in OpenSCAD!)
    hull() {
        moveToBridgeEnd()
        translate([0,0,fillet_rad-0.01])
        linear_extrude(0.01)
        square(rod_size);
        linear_extrude(0.01)
        filletedRodBase();
    }
}
rodsAndBridge3D();