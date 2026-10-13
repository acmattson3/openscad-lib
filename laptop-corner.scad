// Laptop corner piece

$fn = 256;

module corner() {
    intersection() {
        linear_extrude(30)
        rotate([0,0,-0.23])
        translate([-10.597,21.9403,0])
        rotate([0,0,-90])
        import("corner-top.svg");
        translate([-10.05,30,-12.698])
        rotate([90,0,0])
        linear_extrude(30)
        import("corner-front.svg");
        translate([0,-3.6533,-13.0925])
        rotate([90,0,90])
        linear_extrude(30)
        import("corner-side.svg");
    }
}
        
module hollowCorner() {
    difference() {
    corner();
    translate([0,1.2,-0.25])
    scale([0.9, 0.9, 0.9])
    #corner();
    }
}

module cornerExtension() { // The piece that is needed but doesn't intersect
    intersection() {
        translate([0,10,0])
        difference() {
            corner();
            translate([-2.1,-1,-0.1])
            scale([1.1, 1.0, 1.2])
            #corner();
        }
        translate([0,-3.6533,-13.0925])
        rotate([90,0,90])
        linear_extrude(30)
        import("corner-side.svg");
    }
}

hollowCorner();
translate([0,-2,0])
cornerExtension();