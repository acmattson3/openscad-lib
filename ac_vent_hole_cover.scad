// AC Vent Hole Cover

$fn = 256;
hole_rad = 142.8/2.0;
middle_notch_len = 146.7/2.0 - hole_rad;
middle_notch_wid = 7.8;
top_notch_len = 145.7/2.0 - hole_rad;
top_notch_wid = 7.8;
rad_notch_tip_wid = 14.2;
rad_notch_tip_len = 2.4;
rad_notch_wid = 20.1;
rad_notch_len = 14.7;
rad_notch_vert_dist = (51.3+91.5)/2.0;
rad_notch_angle = 60.0;
rad_notch_angle_from_vert = 90.0-rad_notch_angle/2.0;

rounding = 0.5;
round_offset = 2;
module radNotch2D() {
    union() {
    offset(rounding) offset(-rounding)
    translate([-rad_notch_wid/2,-round_offset])
    square([rad_notch_wid, rad_notch_len+round_offset]);
    
    offset(rounding) offset(-rounding)
    translate([-rad_notch_tip_wid/2,-round_offset+rad_notch_len])
    square([rad_notch_tip_wid, rad_notch_tip_len+round_offset]);
    }
}

module topNotch2D() {
    offset(rounding) offset(-rounding)
    translate([-top_notch_wid/2,-round_offset])
    square([top_notch_wid, top_notch_len+round_offset]);
}

module middleNotch2D() {
    offset(rounding) offset(-rounding)
    translate([-middle_notch_wid/2,-round_offset])
    square([middle_notch_wid, middle_notch_len+round_offset]);
}

module ventHole2D() {
    // Hole
    circle(hole_rad);
    
    // Radial notches
    rotate([0,0,rad_notch_angle_from_vert])
    translate([0, hole_rad])
    radNotch2D();
    rotate([0,0,-rad_notch_angle_from_vert])
    translate([0, hole_rad])
    radNotch2D();
    rotate([0,0,rad_notch_angle_from_vert+rad_notch_angle])
    translate([0, hole_rad])
    radNotch2D();
    rotate([0,0,-rad_notch_angle_from_vert-rad_notch_angle])
    translate([0, hole_rad])
    radNotch2D();
    
    // Top/bottom notches
    translate([0,hole_rad,0])
    topNotch2D();
    rotate([0,0,180])
    translate([0,hole_rad,0])
    topNotch2D();
    
    // Middle/side notches
    rotate([0,0,90])
    translate([0,hole_rad,0])
    middleNotch2D();
    rotate([0,0,-90])
    translate([0,hole_rad,0])
    middleNotch2D();
}

vent_cover_depth = 2.6+1.4;
vent_cover_lip_depth = 2.0;
vent_cover_lip_len = 2.0;
module ventCover3D() {
    union() {
    linear_extrude(vent_cover_lip_depth)
    offset(vent_cover_lip_len)
    ventHole2D();
    translate([0,0,vent_cover_lip_depth])
    linear_extrude(vent_cover_depth)
    ventHole2D();
    }
}

module ventHoleCoverSeal3D() {
    difference() {
    linear_extrude(vent_cover_lip_depth)
    offset(vent_cover_lip_len)
    ventHole2D();
    linear_extrude(vent_cover_lip_depth)
    ventHole2D();
    }
}


support_beam_len = 10.0; // Also the width
lever_bracket_thick = 3.0;
clamp_gap_size = 0.2;

module coverClampLeverBracket2D() {
    // View from the side facing the cover
    
}

//ventHole2D();
//ventCover3D();
//ventHoleCoverSeal3D();



