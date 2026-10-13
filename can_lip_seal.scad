// TPU Can Lid

$fn = 32;

can_lip_outer_dia = 53.9;
can_lip_outer_rad = can_lip_outer_dia/2;
can_under_lip_dia = 52.5+0.25;//+0.75;
can_under_lip_rad = can_under_lip_dia/2;
can_lip_h = 2.5;
can_under_lip_h = 3.0;
can_lip_thick = 1.25;
can_lip_inner_dia = can_lip_outer_dia - 2*can_lip_thick;
can_lip_inner_rad = can_lip_inner_dia/2;
inset_dia = 47.6;
inset_rad = inset_dia/2;
inset_depth = 1.5;
inset_dist = 1.0;
inset_start_depth = 3.95;

seal_h = inset_start_depth + inset_depth;
seal_thick = 1.0;

module canTop3D() {
    difference() {
        union() { // Outline of can
            cylinder(h=inset_start_depth+inset_depth, r=can_under_lip_rad);
            translate([0,0,inset_start_depth+inset_depth])
            cylinder(h=can_lip_h, r1=can_under_lip_rad, r2=can_lip_outer_rad);
        }
        union() { // Inside of can
            translate([0,0,inset_start_depth+inset_depth])
            cylinder(h=can_lip_h, r=can_lip_inner_rad);
            translate([0,0,can_lip_h+inset_depth])
            cylinder(h=inset_start_depth-can_lip_h, r1=inset_rad, r2=can_lip_inner_rad);
            translate([0,0,can_lip_h])
            difference() {
                cylinder(h=inset_depth, r=inset_rad);
                cylinder(h=inset_depth, r=inset_rad-inset_dist);
            }
        }
        
    }
}

module canLipSeal3D() {
    translate([0,0,-can_lip_h])
    difference() {
    translate([0,0,can_lip_h])
    cylinder(h=inset_depth+inset_start_depth+seal_thick, r1=seal_thick+can_lip_outer_rad-1.0, r2=seal_thick+can_lip_outer_rad);
    canTop3D();
    translate([0,0,can_lip_h])
    cylinder(h=inset_start_depth+inset_depth, r1=inset_rad-inset_dist+0.3, r2=inset_rad-inset_dist);
    }
}

//canTop3D();

difference() {
//canTop3D();
canLipSeal3D();
//cube([500,500,500]);
}
