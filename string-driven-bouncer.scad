// String driven bouncer for example chair

$fn = 64;

upper_rod_d = 21.0;
lower_rod_d = 13.0;

oscillation_dist = 28.0; // How far does it bounce between high/low?
string_hole_offset = oscillation_dist/2;
string_hole_d = 4;
oscillator_wid = 5;

upper_hook_thick = 4;
upper_hook_h = upper_rod_d * 2;
upper_hook_wid = 10.0;
upper_hook_extention = 4;

wall_thick = 3;

module upperHook() {
    difference() {
        linear_extrude(upper_hook_wid)
        offset(upper_hook_thick/2-0.1)
        offset(-upper_hook_thick/2+0.1)
        difference() {
            offset(upper_hook_thick)
            hull() {
                circle(d=upper_rod_d);
                translate([0,upper_hook_wid])
                square(upper_rod_d, center=true);
            }
            hull() {
                circle(d=upper_rod_d);
                translate([0,upper_hook_wid])
                square(upper_rod_d, center=true);
            }
            translate([-upper_rod_d/2,upper_hook_extention])
            square(100);
        }
        
        translate([-upper_rod_d/2-upper_hook_thick,upper_hook_h/2-upper_hook_thick,upper_hook_wid/2])
        rotate([0,90,0])
        cylinder(d=string_hole_d, h=upper_hook_thick);
    }
}
//upperHook();


motor_shaft_d = 3;
motor_key_len = 2.4;
module motorKey() {
    rotate([0,0,-90])
    intersection() {
        circle(d=motor_shaft_d);
        translate([0,(motor_shaft_d-motor_key_len)/2])
        square([motor_shaft_d, motor_key_len], center=true);
    }
    translate([-0.9,1.2])
    circle(d=0.6);
    translate([-0.9,-1.2])
    circle(d=0.6);
}
//motorKey();

// Thing that attaches to motor shaft with offset hole
module oscillator() {
    linear_extrude(oscillator_wid)
    difference() {
        offset(wall_thick)
        hull() {
            motorKey();
            translate([string_hole_offset,0,0])
            circle(d=string_hole_d);
        }
        motorKey();
        translate([string_hole_offset,0,0])
        circle(d=string_hole_d);
    }
}
//oscillator();

motor_h = 10.0;
motor_d = 12.0;
gearbox_wid = motor_d;
gearbox_h = motor_h;

module motorOutline() {
    intersection() {
        circle(d=motor_d);
        square([motor_d, motor_h], center=true);
    }
}
//motorOutline();

lower_mount_thick = 2.0;
lower_mount_wid = 10.0;
module lowerGrabber(do_cuts=true) {
    translate([-lower_mount_wid/2,0,0])
    rotate([180,-90,0])
    difference() {
        linear_extrude(lower_mount_wid)
        offset(lower_mount_thick/2-0.1)
        offset(-lower_mount_thick/2+0.1)
        difference() {
            circle(d=lower_rod_d + 2*lower_mount_thick);
            if (do_cuts) {
                circle(d=lower_rod_d);
                translate([-lower_rod_d-lower_mount_thick,0])
                square(lower_rod_d+2*lower_mount_thick, center=true);
            }
        }
    }
}
//lowerGrabber();

module lowerGrabberCutout() {
    difference() {
        lowerGrabber(false);
        lowerGrabber();
    }
}
//lowerGrabberCutout();

module motorSlotCutout() {
    //linear_extrude()
}

module motorSlot() {
    
}

// Attaches motor (w/ oscillator) to bottom rod of chair
module motorMount() {
    difference() {
        hull() {
            motorSlot();
            lowerGrabber();
        }
        lowerGrabberCutout();
        motorSlotCutout();
    }
}

//motorMount();