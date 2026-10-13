// Oven Handle Towel Grippy
$fn = 64;

// Oven Handle Dimensions
// Rounded semi-ellipctical shape
handle_horiz_rad = 23.65;
handle_vert_dia  = 35.37;
rounding = 2.0;
handle_mid_dist = 60.35;
handle_end_dist = 32.70;
handle_length = 673.1;

// Grippy Dimensions
spacing = 0.25;
grippy_len = 30.0;
grippy_wall_thick = 3.0;
spike_h = 3.0;
spike_rad = 2.0;

module ellipse(length, width) {
    scale([length/2, width/2, 1])
    circle(r=1);
}

module ovenHandle2D() { // Cross section of oven handle
    offset(rounding) offset(-rounding)
    difference() {
        ellipse(handle_vert_dia, handle_horiz_rad*2);
        translate([-handle_vert_dia/2, -handle_horiz_rad])
        square([handle_vert_dia, handle_horiz_rad]);
    }
}

module ovenHandleSegment3D() {
    translate([-(handle_horiz_rad)/2,-grippy_len/2,0])
    rotate([90,-90,180])
    linear_extrude(grippy_len)
    offset(spacing)
    ovenHandle2D();
}

module spike3D() {
    cylinder(spike_h, spike_rad, 0.01, $fn = 8);
}

module grippyTop3D() {
    z_offset = grippy_wall_thick + handle_vert_dia / 2;

    // Create the top cube
    cube([2 * grippy_wall_thick + handle_horiz_rad, grippy_len, z_offset], center = true);

    // Define the bounds for spike placement, inset by spike radius
    x_start = -(grippy_wall_thick + handle_horiz_rad / 2) + spike_rad;  // Inset by spike radius
    x_end = grippy_wall_thick + handle_horiz_rad / 2 - spike_rad;       // Inset by spike radius
    y_start = -grippy_len / 2 + spike_rad;                              // Inset by spike radius
    y_end = grippy_len / 2 - spike_rad;                                 // Inset by spike radius

    // Calculate the number of spikes that fit in each direction
    num_spikes_x = floor((x_end - x_start) / (2 * spike_rad));
    num_spikes_y = floor((y_end - y_start) / (2 * spike_rad));

    // Calculate actual spacing to distribute spikes evenly
    actual_spacing_x = (x_end - x_start) / max(1, (num_spikes_x - 1));
    actual_spacing_y = (y_end - y_start) / max(1, (num_spikes_y - 1));

    // Loop to place spikes evenly on the top surface
    for (i = [0 : num_spikes_x - 1]) {
        for (j = [0 : num_spikes_y - 1]) {
            x = x_start + i * actual_spacing_x;
            y = y_start + j * actual_spacing_y;
            translate([x, y, z_offset / 2]) {
                spike3D();
            }
        }
    }
}



module grippy3D() {
    difference () {
    union() {
        translate([-(handle_horiz_rad)/2,-grippy_len/2,0])
        rotate([90,-90,180])
        linear_extrude(grippy_len)
        offset(grippy_wall_thick)
        ovenHandle2D();
        translate([0,0,(grippy_wall_thick+handle_vert_dia/2)/2])
        grippyTop3D();
    }
    ovenHandleSegment3D();
    translate([0,0,-30])
    #cube([50,50,50], center = true);
    }
}


grippy3D();
//spike3D();






