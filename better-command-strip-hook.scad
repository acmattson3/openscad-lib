// Better command strip hook

$fn = 64;

sticky_len = 26.67+0.2;
sticky_wid = 15.58+0.2;
sticky_offset = 5.0;
wall_thick = 2.4;
hook_dist = 7;
hook_h = 12;
hook_offset = 8.0;

module hook2D() {
    square([sticky_len, wall_thick]);
    translate([hook_offset+hook_dist,wall_thick])
    rotate([0,0,90])
    intersection() {
        difference() {
            circle(r=hook_dist+wall_thick);
            circle(r=hook_dist);
        }
        square(hook_dist+wall_thick);
    }
    //square([wall_thick, hook_dist]);
    translate([hook_offset+hook_dist,hook_dist+wall_thick])
    square([hook_h-hook_dist, wall_thick]);
}

module hook() {
    linear_extrude(sticky_wid)
    offset(-wall_thick+0.01) offset(wall_thick-0.01)
    offset(wall_thick/3) offset(-wall_thick/3)
    hook2D();
}
hook();