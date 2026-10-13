// Bike kickstand clip

//$fn=64;

include <dashcam_attachment_plate.scad>

stand_dia = plate_len-10.0;//9.2+0.25;
rod_rect_dia = 19.08;
rod_vert_dia = 19.08;//27.3+0.25;
rod_stand_dist = 30.0+25.0;
clip_len = 20.0;
clip_thick = 7.0;

light_rounding = 2.0;
cutouts = 4.0;



module stand_2d() {
    //circle(d=stand_dia);
    //square([0.01, stand_dia], center=true);
    
    //amount = plate_len-clip_thick+cutouts;
    //to_scale = plate_len/amount;
    
    //translate([-2,0,0])
    rotate([0,0,90])
    offset(-clip_thick)
    //scale([1,1.1,1])
    translate([0,-cutouts,0])
    fullPlate2D(true);
}

module rod_2d() {
    hull() {
        circle(d=rod_rect_dia);
        translate([rod_vert_dia-rod_rect_dia,0])
        circle(d=rod_rect_dia);
    }
}

module rod_stand_holes_2d() {
    stand_2d();
    translate([rod_rect_dia/2+stand_dia/2+rod_stand_dist,0])
    rod_2d();
}

module rod_stand_holes_3d() {
    linear_extrude(clip_len)
    rod_stand_holes_2d();
}

module holes_hulled() {
    hull() {
        offset(clip_thick)
        difference() {
        stand_2d();
        translate([-rod_rect_dia/2,0])
        square([rod_rect_dia,rod_rect_dia],center=true);
        }
        translate([rod_rect_dia/2+stand_dia/2+rod_stand_dist,0])
        offset(clip_thick)
        rod_2d();
    }
}

module holes_diffed() {
    difference() {
        holes_hulled();
        rod_stand_holes_2d();
    }
}

module holes_diffed_lighter() {
    difference() {
        holes_diffed();
        offset(light_rounding) offset(-light_rounding)
        offset(-cutouts) holes_diffed();
    }
}

module kickstand_clip_solid() {
    difference() {
        linear_extrude(clip_len, convexity=6)
        holes_diffed_lighter();
        //linear_extrude(clip_len)
        //translate([-rod_rect_dia/4,0])
        //square([rod_rect_dia/2+0.75,rod_rect_dia/2+0.75],center=true);
    }
}

//kickstand_clip_solid();

m3_shaft_len = 10.0;
m3_shaft_dia = 3.0;
m3_head_dia = 5.3;
m3_head_len = 3.0+10.0;
m3_nut_h = 2.4;
m3_nut_len = 5.55;
module m3_screw() {
    translate([0,0,-m3_shaft_len])
    union() {
    translate([0,0,m3_shaft_len])
    linear_extrude(m3_head_len)
    circle(m3_head_dia/2);
    linear_extrude(m3_shaft_len)
    circle(m3_shaft_dia/2);
    rotate([90,-90,0])
    translate([m3_nut_h/2,0,-m3_nut_len/2])
    #linear_extrude(clip_len/3)
    square([m3_nut_h,m3_nut_len],center=true);
    }
}

//m3_screw();

module m3_screw_holes() {
    translate([rod_rect_dia+stand_dia+rod_stand_dist,0,0]) {
    translate([0,rod_rect_dia/2+clip_thick/2,clip_len/6])
    rotate([0,-90,180])
    m3_screw();
    translate([0,-rod_rect_dia/2-clip_thick/2,clip_len/6])
    rotate([0,90,0])
    m3_screw();
    translate([0,rod_rect_dia/2+clip_thick/2,5*clip_len/6])
    rotate([0,-90,180])
    m3_screw();
    translate([0,-rod_rect_dia/2-clip_thick/2,5*clip_len/6])
    rotate([0,90,0])
    m3_screw();
    }
}

module kickstand_clip() {
    difference() {
    kickstand_clip_solid();
    translate([-20,0,0])
    #m3_screw_holes();
    }
}

module separated_kickstand_clip() {
    difference() {
        kickstand_clip();
        translate([stand_dia/2+rod_stand_dist+rod_vert_dia/2,-50,0])
        cube([100,100,100]);
    }
    translate([15,0,0])
    intersection() {
        kickstand_clip();
        translate([stand_dia/2+rod_stand_dist+rod_vert_dia/2,-50,0])
        cube([100,100,100]);
    }
}

difference() {
    rotate([0,0,90])
    separated_kickstand_clip();
    linear_extrude(plate_thick)
    fullPlate2D(true);
    rotate([13.6,0,0])
    translate([0,0,100+clip_len-15.5])
    cube(200, center=true);
}

dashcamAttachmentPlate(true);
