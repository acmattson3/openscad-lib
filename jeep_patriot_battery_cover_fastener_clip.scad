// 2013 Jeep Patriot Battery Cover Fastener Clip

$fn = 64;

head_dia = 17.9;
head_h = 10.0;
knob_tab_wid = 5.0;

shaft_len = 6.2;
shaft_wid = 6.2;
shaft_h = 12.0;
shaft_edge_round = 1.2;

shaft_hole_h = 5.3;
shaft_hole_wid = 3.1;
shaft_hole_offset = 5.75;
hole_tab_wid = 1.6;
hole_tab_len = 2.0;
hole_tab_h = 3.75;
hole_tab_angle = 30;
hole_tab_top_dist = 1.6;

tip_h = 4.85;
tip_point_len = 1.2;
tip_point_wid = 6.25;
tip_base_len = shaft_len;
tip_base_wid = 12.0;
tip_flange_wid = 2.1;
tip_flange_h = 3.0;

module clipHead() {
    cylinder(d=head_dia, h=head_h/4);
    intersection() {
        cylinder(d=head_dia, h=head_h);
        translate([0,0,head_h/2])
        cube([knob_tab_wid, head_dia, head_h], center=true);
    }
}

module clipRodRounded() {
    translate([0,0,-shaft_h/2])
    cube([shaft_len/2, shaft_wid/2, shaft_h]);
    translate([-shaft_len/2,-shaft_wid/2,-shaft_h/2])
    cube([shaft_len/2, shaft_wid/2, shaft_h]);
    translate([0,0,-shaft_h/2])
    linear_extrude(shaft_h)
    offset(shaft_edge_round) offset(-shaft_edge_round)
    square([shaft_len, shaft_wid], center=true);
}

module clipShaft() {
    difference() {
    translate([0,0,shaft_h/2])
    clipRodRounded();
    translate([0,0,shaft_hole_offset+shaft_hole_h/2])
    cube([shaft_len, shaft_hole_wid, shaft_hole_h], center=true);
    }
    
    hole_tab_offset = sqrt(2)*hole_tab_len/4;
    for (i=[0:1]) {
        rotate([0,0,180*i])
        translate([shaft_len/2-hole_tab_offset,0,hole_tab_offset+shaft_hole_offset])
        rotate([0,hole_tab_angle,0])
        cube([hole_tab_len, hole_tab_wid, hole_tab_h*2],center=true);
    }
}

module tipFlange() {
    translate([0,tip_base_wid/2, tip_h])
    scale([1,1,tip_flange_h/(shaft_len/2)])
    rotate([90,0,0]) {
    intersection() {
        cylinder(r=shaft_len/2, h=tip_flange_wid);
        cube([shaft_len/2,shaft_len/2,tip_flange_wid]);
    }
    translate([-shaft_len/2,4*shaft_len/5-shaft_len/2,0])
    cube([shaft_len/2,shaft_len/5,tip_flange_wid]);
    }
    
}

module clipTip() {
    difference() {
    hull() {
        translate([0,0,0.01])
        cube([tip_point_len,tip_point_wid,0.02],center=true);
        translate([0,0,-0.01+tip_h])
        cube([tip_base_len,tip_base_wid,0.02],center=true);
    }
    translate([-shaft_len/2,shaft_len/2,0])
    #cube([shaft_len/2,shaft_len/2,tip_h]);
    rotate([0,0,180])
    translate([-shaft_len/2,shaft_len/2,0])
    cube([shaft_len/2,shaft_len/2,tip_h]);
    }
    for (i=[0:1]) {
        rotate([0,0,180*i])
        tipFlange();
    }
}





translate([0,0,shaft_h+tip_h])
clipHead();
translate([0,0,tip_h])
clipShaft();
translate([0,0,0])
clipTip();






