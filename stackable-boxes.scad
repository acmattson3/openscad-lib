// Stackable boxes for organization

$fn = 32;

box_len = 200;
box_wid = 140;
box_h = 100;
wall_thick = 1.6;
bottom_thick = 0.5;
box_lip = wall_thick;
lip_taper_len = box_lip*2;
rounding = 10.0;

module solidBox2D() {
    offset(rounding) offset(-rounding)
    square([box_len, box_wid], center=true);

}

module solidBox() {
    linear_extrude(box_h-box_lip)
    solidBox2D();
}

module boxLip() {
    linear_extrude(box_lip)
    offset(box_lip)
    solidBox2D();
}

module boxLipPeak() {
    minkowski() {
        linear_extrude(0.01)
        difference() {
            offset(box_lip/2+0.005)
            solidBox2D();
            offset(box_lip/2-0.005)
            #solidBox2D();
        }
        sphere(d=wall_thick);
        //cylinder(d1=wall_thick, d2=0.01);
    }
}

module solidBoxAndLip() {
    translate([0,0,box_h-box_lip])
    hull() {
        boxLip();
        translate([0,0,-lip_taper_len])
        linear_extrude(0.01)
        solidBox2D();
    }
    solidBox();
}

module hollowBox() {
    difference() {
        solidBoxAndLip();
        translate([0,0,bottom_thick])
        scale([(box_len-2*wall_thick)/box_len, (box_wid-2*wall_thick)/box_wid, 1.0])
        solidBoxAndLip();
        #translate([0,0,box_h-box_lip])
        solidBoxAndLip();
    }
}
//hollowBox();

module taperedSolidBox() {
    difference() {
        solidBoxAndLip();
        #translate([0,0,-box_h+box_lip+bottom_thick])
        hollowBox();
    }
}

module taperedBox() {
    difference() {
        taperedSolidBox();
        translate([0,0,bottom_thick])
        scale([(box_len-2*wall_thick)/box_len, (box_wid-2*wall_thick)/box_wid, 1.0])
        taperedSolidBox();
    }
    translate([0,0,box_h])
    boxLipPeak();
}

module smoothEdgeVaseBox() {
    difference() {
        taperedBox();
        translate([0,box_wid/2,(box_h+box_lip)/2+bottom_thick])
        #cube([0.1,box_wid, box_h+box_lip],center=true);
    }
}
smoothEdgeVaseBox();