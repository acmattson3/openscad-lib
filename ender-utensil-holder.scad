// Spring-Retracting Multi-Utensil Holder for Ender 3 Pro Chassis
// 2025-03-06

use <pen_mount_ender_3_pro.scad>;
$fn = 32;

// Ender 3 Dimensions
ender_screw_hole_dist=14.4; // Distance between ender mount holes
ender_screw_hole_dia=3.3; // M3 Screw diameter
ender_screw_hole_rad=ender_screw_hole_dia/2;

bevel_tolerance = 0.8;
screw_bevel_dia = 5.45+bevel_tolerance;
screw_bevel_rad = screw_bevel_dia/2.0;
screw_bevel_dist = 1.9+bevel_tolerance;

rounding = 2.0;

// Utensils
pen_rad=4; // Radius of a typical pen

// Slider Dimensions
slider_panel_len = 1*ender_screw_hole_dist;
slider_panel_wid = 2*ender_screw_hole_dist;
slider_panel_h = 3.0;
sliding_bar_wid = 2.0;
sliding_bar_len = ender_screw_hole_dist;
sliding_bar_h = sliding_bar_wid;
slider_spacing = 0.2;

module screwBevel3D() {
    cylinder(d1=screw_bevel_dia, d2=ender_screw_hole_dia, h=screw_bevel_dist);
}

//screwBevel3D();

module slidingBar2D(spacing=0) {
    square([sliding_bar_len, sliding_bar_wid+spacing], center=true);
}

module slidingBars2D(spacing=0) {
    // Sliding bars
    translate([-slider_panel_len,ender_screw_hole_dist/1.5,0])
    slidingBar2D(spacing);
    translate([-slider_panel_len,-ender_screw_hole_dist/1.5,0])
    slidingBar2D(spacing);
}

module sliderPanel2D(do_holes=true) {
    // Body of slider
    difference() {
    square([slider_panel_len, slider_panel_wid], center=true);
    if (do_holes) {
        translate([0,-ender_screw_hole_dist/2,0])
        circle(r=ender_screw_hole_rad);
        translate([0,ender_screw_hole_dist/2,0])
        circle(r=ender_screw_hole_rad);
    }
    }
    
    //slidingBars2D();
}

module slidingBars3D(spacing=0) {
    linear_extrude(sliding_bar_h+spacing)
    slidingBars2D(spacing);
}

module sliderPanel3D(do_holes=true, spacing=0) {
    difference() {
    union() {
    linear_extrude(slider_panel_h)
    //offset(rounding) offset(-rounding)
    sliderPanel2D(do_holes);
    slidingBars3D(spacing);
    }
    if (do_holes) {
    translate([0,-ender_screw_hole_dist/2,0])
    screwBevel3D();
    translate([0,ender_screw_hole_dist/2,0])
    screwBevel3D();
    }
    }
}

module sliderAttach3D() {
    translate([0,0,slider_panel_h])
    rotate([180,0,0])
    difference() {
        union() {
            translate([-sliding_bar_len/2,0,slider_panel_h])
            cube([slider_panel_len+sliding_bar_len, slider_panel_wid, slider_panel_h*2], center=true);
            translate([0,0,slider_panel_h*2])
            rotate([0,180,0])
            linear_extrude(slider_panel_h*2, scale=(slider_panel_h+slider_panel_wid)/slider_panel_wid)
            offset(1) offset(-1)
            square([slider_panel_len, slider_panel_wid], center=true);
        }
        translate([50+slider_panel_len/2,0,0])
        cube([100,100,100], center=true);
        translate([0,0,slider_panel_h])
        rotate([180,0,0])
        sliderPanel3D(false, slider_spacing);
    }
}

module spacerPanel3D() {
    difference() {
    translate([-sliding_bar_len/2,0,(slider_panel_h/2)*1.5])
    cube([slider_panel_len+sliding_bar_len, slider_panel_wid, slider_panel_h*1.5], center=true);
    translate([0,-ender_screw_hole_dist/2,0])
    cylinder(r=ender_screw_hole_rad, h=slider_panel_h*1.5);
    translate([0,ender_screw_hole_dist/2,0])
    cylinder(r=ender_screw_hole_rad, h=slider_panel_h*1.5);
    }
}

translate([sliding_bar_len/2,0,slider_panel_h])
sliderAttach3D();
//sliderPanel3D();

//spacerPanel3D();

rotate([180,0,90])
difference() {
one_half();
cube([3,12,10], center=true);
}

