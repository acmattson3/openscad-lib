// Robot cam-car chassis
$fn = 48;

battery_wid = 67.0;
battery_len = 112.0;
battery_h = 13.5;

chassis_len = 124.0+18.5;
chassis_h = 40.0;
chassis_thick = 2.0;//1.2;
chassis_rounding = chassis_thick;
chassis_wid = 87.0;//battery_wid+chassis_thick*2;
chassis_butt_rad = 5.0;

chassis_lid_thick = 4.0;
chassis_spacing = 0.5;
webcam_notch_offset = -20.0;
power_notch_offset = -20.0;

charge_notch_offset_h = 25.0;
charge_notch_offset_v = 0.0;

// New cylindrical motor gearbox
gearbox_dia = 16.3;
gearbox_h = 14.1;
gearbox_hole_dia = 7.15;
gearbox_hole_h = 2.0;
gearbox_cover_thick = chassis_thick;
// Existing Dimensions
spacing = 0.15;
motor_h = 11.8+spacing;//10.0+spacing;
motor_wid = 15.3+spacing;//12.0+spacing;
motor_len = 18.9;//16.0;
motor_screw_dist = 28.0;//22.5;
motor_screw_dia = 2.5;
motor_screw_len = 7.0;

battery_stilt_dist = 10.0;
battery_stilt_thick = 1.2;

led_dia = 5.3;
led_h = 7.5;
headlight_offset = 20.0;
num_headlights = 2;
headlight_wall_dist = 25.0;

wheel_offset = -chassis_len/5;
wheel_dia = 42.5;
robot_axle_z = wheel_dia/2;
robot_axle_x = chassis_len-wheel_offset;
robot_tilt_angle = atan(robot_axle_z/robot_axle_x)/1.5;

module motorGearbox() {
    linear_extrude(gearbox_h, convexity=6)
    circle(d=gearbox_dia);
    translate([0,0,gearbox_h])
    linear_extrude(gearbox_hole_h)
    circle(d=gearbox_hole_dia);
}

module motorCapHoles2D() {
    translate([motor_screw_dist/2, 0, 0])
    circle(d=motor_screw_dia);
    translate([-motor_screw_dist/2, 0, 0])
    circle(d=motor_screw_dia);
}

module motorCapOutline() {
    linear_extrude(gearbox_cover_thick, convexity=6)
    difference() {
        hull() {
            offset(gearbox_cover_thick*1.5)
            motorCapHoles2D();
            //linear_extrude(gearbox_cover_thick)
            circle(d=gearbox_dia+2*gearbox_cover_thick);
        }
        motorCapHoles2D();
    }
}

module motorCap() {
    difference() {
        union() {
            linear_extrude(gearbox_h+gearbox_cover_thick)
            circle(d=gearbox_dia+2*gearbox_cover_thick);
            motorCapOutline();
        }
        motorGearbox();
    }
}

module diffedMotorCap() {
    difference() {
        motorCap();
        translate([-25,gearbox_dia/2,0])
        #cube(50);
    }
}

module chassisInsideCutout(extra=0.0) {
    translate([0,0,chassis_thick])
    linear_extrude(chassis_h-chassis_thick, convexity=6)
    square([chassis_len-2*chassis_thick-extra, chassis_wid-2*chassis_thick-extra], center=true);
}

module chassisSolidButtless() {
    linear_extrude(chassis_h, convexity=6)
    offset(chassis_rounding) offset(-chassis_rounding)
    square([chassis_len, chassis_wid], center=true);
}

module chassisButt() {
    translate([chassis_len/2,(chassis_wid-4*chassis_rounding)/2,chassis_butt_rad])
    rotate([90,0,0])
    cylinder(r=chassis_butt_rad, h=chassis_wid-4*chassis_rounding);
}

module chassisSolid() {
    hull() {
        chassisSolidButtless();
        chassisButt();
        
    }
}

module emptyChassis(extra=0.0) {
    difference() {
        chassisSolid();
        chassisInsideCutout(extra);
    }
}

module motor() {
    rotate([0,0,90])
    translate([-motor_len/2,0,motor_h/2])
    rotate([0,90,0])
    linear_extrude(motor_len, convexity=6)
    intersection() {
    circle(d=motor_wid);
    square([motor_h, motor_wid*2], center=true);
    }
}

module motorScrews() {
    translate([motor_screw_dist/2, motor_len/2, motor_h/2])
    rotate([90,0,0])
    cylinder(d=motor_screw_dia, h=motor_len);
    translate([-motor_screw_dist/2, motor_len/2, motor_h/2])
    rotate([90,0,0])
    cylinder(d=motor_screw_dia, h=motor_len);
}

module motorAndScrews() {
    motor();
    motorScrews();
}

module uprightMotorAndScrews2D() {
    rotate([0,0,90]) {
        intersection() {
            circle(d=motor_wid);
            square([motor_h, motor_wid*2], center=true);
        }
        // screws
        translate([0, motor_screw_dist/2])
        circle(d=motor_screw_dia);
        translate([0, -motor_screw_dist/2])
        circle(d=motor_screw_dia);
    }
}
uprightMotorAndScrews2D();

module motorHoles() {
    translate([wheel_offset,chassis_wid/2-motor_len/4,chassis_thick])
    motorAndScrews();
    translate([wheel_offset,-(chassis_wid/2-motor_len/4),chassis_thick])
    motorAndScrews();
}

module batteryStilt() {
    translate([0,0,chassis_h-battery_h+chassis_thick])
    rotate([-90,0,90])
    linear_extrude(battery_stilt_thick, convexity=6)
    polygon([[0,0], [battery_stilt_dist, 0], [0, battery_stilt_dist]]);
    //cube([1,10,chassis_h-battery_h], center=true);
}

module batteryStilts() {
    translate([chassis_len/4,-chassis_wid/2, 0])
    batteryStilt();
    translate([-chassis_len/4,-chassis_wid/2, 0])
    batteryStilt();
    rotate([0,0,180]) {
    translate([chassis_len/4,-chassis_wid/2, 0])
    batteryStilt();
    translate([-chassis_len/4,-chassis_wid/2, 0])
    batteryStilt();
    }
}

module headlightLed() {
    translate([-chassis_len/2-led_h/2, 0, led_dia/2+headlight_offset])
    rotate([0,90-robot_tilt_angle,0])
    cylinder(d=led_dia, h=led_h);
}

module headlightHoles() {
    translate([0,-(chassis_wid-2*headlight_wall_dist)*(1-(1/num_headlights))/2,0])
    for (i=[0:num_headlights-1]) {
        div_part = (chassis_wid-(headlight_wall_dist*2)) / num_headlights;
        translate([0, i*div_part, 0])
        headlightLed();
    }
}

cable_dia = 4.0;
module cableSlot() {
    rotate([90,0,0]) {
        cylinder(d=cable_dia, h=chassis_thick*3);
        translate([0,cable_dia/4,chassis_thick])
        cube([cable_dia,cable_dia/2,chassis_thick*3], center=true);
    }
}

module completeChassis() {
    difference() {
        emptyChassis();
        motorHoles();
        #headlightHoles();
        translate([webcam_notch_offset,-chassis_wid/2+chassis_thick*1.5,chassis_h-chassis_thick/1.3])
        #cableSlot(); // Webcam
        translate([chassis_len/2-chassis_thick*1.5,power_notch_offset,chassis_h-chassis_thick/1.3])
        rotate([0,0,90])
        #cableSlot(); // Power
        translate([-chassis_len/2, charge_notch_offset_h, charge_notch_offset_v+chassis_thick+cable_dia/2])
        rotate([0,0,90])
        #cableSlot();
        translate([-chassis_len/2, -charge_notch_offset_h, charge_notch_offset_v+chassis_thick+cable_dia/2])
        rotate([0,0,90])
        #cableSlot();
    }
    //translate([chassis_len-battery_len, 0, 0])
    //batteryStilts();
}

module chassisLid() {
    difference() {
        translate([0,0,chassis_h-chassis_lid_thick/2.0])
        linear_extrude(chassis_lid_thick, convexity=6)
        offset(chassis_rounding) offset(-chassis_rounding) 
        square([chassis_len, chassis_wid], center=true);
        emptyChassis(extra=chassis_spacing);
        translate([webcam_notch_offset,-chassis_wid/2+chassis_thick*3,chassis_h-chassis_thick/1.25])
        scale([1,2,1])
        #cableSlot(); // Webcam
        translate([chassis_len/2-chassis_thick*3,power_notch_offset,chassis_h-chassis_thick/1.25])
        scale([2,1,1])
        rotate([0,0,90])
        #cableSlot(); // Power
    }
}

//motorAndScrews();
//completeChassis();
//    translate([0,0,10])
//chassisLid();
