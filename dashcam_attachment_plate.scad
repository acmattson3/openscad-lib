// Dashcam mirror mount (suction cup broke D:)

$fn = 32;

plate_wid = 41.5;
plate_len = 35.0;
plate_rounding = (plate_wid-19.0)/2;
plate_thick = 3.5;
catch_thick = plate_thick-2.2; // Ledge that catches the circle inserts
insert_dia = 4.3;
insert_len = 8.0;
catch_dia = 2.1;
sticker_thick = 0.4;
sticker_rim = 1.4;

// From bottom left corner (suction cup up and facing you)
bl_hole_v_dist = 8.8+insert_dia/2;
bl_hole_h_dist = 4.2+insert_len-insert_dia/2; // Center of big circle
br_hole_v_dist = bl_hole_v_dist;
br_hole_h_dist = 26.3+insert_len-insert_dia/2; // C.O.B.C
t_hole_v_dist = 35.1+insert_dia/2;
t_hole_h_dist = 16.2+insert_len-insert_dia/2;
catch_rounding = 0.3;

tab_hole_v_dist = 18.0;
tab_hole_h_dist = 14.75;
tab_hole_len = 12.4;
tab_hole_wid = 6.1;

b_aligner_v_dist = 14.18;
b_aligner_h_dist = 15.0;
t_aligner_v_dist = 27.0;
t_aligner_h_dist = b_aligner_h_dist;
aligner_len = 16.8;
aligner_wid = 0.85;
aligner_thick = aligner_wid*1.25;

snapper_wid = 3.5;
snapper_len = tab_hole_len;
snapper_v_dist = tab_hole_v_dist+(tab_hole_wid-snapper_wid)/2;
snapper_h_dist = tab_hole_h_dist;
snapper_d_dist = 1.6;
snapper_thick = plate_thick-(0.95+snapper_d_dist);
snapper_ledge_h = snapper_d_dist;
snapper_ledge_len = 3.5;
snapper_ledge_h_rel = 5.2;

module aligner() {
    linear_extrude(aligner_thick)
    square([aligner_len, aligner_wid]);
}

module snapper() {
    translate([snapper_ledge_h_rel,0,0])
    hull() {
        translate([snapper_ledge_len/2-0.2,0,0])
        linear_extrude(0.01)
        square([0.4, snapper_wid]);
        translate([0,0,snapper_ledge_h])
        linear_extrude(0.01)
        square([snapper_ledge_len, snapper_wid]);
    }
    translate([0,0,snapper_d_dist])
    linear_extrude(snapper_thick)
    square([snapper_len, snapper_wid]);
}

module insertSlot2D(extra=0, dia=insert_dia) {
    translate([extra,0])
    hull() {
        circle(d=dia);
        translate([-(insert_len-insert_dia+extra),0])
        circle(d=dia);
    }
}

module catchSlot2D() {
    insertSlot2D(dia=catch_dia);
}

//insertSlot2D();

module fullPlate2D(cent=false) {
    offset(plate_rounding) offset(-plate_rounding)
    square([plate_len, plate_wid], center=cent);
}

module catchlessPlate2D() {
    offset(catch_rounding) offset(-catch_rounding)
    difference() {
        fullPlate2D();
        translate([bl_hole_h_dist, bl_hole_v_dist])
        insertSlot2D();
        translate([br_hole_h_dist, br_hole_v_dist])
        insertSlot2D(3);
        translate([t_hole_h_dist, t_hole_v_dist])
        insertSlot2D();
    }
}

//catchlessPlate2D();

module plateCatches2D() { // To be combined with catchless
    offset(catch_rounding) offset(-catch_rounding)
    difference() {
        offset(plate_rounding) offset(-plate_rounding)
        square([plate_len, plate_wid]);
        translate([bl_hole_h_dist, bl_hole_v_dist]) {
            catchSlot2D();
            circle(d=insert_dia);
        }
        translate([br_hole_h_dist, br_hole_v_dist]) {
            catchSlot2D();
            hull() {
                circle(d=insert_dia);
                translate([5,0,0])
                circle(d=insert_dia);
            }
        }
        translate([t_hole_h_dist, t_hole_v_dist]) {
            catchSlot2D();
            circle(d=insert_dia);
        }
    }
}

//#plateCatches2D();

module tabHole() {
    linear_extrude(plate_thick, convexity=6)
    square([tab_hole_len, tab_hole_wid]);
}

module plate3D(has_sticker=false) {
    difference() {
        union() {
            linear_extrude(plate_thick, convexity=6)
            catchlessPlate2D();
            linear_extrude(catch_thick, convexity=6)
            plateCatches2D();
        }
        translate([tab_hole_h_dist, tab_hole_v_dist])
        tabHole();
        translate([b_aligner_h_dist, b_aligner_v_dist])
        aligner();
        translate([t_aligner_h_dist, t_aligner_v_dist])
        aligner();
        if (has_sticker) {
            translate([0,0,plate_thick-sticker_thick])
            linear_extrude(sticker_thick)
            offset(-sticker_rim)
            fullPlate2D();
        }
    }
    translate([snapper_h_dist, snapper_v_dist])
    snapper();
}

module ledgeBrim() {
    translate([tab_hole_h_dist+0.4, tab_hole_v_dist+0.4])
    linear_extrude(0.2)
    square([tab_hole_len-0.8, tab_hole_wid-0.8]);
}

module dashcamAttachmentPlate(center=false) {
    if (center) {
        translate([-plate_len/2, -plate_wid/2]) {
            plate3D();
            ledgeBrim();
        }
    } else {
        plate3D();
        ledgeBrim();
    }
}

dashcamAttachmentPlate(true);