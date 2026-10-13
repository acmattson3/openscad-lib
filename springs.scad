// 3D-printed springs
// "Track" with constant outer size; 'thick' only affects the hollow.
module springCircle(l, w, thick) {
    difference() {
        // Outer track
        offset(w/2-0.01) offset(-w/2+0.01)
            square([l, w], center=true);

        // Inner hollow inset by 'thick'
        offset(-thick)
            offset(w/2-0.01) offset(-w/2+0.01)
            square([l, w], center=true);
    }
}

module springCurve(l, w, thick) {
    intersection() {
        springCircle(l, w, thick);
        // Right half window
        translate([l/4, 0]) square([l/2, w], center=true);
    }
}

// One S-shaped segment whose OUTER height == w (independent of 'thick')
module springSegment(l, w, thick) {
    d = w - thick;                 // vertical center-to-center gap so the two halves meet cleanly
    translate([0,  d/2]) springCurve(l, w, thick);          // top half
    translate([0, -d/2]) mirror([1,0,0]) springCurve(l, w, thick); // bottom half (mirrored)
}

// Overall spring: X = l, Y = w + (curves-1)*(2*w - 2*thick)
module spring(l, w, thick, curves) {
    assert(w>thick);
    pitch   = 2*w - 2*thick;                 // vertical step between segments
    total_h = 2*w - 2*thick + (curves-2) * pitch;      // overall outer height
    translate([0, -total_h/2])               // center vertically
    for (i = [0 : curves-1]) {
        translate([0, i * pitch])
            springSegment(l, w, thick);
    }
    translate([0,total_h/2+w-thick])
    circle(d=w/2);
    translate([0,-(total_h/2+w-thick)])
    circle(d=w/2);
}