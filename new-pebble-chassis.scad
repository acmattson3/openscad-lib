// New Pebble Chassis

use <pebble-chassis.scad>;

$fn = 32;

chassis_len = 142.5;
chassis_h = 120.0;
chassis_wid = 95.0;
chassis_rounding = 10.0;
wall_thick = 0.4*5;
vert_scale = chassis_h/chassis_len;
top_p = 14;
middle_p = 10;
bottom_p = 6;
p_sum = top_p+middle_p+bottom_p;

//webcam_catch_len = 102.4-10.0; // The space the two lips span while extended
webcam_hole_wid = 94.0;
webcam_hole_h = 35.0;
webcam_collapsed_slit_h = 1.0;
webcam_collapsed_slit_len = 50.0;

// Distance from the wheel axle's center to the front
wheel_front_dist = chassis_len/5;
motor_h = 11.8+0.15;

module chassisSide2D() {
    offset(chassis_rounding) offset(-chassis_rounding)
    scale([1,vert_scale])
    intersection() {
        circle(r=chassis_len, $fn=64);
        square(chassis_len);
    }
}
//chassisSide2D();

module chassisCutout2D() {
    offset(-wall_thick)
    chassisSide2D();
}
//chassisCutout2D();

module chassisCutSide2D() {
    difference() {
        chassisSide2D();
        chassisCutout2D();
    }
}

module solidFullChassis() {
    linear_extrude(chassis_wid)
    chassisSide2D();
}
//solidFullChassis();

module fullChassisCutout() {
    translate([0,0,wall_thick])
    linear_extrude(chassis_wid)
    chassisCutout2D();
}

module chassisBottom2D() {
    intersection() {
        chassisSide2D();
        square([chassis_len, (chassis_h*bottom_p)/p_sum]);
    }
}

module chassisBottomCut2D() {
    difference() {
        chassisBottom2D();
        chassisCutout2D();
    }
}

module chassisMiddle2D() {
    intersection() {
        chassisSide2D();
        translate([0, (chassis_h*bottom_p)/p_sum])
        square([chassis_len, (chassis_h*middle_p)/p_sum]);
    }
}

module chassisMiddleCutout2D() {
    intersection() {
        chassisCutout2D();
        translate([0, (chassis_h*bottom_p)/p_sum+wall_thick])
        square([chassis_len, (chassis_h*middle_p)/p_sum-wall_thick]);
    }
}

module chassisMiddleCut2D() {
    difference() {
        chassisMiddle2D();
        chassisMiddleCutout2D();
        translate([wall_thick, (chassis_h*bottom_p)/p_sum])
        square([50, wall_thick]);
    }
}
//chassisMiddleCut2D();

module chassisTop2D() {
    intersection() {
        chassisSide2D();
        translate([0, (chassis_h*(bottom_p+middle_p))/p_sum])
        square([chassis_len, (chassis_h*top_p)/p_sum]);
    }
}

module chassisTopCutout2D() {
    offset(-wall_thick)
    chassisTop2D();
}

module chassisTopCut2D() {
    difference() {
        chassisTop2D();
        chassisTopCutout2D();
        translate([wall_thick,(chassis_h*(bottom_p+middle_p))/p_sum])
        square([webcam_collapsed_slit_len, wall_thick-webcam_collapsed_slit_h]);
        translate([wall_thick+webcam_collapsed_slit_len,(chassis_h*(bottom_p+middle_p))/p_sum])
        square([60, wall_thick]);
    }
}

module testChassisOutline() {
    linear_extrude(5) {
        union() {
        chassisTopCut2D();
        chassisMiddleCut2D();
        chassisBottomCut2D();
        }
    }
}
//testChassisOutline();

module chassisOuterWalls() {
    linear_extrude(chassis_wid) {
        union() {
            chassisTopCut2D();
            chassisMiddleCut2D();
            chassisBottomCut2D();
        }
    }
}
//chassisOuterWalls();

module chassisCutOuterWalls() {
    difference() {
        chassisOuterWalls();
        // Webcam cutout
        translate([-wall_thick/2,wall_thick+(chassis_h*(bottom_p+middle_p))/p_sum,-0.01])
        cube([wall_thick*2, webcam_hole_h, chassis_wid+0.02]);
    }
}
//chassisCutOuterWalls();

// Left from Pebble's perspective
module chassisCutSideWall() {
    linear_extrude(wall_thick, convexity=6) {
        difference() {
            chassisSide2D();
            translate([wheel_front_dist, motor_h/2+wall_thick])
            uprightMotorAndScrews2D();
        }
    }
}
//chassisCutSideWall();

ledge_size = 12.0;
module screwHoleLedge() {
    hull() {
        translate([0,0,ledge_size])
        linear_extrude(ledge_size)
        intersection() {
        circle(r=ledge_size);
        square(ledge_size);
        }
        cube(0.01);
    }
}
//screwHoleLedge();

module fitIntoChassis() {
    intersection() {
        children();
        fullChassisCutout();
    }
}

screw_dia = 3.35;
screw_head_dia = 6.5;
screw_head_h = 2.6;
screw_len = 9.7;
module screwHole() {
    translate([0,0,-screw_len-screw_head_h])
    cylinder(d=screw_dia, h=screw_len);
    translate([0,0,-screw_head_h])
    cylinder(d1=screw_dia, d2=screw_head_dia, h=screw_head_h);
}
//screwHole();

module screwHoles() {
    translate([ledge_size/2+wall_thick,ledge_size/2+wall_thick,2*wall_thick+chassis_wid])
    #screwHole();
    translate([chassis_len-ledge_size/2-wall_thick,ledge_size/2+wall_thick,2*wall_thick+chassis_wid])
    #screwHole();
    translate([ledge_size/2+wall_thick,chassis_h-ledge_size/2-wall_thick,2*wall_thick+chassis_wid])
    #screwHole();
}

module fullNewChassis() {
    chassisCutSideWall();
    translate([0,0,wall_thick])
    chassisCutOuterWalls();
    fitIntoChassis() {
        translate([wall_thick, wall_thick, wall_thick+chassis_wid-2*ledge_size])
        screwHoleLedge();
        translate([-wall_thick+chassis_len, wall_thick, wall_thick+chassis_wid-2*ledge_size])
        rotate([0,0,90])
        screwHoleLedge();
        translate([wall_thick,-wall_thick+chassis_h, wall_thick+chassis_wid-2*ledge_size])
        rotate([0,0,-90])
        screwHoleLedge();
    }
    //translate([0,0,wall_thick+chassis_wid])
    //chassisCutSideWall();
}

led_dia = 5.3;
led_h = 7.5;
headlight_angle = 15;
module newHeadlightHole() {
    rotate([0,0,headlight_angle])
    rotate([0,90,0])
    translate([0,0,-led_h/2])
    cylinder(d=led_dia, h=led_h);
}
//newHeadlightHole();

headlight_h = 50.0;
headlight_dist = 30.0;
module newHeadlightHoles() {
    translate([wall_thick/2,headlight_h,wall_thick]) {
        translate([0,0,chassis_wid/2+headlight_dist/2])
        newHeadlightHole();
        translate([0,0,chassis_wid/2-headlight_dist/2])
        newHeadlightHole();
    }
}
//newHeadlightHoles();

charge_hole_h = 20.0;
charge_hole_dist = 60.0;
module chargeHoles() {
    translate([wall_thick/2,charge_hole_h,wall_thick]) {
        translate([0,0,chassis_wid/2+charge_hole_dist/2])
        newHeadlightHole();
        translate([0,0,chassis_wid/2-charge_hole_dist/2])
        newHeadlightHole();
    }
}

module cutFullNewChassis() {
    difference() {
        fullNewChassis();
        screwHoles();
        headlightHoles();
        chargeHoles();
        newHeadlightHoles();
    }
}

module cutSidePlate() {
    difference() {
        translate([0,0,wall_thick+chassis_wid])
        chassisCutSideWall();
        screwHoles();
    }
}

rotate([90,5,0]) {
    cutFullNewChassis();
    translate([0,100,50])
    cutSidePlate();
}
