// TPU spring

//$fn=32;

module hollowCylinder(od, id, h, thick) {
    assert(id>thick*2);
    difference() {
        // Outer wall
        cylinder(d1=od, d2=id+thick*2, h);
        // Inner wall
        cylinder(d1=od-thick*2, d2=id, h);
    }
}


module rib(od, id, h, thick) {
    translate([0,0,h/2]) {
        hollowCylinder(od,id,h/2,thick);
        mirror([0,0,1])
        hollowCylinder(od,id,h/2,thick);
    }
}

module tpuSpring(od, id, h, thick, num_ribs) {
    rib_h = h/num_ribs;
    for (i=[0:num_ribs-1]) {
        translate([0,0,i*rib_h])
        rib(od, id, rib_h, thick);
    }
}
tpuSpring(20, 10, 50, 2, 10);
