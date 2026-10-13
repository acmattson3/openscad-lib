// Fred tracks
// Idea: Skinny tracks on each side (wheel-width)
// "Segments" of track whose angles change depending on
// diameter. Tracks aren't circular, but the pulleys are
// circular, and they'll be printed circular.

$fn = 64;

segment_len = 8;
segment_h = 2.4;
segment_wid = 9.0; // Also track wid
segment_wall_thick = 1.32; // 3 0.44 perimeters
segment_tip_len = 6.0;
segment_sloping = 2.0;
segment_overlap = 2.0;

module segment2D() {
    polygon([
        [-segment_len/2-segment_overlap/2,0],
        [-segment_tip_len/2,segment_h+segment_overlap],
        [segment_tip_len/2,segment_h+segment_overlap],
        [segment_len/2+segment_overlap/2,0]
    ]);
}
//segment2D();

module uncutSegment() {
    union() {
        linear_extrude(segment_sloping, scale=1/0.6)
        scale(0.6)
        segment2D();
        translate([0,0,segment_sloping])
        linear_extrude(segment_wid-2*segment_sloping)
        segment2D();
        translate([0,0,segment_wid])
        rotate([0,180,0])
        linear_extrude(segment_sloping, scale=1/0.6)
        scale(0.6)
        segment2D();
    }
}

module segment() {
    difference() {
        uncutSegment();
        translate([0,0,segment_wall_thick])
        scale((segment_h-segment_wall_thick/2)/segment_h)
        uncutSegment();
    }
}

track_thick = 4;
track_len = 223;
track_d = track_len/PI;
track_wid = 12.0;
// No tread, just a thick belt
module simpleTrack() {
    linear_extrude(track_wid)
    difference() {
        offset(track_thick)
        circle(d=track_d);
        circle(d=track_d);
    }
}
//simpleTrack();

num_cuts = 24;
cut_wid = 4;
cut_h = track_thick/2;

track_v_size = 2;
groove_size_extra = 0.5;
module trackV2D(extra=0.0) {
    polygon([
        [0,track_v_size+extra],
        [-track_v_size-extra,0],
        [0,-track_v_size-extra]
    ]);
}

module trackV(d = track_d, extra=0.0) {
    translate([0,0,track_wid/2])
    rotate_extrude(360)
    translate([d/2,0,0])
    trackV2D(extra);
}

module cutTrack() {
    trackV();
    difference() {
        simpleTrack();
        for (i=[0:num_cuts-1]) {
            rotate([0,0,360/num_cuts*i])
            translate([track_d/2+track_thick,0,0])
            linear_extrude(track_wid)
            polygon([
                [0,cut_wid/2],
                [-cut_h,0],
                [0,-cut_wid/2]
            ]);
        }
    }
}
//cutTrack();

bearing_od = 22+0.4;
bearing_id = 8+0.4;
bearing_wid = 7.2;
bearing_wall_thick = 1.2;

module uncutCrownedPulley(d, sloping) {
    cylinder(d1=d-2*sloping, d2=d, h=track_wid/3);
    translate([0,0,track_wid/3])
    cylinder(d=d, h=track_wid/3);
    translate([0,0,track_wid*2/3])
    cylinder(d2=d-2*sloping, d1=d, h=track_wid/3);
}

pulley_min_thick = 3.2;
module bearingCrownedPulley() {
    difference() {
        uncutCrownedPulley(bearing_od+2*pulley_min_thick, 1.0);
        cylinder(d=bearing_od, h=bearing_wid);
        cylinder(d=bearing_od-2*bearing_wall_thick, h=bearing_wid+0.4);
        #trackV(bearing_od+2*pulley_min_thick, groove_size_extra);
    }
}

motor_pulley_d = 52;
module motorCrownedPulley() {
    difference() {
        uncutCrownedPulley(motor_pulley_d, 1.0);
    }
}
//motorCrownedPulley();
bearingCrownedPulley();