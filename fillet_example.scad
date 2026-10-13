// Fillets

module offsetSphere(rad, amount) {
    translate([amount,0,0])
    sphere(r=rad);
}

module offsetCube(size, amount) {
    translate([amount,0,0])
    rotate([0,0,45])
    cube([size/sqrt(2), size/sqrt(2), size], center=true);
}

module torify(step=16, scl=1.0) {
    scale([1.0, 1.0, scl])
    for (i=[0:step-1]) {
        hull() {
            rotate([0,0,i*360/step])
            children();
            rotate([0,0,(i+1)*360/step])
            children();
        }
    }

}

module condZTranslate(amount, cond) {
    if (cond) {
        translate([0,0,amount])
        children();
    } else {
        translate([0,0,-amount])
        children();
    }
}

module circularInwardFillet3D(circle_r, fillet_r, up=false, step=16, scl=1.0) {
    condZTranslate(-fillet_r*scl, up)
    intersection() {
        difference() {
            torify(step=step, scl=scl)
            offsetCube(size=fillet_r*2, amount=circle_r+fillet_r);
            torify(step=step, scl=scl)
            offsetSphere(rad=fillet_r, amount=circle_r+fillet_r);
        }
        if (up) {
            translate([0,0,0])
            cylinder(r=circle_r+fillet_r, h=fillet_r*scl, $fn=step);
        } else {
            translate([0,0,-fillet_r*scl])
            cylinder(r=circle_r+fillet_r, h=fillet_r*scl, $fn=step);
        }
    }
}

module circularOutwardFillet3D(circle_r, fillet_r, up=false, step=16, scl=1.0) {
    // For outward: keep true inner diameter = 2*circle_r
    // Build a torus with minor r=fillet_r centered at radius circle_r,
    // then keep only the outer half-ring [circle_r, circle_r+fillet_r].
    condZTranslate(-fillet_r*scl, up)
    intersection() {
        // Torus tube (built via your torify+hull trick) centered at circle_r
        difference() {
            torify(step=step, scl=scl)
                offsetCube(size=fillet_r*2, amount=circle_r);     // CHANGED: was circle_r+fillet_r
            torify(step=step, scl=scl)
                offsetSphere(rad=fillet_r, amount=circle_r);      // CHANGED: was circle_r+fillet_r
        }

        // Radial mask: keep outer half of the tube [circle_r, circle_r+fillet_r]
        if (up) {
            translate([0,0,0])
            difference() {
                cylinder(r=circle_r+fillet_r, h=fillet_r*scl, $fn=step); // outer bound
                cylinder(r=circle_r,          h=fillet_r*scl, $fn=step); // inner bound
            }
        } else {
            translate([0,0,-fillet_r*scl])
            difference() {
                cylinder(r=circle_r+fillet_r, h=fillet_r*scl, $fn=step);
                cylinder(r=circle_r,          h=fillet_r*scl, $fn=step);
            }
        }
    }
}


circularOutwardFillet3D(2, 2, up=true, step=32, scl=0.5);
