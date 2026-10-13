// Bike Phone Holder

$fn = 32;

grip_spacing = 0.04; // The amount of spacing to take out in grip spots
shaft_len = 97.5;
shaft_dia = 32.0-grip_spacing*2;
t_inner_dia = 25.2-grip_spacing*2;
t_outer_dia = 22.2-grip_spacing*2;
t_half_len = 80.4; // Eyeballed O.O
t_grabber_dia = 32.5;
t_grabber_len = 40.2;

phone_len = 167.25;
phone_wid = 77.4-4.0;//79.0;
phone_h = 11.2;//13.2;
phone_grabber_thick = 4.0;
phone_grabber_bottom_thick = 5.0;
phone_edge_scale = 0.8;
phone_grabber_brace_wid = 20.0;
phone_angle = 2;
phone_clips_dist = 0.0;

clips_grabber_dist = 5.0;
clip_thick = 6.8;
screw_ledge_thick = 2.0;


module shaftOutline2D() {
    translate([0,-shaft_len/2-t_grabber_dia/2])
    square([shaft_dia, shaft_len], center=true);
}
//shaftOutline2D();

module shaft() {
    rotate([90,0,0])
    cylinder(d=shaft_dia, h=shaft_len+t_grabber_dia/2);
}
//shaft();

module tArm() {
    rotate([0,90,0])
    translate([0,0,t_grabber_len/2])
    cylinder(d1=t_inner_dia, d2=t_outer_dia, h=t_half_len-t_grabber_len/2);
}
//t_arm();

module tGrabber() {
    rotate([0,90,0])
    translate([0,0,-t_grabber_len/2])
    cylinder(d=t_grabber_dia, h=t_grabber_len);
}

module t() {
    tGrabber();
    tArm();
    rotate([0,0,180])
    tArm();
    shaft();
}
//projection()
//t();

module phone() {
    rotate([phone_angle,0,0])
    minkowski() {
    translate([0,0,shaft_dia/2+clip_thick+phone_h/2+0.005])
    linear_extrude(0.01)
    translate([(t_grabber_len/2+clips_grabber_dist)/2,-(shaft_len+t_grabber_dia/2)+phone_len/2])
    rotate([0,0,90])
    square([phone_len-(phone_edge_scale*phone_h/2), phone_wid-(phone_edge_scale*phone_h/2)], center=true);
    scale([phone_edge_scale,phone_edge_scale,1])
    sphere(d=phone_h);
    }
}
//phone();

module shaftClip2D() {
    translate([0,-shaft_dia/2-t_grabber_dia/2-shaft_clip_grabber_dist])
    square([shaft_dia+2*clip_thick-grip_spacing*2, shaft_dia], center=true);
}
//#shaftClip2D();

module shaftClipUncut() {
    translate([0,-shaft_dia/2-t_grabber_dia/2-clips_grabber_dist])
    rotate([90,0,0])
    translate([0,0,-shaft_dia/2])
    cylinder(d=shaft_dia+2*clip_thick, h=shaft_dia);
}
//shaftClipUncut();

/* Removed because hulling solids and then diffing at once later seemed easier
module shaftClip() {
    difference() {
        shaftClipUncut();
        translate([0,-shaft_dia/2-t_grabber_dia/2-shaft_clip_grabber_dist, -shaft_dia/2])
        rotate([0,45,0])
        #cube(shaft_dia, center=true);
    }
}*/
//shaftClip();

module tClipUncut() {
    translate([t_inner_dia/2+t_grabber_len/2+clips_grabber_dist,0,0])
    rotate([0,90,0])
    translate([0,0,-t_inner_dia/2])
    cylinder(d=t_grabber_dia+2*clip_thick, h=t_inner_dia);
}
//tClipUncut();

module clipConnectingCurve() {
    small_fix = 0.25; // For some reason some things are off
    linear_extrude(t_grabber_dia/2+clip_thick)
    difference() {
        offset(-clips_grabber_dist) offset(clips_grabber_dist)
        offset(t_inner_dia/2-0.005)
        polygon([
            [0, -shaft_dia/2-t_grabber_dia/2-clips_grabber_dist+0.005+(t_grabber_dia-t_inner_dia)/2-small_fix],
            [t_grabber_len/2+clips_grabber_dist+t_inner_dia/2+0.005, -shaft_dia/2-t_grabber_dia/2-clips_grabber_dist+0.005+(t_grabber_dia-t_inner_dia)/2-small_fix],
            [t_grabber_len/2+clips_grabber_dist+t_inner_dia/2+0.005, 0],
            [t_grabber_len/2+clips_grabber_dist+t_inner_dia/2-0.005, 0],
            [t_grabber_len/2+clips_grabber_dist+t_inner_dia/2-0.005, -shaft_dia/2-t_grabber_dia/2-clips_grabber_dist-0.005-(t_grabber_dia-t_inner_dia)/2+small_fix],
            [0, -shaft_dia/2-t_grabber_dia/2-clips_grabber_dist-0.005-(t_grabber_dia-t_inner_dia)/2+small_fix]
        ]);
        square(t_grabber_len/2+clips_grabber_dist+t_inner_dia);
        rotate([0,0,180])
        square(shaft_dia/2+t_grabber_dia+clips_grabber_dist);
    }
}
//clipConnectingCurve();

module uncutClipInterface() {
    shaftClipUncut();
    tClipUncut();
    clipConnectingCurve();
}

m3_shaft_len = 10.0;
m3_shaft_dia = 3.0;
m3_head_dia = 5.3;
m3_head_len = 3.0+20.0;
m3_nut_h = 2.4;
m3_nut_len = 5.55;
m3_nut_hole_len = 5.0;
module m3_screw(head_len=m3_head_len) {
    translate([0,0,-m3_shaft_len])
    union() {
    translate([0,0,m3_shaft_len])
    linear_extrude(head_len)
    circle(m3_head_dia/2);
    linear_extrude(m3_shaft_len)
    circle(m3_shaft_dia/2);
    //rotate([90,-90,0])
    //translate([m3_nut_h/2,0,-m3_nut_len/2])
    //#linear_extrude(m3_nut_len)
    //square([m3_nut_h,m3_nut_len+m3_nut_hole_len],center=true);
    }
}

module screwHoles() {
    translate([0,0,screw_ledge_thick]) {
        translate([t_inner_dia/2+t_grabber_len/2+clips_grabber_dist,t_outer_dia/2+clip_thick,0])
        m3_screw();
        translate([t_inner_dia/2+t_grabber_len/2+clips_grabber_dist,-t_outer_dia/2-clip_thick,0])
        m3_screw();
        translate([shaft_dia/2+clip_thick/2,-shaft_dia/2-t_grabber_dia/2-clips_grabber_dist])
        m3_screw();
        translate([-shaft_dia/2-clip_thick/2,-shaft_dia/2-t_grabber_dia/2-clips_grabber_dist])
        m3_screw();
    }
}

module diffCube() {
    translate([0,0,-100])
    cube(200, center=true);
}

module phoneGrabberScrewHole() {
    translate([0,0,phone_grabber_bottom_thick-3+screw_ledge_thick])
    rotate([phone_angle, 0, 0])
    translate([0,0,shaft_dia/2+clip_thick+phone_h/2+0.005-phone_h/2-phone_grabber_thick])
    translate([(t_grabber_len/2+clips_grabber_dist)/2,-(shaft_len+t_grabber_dia/2)+phone_len/2])
    m3_screw();
}
//#phoneGrabberScrewHole();

module clipsUpper() {
    difference() {
        uncutClipInterface();
        t();
        diffCube();
        screwHoles();
        phone();
        phoneGrabberScrewHole();
    }
}

module shaftClipLower() {
    difference() {
        intersection() {
            shaftClipUncut();
            diffCube();
        }
        screwHoles();
        t();
    }
}

module tClipLower() {
    difference() {
        intersection() {
            tClipUncut();
            diffCube();
        }
        screwHoles();
        t();
    }
}

module phoneGrabber() {
    translate([0,0,phone_clips_dist+phone_grabber_thick])
    difference() {
        rotate([phone_angle, 0, 0])
        translate([0,0,shaft_dia/2+clip_thick+phone_h/2+0.005-phone_h/2-phone_grabber_thick])
        translate([(t_grabber_len/2+clips_grabber_dist)/2,-(shaft_len+t_grabber_dia/2)+phone_len/2]) {
            translate([0,0,phone_grabber_thick-phone_grabber_bottom_thick])
            linear_extrude(phone_h+phone_grabber_bottom_thick-0.05)
            square([phone_wid+3*phone_grabber_thick, phone_grabber_brace_wid], center=true);
            translate([0,-phone_len/4,phone_grabber_thick-phone_grabber_bottom_thick])
            difference() {
                linear_extrude(phone_h+phone_grabber_bottom_thick-0.05)
                square([phone_grabber_brace_wid*1.25, phone_len/2+3*phone_grabber_thick-10], center=true);
                translate([0,-(phone_len/2+3*phone_grabber_thick-10)/2+3])
                translate([0,0,10])
                cube([15,10,10], center=true);
            }
            translate([0,-m3_shaft_dia*2,-phone_clips_dist])
            linear_extrude(phone_clips_dist)
            square([phone_grabber_brace_wid, phone_grabber_brace_wid*1.5], center=true);
        }
        translate([0,5,0.15])
        phone();
        translate([0,0,-phone_clips_dist-phone_grabber_thick])
        phoneGrabberScrewHole();
    }
}

module viewSetup() {
    color("cyan")
    translate([0,5,0.15])
    translate([0,0,phone_clips_dist+phone_grabber_thick+1])
    phone();
    translate([0,0,-5])
    shaftClipLower();
    translate([0,0,-5])
    tClipLower();
    translate([0,0,1])
    phoneGrabber();
    color("orange")
    clipsUpper();
    color("green")
    translate([0,0,-2.5])
    t();
}
//viewSetup();

module printablePhoneGrabber() {
    rotate([-phone_angle,0,0])
    phoneGrabber();
}
printablePhoneGrabber();
//clipsUpper();
//shaftClipLower();
//tClipLower();