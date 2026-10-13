// Toolbox snapping handle

$fn=64;

// With handle on its side
// Handle is main body (part you grab)
// Clipper is rotating piece that attaches handle to box
// Also refers to where clipper piece attaches to handle
// Pivot is where clipper attaches to box
handle_h = 110.8;
handle_wid = 56.85;
handle_len = 10.6;
handle_lip_len = 8.1;
handle_lip_thick = 3.1;
handle_clip_len = 3.1;
handle_clip_thick = 1.6;
num_clips = 3;
clip_indiv_range = 94.7;
clip_indiv_h = 14.85;

clipper_h = 93.0;
clipper_wid = 25.0;
clipper_indiv_h = 2.8;
clipper_indiv_range = 72.6;
num_clippers = 6;
clipper_rod_dia = 3.85;
clipper_rod_wall_thick = 2.7;
clipper_len = clipper_rod_dia;

pivot_rod_dia = 4.05;
pivot_rod_wall_thick = 2.0;//2.55;
num_pivots = 7;
pivot_indiv_h = 9.4;
pivot_indiv_range = 92.85;
pivot_rect_len = clipper_rod_dia;
pivot_rect_rod_dist = 18.1-clipper_rod_dia/2;

spacing = 0.2;
//rod_v_spacing = 0.2;

// Distance from clipper rod center to handle butt
handle_butt_clipper_dist = 17.05;

handle_butt_dia = clipper_rod_dia+2*clipper_rod_wall_thick;

module clip(rod_dia, wall_thick, has_cutout=true) {
    rotate([0,0,-45])
    offset(wall_thick/2)
    difference() {
        circle(d=rod_dia+wall_thick+0.005);
        if (has_cutout) {
            circle(d=rod_dia+wall_thick-0.01);
            square(rod_dia+wall_thick);
        }
    }
    
}
//clip(pivot_rod_dia, pivot_rod_wall_thick);

module invert_clip(rod_dia, wall_thick) {
    difference() {
        offset(0.01)
        circle(d=rod_dia+2*wall_thick);
        offset(0.01)
        clip(rod_dia, wall_thick);
    }
}

module handle_meat() {
    linear_extrude(handle_h)
    difference() {
        hull() {
            scale([(handle_len*2)/handle_wid,1])
            circle(d=handle_wid);
            translate([0,-handle_wid/2+handle_butt_dia/2])
            circle(d=handle_butt_dia);
        }
        translate([handle_len/2,0])
        square([handle_len, handle_wid], center=true);
    }
}

module clipper() {
    translate([clipper_rod_dia/2,0,0])
    linear_extrude(clipper_indiv_h)
    difference() {
        hull() {
            translate([-(clipper_rod_wall_thick*2+clipper_rod_dia)/2,0,0])
            square([0.01, 2*(clipper_rod_wall_thick*2+clipper_rod_dia)], center=true);
            clip(clipper_rod_dia+2*spacing, clipper_rod_wall_thick, false);
            //difference() {
            //    circle(d=clipper_rod_dia+2*clipper_rod_wall_thick);
            //    circle(d=clipper_rod_dia+2*spacing);
            //}
        }
        invert_clip(clipper_rod_dia+2*spacing, clipper_rod_wall_thick);
    }
}

module clipper_set() {
    clipper_range_actual = clipper_indiv_range - clipper_indiv_h;
    for (i=[0:num_clippers-1]) {
        translate([0,0,i*(clipper_range_actual/(num_clippers-1))])
        clipper();
    }
}

module clipper_rod_end() {
    translate([clipper_rod_dia/2,0,0])
    difference() {
        linear_extrude(clipper_indiv_h)
        hull() {
            translate([-(clipper_rod_wall_thick*2+clipper_rod_dia)/2,0,0])
            square([0.01, 2*(clipper_rod_wall_thick*2+clipper_rod_dia)], center=true);
            clip(clipper_rod_dia+2*spacing, clipper_rod_wall_thick, false);
        }
        translate([0,0,clipper_indiv_h/4])
        linear_extrude((3*clipper_indiv_h)/4)
        circle(d=clipper_rod_dia+2*spacing);
    }
}

module handle_clip() {
    linear_extrude(clip_indiv_h)
    polygon([
        [0, 0],
        [handle_clip_thick, -handle_clip_len],
        [handle_clip_thick, 0]
    ]);
}

module handle_final() {
    // Handle Body (with clipper attachments)
    handle_meat();
    translate([spacing,handle_butt_clipper_dist-handle_wid/2,0]) {
        translate([0, 0, (handle_h-clipper_indiv_range)/2])
        clipper_set();
        clipper_rod_end();
        translate([0,0,handle_h])
        rotate([180,0,0])
        clipper_rod_end();
    }
    
    // Handle Lip
    linear_extrude(handle_h)
    translate([handle_lip_len/2,handle_wid/2-handle_lip_thick/2])
    square([handle_lip_len,handle_lip_thick],center=true);
    
    // Handle Clips
    clip_range_actual = clip_indiv_range-clip_indiv_h;
    translate([handle_lip_len-handle_clip_thick,handle_h/4+handle_lip_thick/4-handle_lip_thick,(handle_h-clip_indiv_range)/2])
    for (i=[0:num_clips-1]) {
        translate([0,0,i*(clip_range_actual/(num_clips-1))])
        handle_clip();
    }
}

module pivot() {
    linear_extrude(pivot_indiv_h) {
        translate([pivot_rect_rod_dist/2,0])
        square([pivot_rect_rod_dist, pivot_rect_len],center=true);
        translate([pivot_rect_rod_dist+pivot_rod_dia/2+pivot_rod_wall_thick/2,0])
        rotate([0,0,-90])
        clip(pivot_rod_dia, pivot_rod_wall_thick);
    }
}

module clipper_final() {
    pivot_range_actual = pivot_indiv_range-pivot_indiv_h;
    linear_extrude(handle_h-clipper_indiv_h/2-2*spacing)
    circle(d=clipper_rod_dia);
    
    translate([0,0,((handle_h-clipper_indiv_h/2-2*spacing)-pivot_indiv_range)/2])
    for (i=[0:num_pivots-1]) {
        translate([0,0,i*(pivot_range_actual/(num_pivots-1))])
        pivot();
    }
}

//clipper_final();
difference() {
union() {
handle_final();
translate([spacing+clipper_rod_dia/2,handle_butt_clipper_dist-handle_wid/2,clipper_indiv_h/4+spacing])
clipper_final();

linear_extrude(handle_h)
translate([0,-handle_wid/2+handle_butt_dia/2]) {
    circle(d=handle_butt_dia);
    translate([handle_butt_dia/2,0,0])
    polygon([
        [-handle_butt_dia/2, 0],
        [-handle_butt_dia/2, handle_butt_dia],
        [0, 0]
    ]);
}
}
//translate([0,0,50+20])
//cube(100, center=true);
}