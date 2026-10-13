// Mini PC Extended Lid (to fit fat 4TB HDD)

$fn = 32;

lid_len = 122.0;
lid_h = 2.0;
lid_rounding = 7.25;
// My additions (set to zero for default lid)
lid_depth = 8.0;
lid_wall_thick = 9.6;
cutout_rounding = lid_rounding/2;

latch_thick = 2.05;
latch_base_len = 8.1;
latch_base_h = 5.8;
latch_tip_h = 6.1;
latch_tip_len = 8.9;
latch_tip_up = 1.3;
tip_canter = 1.0;
tip_flat_len = 1.7;

hook_thick = 3.0;
hook_h = 5.75;
hook_len = 8.45;
hook_tip_h = 2.1;
hook_base_len = 5.45;
hook_back_rounding = 1.3;

lower_latch_orig_y = 44.5;
lower_latch_orig_x = 7.7;
upper_latch_orig_y = 40.83 + lower_latch_orig_y;
upper_latch_orig_x = lower_latch_orig_x;

lower_hook_orig_x = lid_len - 9.0;
lower_hook_orig_y = 30.9;
upper_hook_orig_x = lower_hook_orig_x;
upper_hook_orig_y = 94.5;

plus_arm_thick = 0.8;
plus_len = 2.7;
plus_orig_x = lower_latch_orig_x;
plus_orig_y = ((upper_latch_orig_y-latch_base_len/2)+lower_latch_orig_y)/2;
plus_h = 1.6;

front_text_string = "THE MIND";
front_text_size = 10.0;
front_text_font = "Liberation Sans:style=Bold Italic";
front_text_thick = 0.6;

module latch() {
    rotate([90,0,-90])
    linear_extrude(latch_thick)
    polygon([
        [0, 0],
        [0, latch_base_h],
        [latch_base_len-latch_tip_len, latch_base_h],
        [latch_base_len-latch_tip_len, latch_base_h+latch_tip_h-tip_canter],
        [latch_base_len-latch_tip_len+tip_canter, latch_base_h+latch_tip_h],
        [latch_base_len-latch_tip_len+tip_canter+tip_flat_len, latch_base_h+latch_tip_h],
        [latch_base_len, latch_base_h+latch_tip_up],
        [latch_base_len, 0]
    ]);
}

//latch();

module hook() {
    rotate([90,0,0])
    linear_extrude(hook_thick) {
    offset(hook_back_rounding) offset(-hook_back_rounding)
    square([hook_base_len, hook_h]);
    difference() {
        square([hook_base_len, hook_h]);
        translate([-hook_base_len/2, hook_h/2])
        square([hook_base_len, hook_h]);
    }
    translate([hook_base_len, 0]) {
        difference() {
            square([hook_len-hook_base_len, hook_h]);
            translate([hook_len-hook_base_len, 0])
            circle(r=hook_len-hook_base_len);
        }
    }
    }
}

//hook();

module plus() {
    corner_len = (plus_len-plus_arm_thick)/2;
    linear_extrude(plus_h)
    translate([-plus_len, -plus_len])
    difference() {
        square(plus_len);
        square(corner_len);
        translate([corner_len+plus_arm_thick, 0])
        square(corner_len);
        translate([corner_len+plus_arm_thick, corner_len+plus_arm_thick])
        square(corner_len);
        translate([0, corner_len+plus_arm_thick])
        square(corner_len);
    }
}

//plus();

module front_text() {
    linear_extrude(front_text_thick)
    translate([lid_len/2, lid_len/2])
    rotate([0,0,90])
    scale([-1,1,1])
    text(front_text_string, size=front_text_size, font=front_text_font, halign="center", valign="center");
}

//front_text();

module bare_lid() {
    difference() {
        linear_extrude(lid_depth+lid_h)
        offset(lid_rounding) offset(-lid_rounding)
        square(lid_len);
        translate([lid_wall_thick,lid_wall_thick,lid_h])
        linear_extrude(lid_depth)
        offset(cutout_rounding) offset(-cutout_rounding)
        square(lid_len-2*lid_wall_thick);
        front_text();
    }
}

module lid() {
    bare_lid();
    translate([0,0,lid_h+lid_depth]) {
        translate([lower_latch_orig_x,lower_latch_orig_y,0])
        latch();
        translate([upper_latch_orig_x,upper_latch_orig_y,0])
        latch();
        translate([lower_hook_orig_x,lower_hook_orig_y,0])
        hook();
        translate([upper_hook_orig_x,upper_hook_orig_y,0])
        hook();
        translate([plus_orig_x,plus_orig_y,0])
        plus();
    }
}

lid();