// bender block
$fn = 32;

wire_dia = 2.2; // With insulation

block_len = 55.0;
block_wid = 20.0;
block_h = 4.2;
block_rounding = 3.0;
end_space = 5.0;

// Dimensions for top bending geometry
bender_h = 3.0; // A little thicker than the wire diameter
triangle_ratio = 4;

bender_stick_h = bender_h*2; // Above block
bender_stick_padding = 1.0;
bender_stick_dia = 3.0;
num_bender_sticks = 3; // Around the center one
bender_stick_x_offset = -1.5;

mount_screw_shaft_dia = 3.65;
mount_screw_shaft_len = 15.6;
mount_screw_head_dia = 6.6;
mount_screw_head_len = 2.4;
mount_screw_head_top_h = 1.5;

module mount_screw() {
    translate([0,0,-mount_screw_head_len])
    linear_extrude(mount_screw_head_len, scale = mount_screw_head_dia/mount_screw_shaft_dia)
    circle(d=mount_screw_shaft_dia);
    translate([0,0,-mount_screw_shaft_len-mount_screw_head_len])
    linear_extrude(mount_screw_shaft_len)
    circle(d=mount_screw_shaft_dia);
    linear_extrude(mount_screw_head_top_h)
    circle(d=mount_screw_head_dia);
}



module block_body() {
    linear_extrude(block_h)
    offset(block_rounding) offset(-block_rounding)
    square([block_len, block_wid], center=true);
}

module block_triangle() {
    translate([block_wid/2,-block_wid/2,0])
    linear_extrude(bender_h)
    polygon([
        [0,0],
        [0,block_wid],
        [block_wid/2,block_wid/triangle_ratio]
    ]);
}

module block_semicircle() {
    translate([-block_wid/2,0,0])
    linear_extrude(bender_h)
    difference() {
        circle(d=block_wid);
        translate([block_wid/2,0,0])
        square(block_wid, center=true);
    }
}

module block_mid_rects() {
    linear_extrude(bender_h)
    square([block_wid-wire_dia*2,block_wid], center=true);
}

module solid_block() {
    block_body();
    translate([0,0,block_h])
    color("#a52020", 1.0) {
        block_triangle();
        block_mid_rects();
        block_semicircle();
    }
}

module bender_stick(space=0.0) {
    linear_extrude(bender_stick_h*2)
    circle(d=bender_stick_dia-space);
}

module bender_stick_holes(spacing=0.0) {
    rotate([0,0,180])
    translate([bender_stick_x_offset,0,bender_stick_padding]) {
        bender_stick(spacing);
        for (i=[0:num_bender_sticks]) {
            rotate([0,0,i*(360/num_bender_sticks)])
            translate([bender_stick_dia+wire_dia,0,0])
            bender_stick(spacing);
        }
    }
}

mount_screw_edge_dist = 0.4;
module bender_block() {
    bender_stick_holes();
    difference() {
        solid_block();
        
        translate([0,0,block_h-mount_screw_head_top_h]) {
            translate([-block_len/2+mount_screw_head_dia/2+mount_screw_edge_dist,-block_wid/2+mount_screw_head_dia/2+mount_screw_edge_dist])
            mount_screw();
            translate([block_len/2-mount_screw_head_dia/2-mount_screw_edge_dist,block_wid/2-mount_screw_head_dia/2-mount_screw_edge_dist])
            mount_screw();
        }
    }
    
}
bender_block();
//translate([block_len/2+10,0,-bender_stick_padding])
//bender_stick_holes(spacing=0.1);
//bender_stick(0.1);