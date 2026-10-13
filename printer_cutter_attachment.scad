// 3D Printer Cutter Attachment
// Uses a bearing to venter the cutting tip of the blade
// as the 3D printer moves.

$fn = 64;
blade_len = 11.4; // Base to tip of blade distance
blade_rad = 3.2/2.0; // Radius of cutting blade
blade_angle = 11.5;
blade_holder_lip_len = 0.5;
backstop_len = 1.0; // How much of a backstop the insert
                    // in the bearing has. The blade will
                    // stick out this far:
                    // blade_len - bearing_h + backstop_len

bearing_inner_rad = 9.6/2.0; // Inner circle of bearing
bearing_inner_ring_rad = 12.5/2.0;
bearing_outer_rad = 22.2/2.0; // Outer circle of bearing
bearing_outer_ring_rad = 24.5/2.0;
bearing_outer_ring_h = 1.4;
bearing_h = 7.1;

spring_len = 14.3;
piston_len = 5.0;
cap_len = 2.0;
cylinder_len = spring_len + piston_len;

bearing_block_len = bearing_outer_rad*2.0 + 5.0;
bearing_block_connector_wid = 6.0;

// Ender 3 Pro mounting params
screw_hole_dist=14.4;
screw_hole_dia=3.0;
screw_hole_rad=screw_hole_dia/2;
screw_len = 20;
hotend_vert_dist = 50.0; // (Vertical) Distance from the screwholes to the hotend location
hotend_horiz_dist = 12.0/2.0; // (Horizontal) Distance from screw holes to center of hotend location

gap_size = 0.02;

// The top-down blade
module blade2D() {
    circle(blade_rad+gap_size);
}

// What holds the cutter inside of the bearing
module blade_holder2D() {
    circle(bearing_inner_rad-gap_size);
}

// The block that holds onto the bearing
module bearing_block2D() {
    difference() {
        union() {
        translate([0,bearing_block_len/4.0])
        square([bearing_block_len, bearing_block_len/2.0], center=true);
        circle(bearing_block_len/2.0);
        }
        circle(bearing_outer_rad+gap_size);
    }
}

//bearing_block2D();
//blade_holder2D();

piston_gap_size = 1.1;
module blade_insert3D() {
    difference() {
    translate([0,0,blade_holder_lip_len+0.3])
    linear_extrude(piston_len-blade_holder_lip_len)
    offset(-piston_gap_size-0.06) blade_holder2D();
    translate([1.8*blade_rad+0.2, 0, -blade_rad*4.8])
    rotate([0,blade_angle,180])
    linear_extrude(blade_len)
    blade2D();
    }
}

//blade_insert3D();

module blade_holder3D() {
    // TODO: Add emerging screw holes for a screw-on
    //       cap!
    
    difference() {
    linear_extrude(blade_holder_lip_len)
    circle(bearing_inner_ring_rad);
    linear_extrude(blade_holder_lip_len)
    circle(bearing_inner_rad-(bearing_inner_ring_rad-bearing_inner_rad));
    }
    
    difference() {
    union() {
    translate([0,0,blade_holder_lip_len])
    linear_extrude(cylinder_len+0.4)
    blade_holder2D();
    linear_extrude(blade_holder_lip_len)
    circle(bearing_inner_ring_rad);
    }
    //translate([0,0,4])
    linear_extrude(cylinder_len+4)
    offset(-1.0) blade_holder2D();
    //translate([1.8*blade_rad+0.2, 0, -blade_rad/4.0])
    //rotate([0,blade_angle,180])
    //linear_extrude(blade_len)
    //blade2D();
    }
    //blade_insert3D();
    //translate([0,0,bearing_h-backstop_len])
    //linear_extrude(backstop_len)
    //circle(bearing_inner_rad-gap_size);
}

module screw_holes(extra_wid=0.0, extra_len=0.0) {
    translate([0, screw_len/2, 0])
    rotate([90,0,0]) {
        translate([(screw_hole_dist+extra_wid)/2,0,0])
        cylinder(r=screw_hole_rad, h=screw_len+extra_len);
        translate([-(screw_hole_dist+extra_wid)/2,0,0])
        cylinder(r=screw_hole_rad, h=screw_len+extra_len);
    }
}

module bearing_block3D() {
    linear_extrude(bearing_h-bearing_outer_ring_h)
    bearing_block2D();
}

support_triangle_wid = bearing_block_len/2-(bearing_outer_rad+gap_size);
module support_triangle() {
    rotate([0,-90,0])
    linear_extrude(support_triangle_wid)
    polygon([[0, 0], [0, bearing_block_len/2], [hotend_vert_dist-bearing_h*2+bearing_outer_ring_h, bearing_block_len/2]]);
}

module bearing_block_connector3D() {
    difference() {
    union() {
    translate([0, bearing_block_len/2.0+bearing_block_connector_wid/2, (hotend_vert_dist-bearing_h)/2])
    cube([bearing_block_len, bearing_block_connector_wid, hotend_vert_dist-bearing_h], center=true);
    translate([bearing_block_len/2,0,bearing_h-bearing_outer_ring_h])
    support_triangle();
    translate([-bearing_block_len/2+support_triangle_wid,0,bearing_h-bearing_outer_ring_h])
    support_triangle();
    }
    translate([0, bearing_block_len/2.0+bearing_block_connector_wid/2, hotend_vert_dist-bearing_h-4])
    screw_holes();
    }
}


// TODO: Incorporate spring into blade holder!
//difference() {
blade_holder3D();
//cube(500);
//}
//#cube([9.3, 1.0, 1.0], center=true);
//difference() {
//union() {
//bearing_block3D();
//bearing_block_connector3D();
//}
//translate([0,13,bearing_h/2-screw_hole_rad/2])
//screw_holes(extra_wid=6.0, extra_len=-5.0);
//}

