// BenJr New Chassis

$fn = 48;

rod_dist = 76.25;
rod_d = 4.3;
motor_h = 10.0;
motor_wid = 12.0;
motor_hole_d = 2.5;
motor_hole_dist = 22.4;
chassis_h = 30.0;
chassis_len = 70.0;
chassis_wid = 67.0;
wall_thick = 2.0;
rounding = 3.0;

module motor2D() {
    intersection() {
        square([motor_wid, motor_h], center=true);
        circle(d=motor_wid);
    }
}
//motor2D();

module motorHole2D() {
    circle(d=motor_hole_d);
}

module motorHoles2D() {
    translate([motor_hole_dist/2, 0])
    motorHole2D();
    translate([-motor_hole_dist/2, 0])
    motorHole2D();
}

module rodHole2D() {
    circle(d=rod_d);
}

module rodHoles2D() {
    translate([rod_dist/2, 0])
    rodHole2D();
    translate([-rod_dist/2, 0])
    rodHole2D();
}
//rodHoles2D();

module chassisOutline2D(addon_h=0.0) {
    offset(r=wall_thick)
    hull() {
        translate([0,chassis_h/2])
        square([chassis_len+2*wall_thick, chassis_h+addon_h], center=true);
        rodHoles2D();
        motor2D();
    }
}

module chassisWall2D() {
    difference() {
        chassisOutline2D();
        rodHoles2D();
        motor2D();
        motorHoles2D();
    }
}
//chassisWall2D();

module chassisMid2D() {
    difference() {
        offset(-rounding) offset(rounding)
        union() {
            difference() {
                chassisOutline2D();
                offset(-wall_thick) {
                    chassisOutline2D();
                    #chassisOutline2D(addon_h=2*wall_thick);
                }
            }
            offset(wall_thick)
            rodHoles2D();
            //motor2D();
            //motorHoles2D();
        }
        rodHoles2D();
    }
}
//chassisMid2D();

module chassis() {
    linear_extrude(wall_thick)
    chassisWall2D();
    translate([0,0,wall_thick])
    linear_extrude(chassis_wid)
    chassisMid2D();
}
chassis();
color("red")
translate([0,0,wall_thick+chassis_wid])
linear_extrude(wall_thick)
chassisWall2D();