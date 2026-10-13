// Fillets


// Creates a 3D fillet using rotate_extrude.
// Parameters:
//   fillet_rad — fillet radius
//   center_rad — distance from rotation center
//   inward     — mirror horizontally (true = inward, false = outward)
//   upward     — mirror vertically (true = upward, false = downward)
//   scl        — vertical scale factor
module fillet(fillet_rad, center_rad, inward = true, upward = true, scl = 1.0) {
    // Determine mirror axes
    mirror_vec = [
        inward ? 1 : 0,   // mirror X if inward
        upward ? 0 : 1    // mirror Y if downward
    ];

    // Assumes $fn is set externally
    scale([1, 1, scl])
    rotate_extrude()
    translate([center_rad, 0])
    translate([fillet_rad / 2, fillet_rad / 2])
    mirror(mirror_vec)
    translate([-fillet_rad / 2, -fillet_rad / 2])
    intersection() {
        difference() {
            square(fillet_rad * 2, center = true);
            circle(r = fillet_rad);
        }
        square(fillet_rad);
    }
}

// Example usage
fillet(2, 2, inward = false, upward = false, scl = 0.5);


//newCircularInwardFillet3D(2, 2, up=true, step=32, scl=0.5);