// Pebble FRED Multimaterial Wheel

$fn = 64;

use <fillets.scad>;

// Tire
tire_outer_dia = 54.6+8.0-(3.6);
tire_inner_dia = 35.0-(3.6);
tire_h = 9.0;//7.5;
tire_rounding = 2.0;//3.5;
hub_outer_dia = tire_inner_dia;

// Tire Notch
notch_thick = (tire_outer_dia-tire_inner_dia)/(2*3.5);
notch_t_wid = 2*notch_thick;
notch_t_h = notch_thick;
num_notches = 3;
notch_rounding = 0.25;
notch_h = 2*tire_h/3;

// Tire Tread
tire_tread_num = 20;
tire_tread_inset = (tire_outer_dia-tire_inner_dia)/9;
tread_h = tire_h;
tread_divisor = 6;

// Axle
axle_h = 4.85;
axle_dia = 8.8;
axle_hex_wid = 6.56;
axle_inset_dist = 7.75-axle_h;
axle_screw_shaft_dia = 2.4;
axle_screw_head_dia = 5.2;
screw_lip_thick = 1.0;
fillet_r = 1.5;
fillet_scale = 0.75;

module tire2D() {
    difference() {
        circle(d=tire_outer_dia);
        circle(d=tire_inner_dia);
    }
}

module cylindricalTire() {
    linear_extrude(tire_h)
    tire2D();
}
//cylindricalTire();

// Provides mechanical connection between tire and hub
module tireNotch2D() {
    assert(notch_t_wid >= notch_thick);
    translate([0,tire_inner_dia/2+notch_thick/2-notch_t_h,0]) {
        hull() {
            translate([notch_t_wid-notch_thick, -notch_t_h])
            circle(d=notch_thick);
            translate([-(notch_t_wid-notch_thick), -notch_t_h])
            circle(d=notch_thick);
        }
        hull() {
            square(notch_thick, center=true);
            translate([0, -notch_t_h])
            square(notch_thick, center=true);
        }
        translate([0, -notch_t_h])
        square(notch_thick, center=true);
    }
}
//tireNotch2D();

module tireNotches2D() {
    for (i=[0:num_notches-1]) {
        rotate([0,0,i*360/num_notches])
        //linear_extrude(tire_h)
        tireNotch2D();
    }
}

module hub() {
    difference() {
        union() {
            translate([0,0,(tire_h-notch_h)/2])
            // notch section
            linear_extrude(notch_h) 
            circle(d=tire_inner_dia);
            // non-notch sections
            linear_extrude((tire_h-notch_h)/2)
            circle(d=tire_inner_dia);
            translate([0,0,notch_h+(tire_h-notch_h)/2])
            linear_extrude((tire_h-notch_h)/2)
            circle(d=tire_inner_dia);
        }
        translate([0,0,(tire_h-notch_h)/2])
        // notch section
        linear_extrude(notch_h) 
        tireNotches2D();
    }
}

module tireTread() {
    angle_takeup = 360/tire_tread_num;
    // The length of each piece of tread
    section_len = tire_outer_dia*sin(angle_takeup/2);
    r_squared = (tire_outer_dia/2)*(tire_outer_dia/2);
    half_l_squared = (section_len/2)*(section_len/2);
    section_dist = sqrt(r_squared-half_l_squared);
    translate([0,section_dist,(tire_h-tread_h)/2.0])
    linear_extrude(tread_h)
    polygon([
        [-section_len/tread_divisor, 0],
        [0, -tire_tread_inset],
        [section_len/tread_divisor, 0],
        [section_len/tread_divisor, 2*(tire_outer_dia/2-section_dist)],
        [-section_len/tread_divisor, 2*(tire_outer_dia/2-section_dist)]
    ]);
}
//tireTread();

module tireTreads() {
    for (i=[0:tire_tread_num]) {
        rotate([0,0,i*360/tire_tread_num])
        tireTread();
    }
}
//tireTreads();

module roundedTire() {
    assert(2*tire_rounding < tire_h);
    difference() {
        union() {
            translate([0,0,tire_rounding])
            minkowski() {
                linear_extrude(tire_h-2*tire_rounding)
                circle(d=tire_outer_dia-2*tire_rounding);
                sphere(r=tire_rounding);
            }
            translate([0,0,(tire_h-notch_h)/2])
            // notch section
            linear_extrude(notch_h) 
            tireNotches2D();
        }
        hub();
        tireTreads();
    }
}

module axleScrewHole(extra_h=0) {
    linear_extrude(tire_h+axle_h)
    circle(d=axle_screw_shaft_dia);
    linear_extrude(tire_h-axle_inset_dist-screw_lip_thick+extra_h)
    circle(d=axle_screw_head_dia);
}
//#axleScrewHole();

module hubAndAxle() {
    difference() {
        union() {
            translate([0,0,tire_h]) 
            linear_extrude(axle_h)
            circle(d=axle_dia);
            //circle(d=axle_hex_wid, $fn=6);
            hub();
        }
        translate([0,0,tire_h-axle_inset_dist]) 
        linear_extrude(axle_h+axle_inset_dist) 
        circle(d=axle_hex_wid, $fn=6);
        axleScrewHole();
    }
    translate([0,0,tire_h])
    fillet(fillet_r, axle_dia/2, inward=true, upward=false, scl=fillet_scale);
    translate([0,0,tire_h-axle_inset_dist-screw_lip_thick-1.5*(axle_screw_head_dia/2-axle_screw_shaft_dia/2)])
    fillet(axle_screw_head_dia/2-axle_screw_shaft_dia/2, axle_screw_shaft_dia/2, inward=false, upward=true, scl=1.5);
}

module tireAndHub() {
    roundedTire();
    color("#662222")
    hubAndAxle();
}

module displayTireAndHub() {
    difference() {
        tireAndHub();
        cube(100);
    }
}

text_h = 0.2;
hub_text = "FRED";
num_letters=4;
text_boldness = 0.1;
hub_offset = 10;
num_texts = 2;
text_spread_angle = 150;
font_size = hub_outer_dia/4;
module hubText() {
    //translate([0,0,tire_h-text_h])
    for (j=[0:num_texts-1]) {
        rotate([0,0,360/num_texts*j])
        linear_extrude(text_h)
        for (i=[0:num_letters-1]) {
            rotate([0,0,text_spread_angle/num_letters*i])
            translate([0,hub_offset])
            offset(text_boldness)
            scale([-1,1,1])
            text(hub_text[i], font_size, halign = "center", valign = "center", font = "rockwell condensed");
        }
    }
}

//difference() {
//hubAndAxle();
//cube(1000);
//}
//hub();
//roundedTire();
//difference() {
//    hubAndAxle();
//    hubText();
//}
//displayTireAndHub();

// Fred tracks
// Idea: Skinny tracks on each side (wheel-width)
// "Segments" of track whose angles change depending on
// diameter. Tracks aren't circular, but the pulleys are
// circular, and they'll be printed circular.

//$fn = 64;

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
        #trackV(motor_pulley_d+0.1, groove_size_extra);
    }
}
//motorCrownedPulley();
//bearingCrownedPulley();

module pulleyHubAndAxle() {
    difference() {
        union() {
            translate([0,0,tire_h]) 
            linear_extrude(axle_h)
            circle(d=axle_dia);
            //circle(d=axle_hex_wid, $fn=6);
            translate([0,0,-track_wid+tire_h])
            motorCrownedPulley();
        }
        translate([0,0,tire_h-axle_inset_dist]) 
        linear_extrude(axle_h+axle_inset_dist) 
        circle(d=axle_hex_wid, $fn=6);
        axleScrewHole();
        translate([0,0,-10])
        cylinder(d=axle_screw_head_dia, h=10);
    }
    translate([0,0,tire_h])
    fillet(fillet_r, axle_dia/2, inward=true, upward=false, scl=fillet_scale);
    translate([0,0,tire_h-axle_inset_dist-screw_lip_thick-1.5*(axle_screw_head_dia/2-axle_screw_shaft_dia/2)])
    fillet(axle_screw_head_dia/2-axle_screw_shaft_dia/2, axle_screw_shaft_dia/2, inward=false, upward=true, scl=1.5);
}

//difference() {
pulleyHubAndAxle();
//bearingCrownedPulley();
//cube(1000);
//}