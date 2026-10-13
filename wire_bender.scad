// 20-gauge wire bender

$fn = 32;

wire_dia = 2.0; // With insulation
handle_len = 50.0; // Each part of the V
handle_wid = 22.0; // At base
handle_thick = 3.0; // Thickness *excluding* bearing height
border_thick = 5.0; // Thickness around holes
riser_thick = 3.0; // Thickness of stress risers/rounding
spacing = 0.2;

// Roller bearing params
bearing_inner_dia = 7.9;
bearing_outer_dia = 22.2;
bearing_h = 7.05;

module bender_out_holes() {
    circle(d=bearing_outer_dia);
    translate([handle_len,0])
    rotate([0,0,90])
    offset(border_thick) offset(-border_thick)
    square(handle_wid-border_thick, center=true);
}

module bender_out_outline() {
    difference() {
        offset(border_thick)
        hull() bender_out_holes();
        bender_out_holes();
    }
}

module bender_out_light() {
    difference() {
        bender_out_outline();
        offset(riser_thick) offset(-riser_thick)
        offset(-border_thick)
        bender_out_outline();
    }
}

module bender_out_3d() {
    difference() {
    linear_extrude(bearing_h+handle_thick)
    bender_out_light();
    translate([0,0,bearing_h]) {
        linear_extrude(handle_thick+spacing)
        offset(border_thick+spacing)
        circle(d=bearing_outer_dia, $fn=32);
        rotate([0,0,-10])
        #linear_extrude(handle_thick+0.01)
        square([bearing_outer_dia/2+border_thick,bearing_outer_dia/2+border_thick+3], center=false);
    }
    }
}

bender_out_3d();
