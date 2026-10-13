$fn = 64;

nozzle_d = 0.4; // 3D Printer nozzle diameter

ring_inner_d = 80;
//disc_d = 70;
gear_ratio = 10;
disc_d = (-ring_inner_d*(1-gear_ratio))/gear_ratio;
//echo(disc_d);
//gear_ratio = ring_inner_d/(ring_inner_d-disc_d); // to one; also oscillation num
assert(floor(gear_ratio) == gear_ratio);
//echo("Gear ratio: ", gear_ratio, " : 1");

shaft_bearing_inner_d = 30.0;
shaft_bearing_outer_d = 37.0;
shaft_bearing_thick = shaft_bearing_outer_d - shaft_bearing_inner_d;
shaft_d = shaft_bearing_outer_d;

drive_h = 4.0+0.2;//10.0;
spacing = 0.2;

num_outer_rods = gear_ratio; // Cool!
outer_rod_d = 12;
ring_outer_d = 92;

disc_offset = (ring_inner_d-disc_d)/2;

num_inner_rods = 0;
inner_rod_slot_d = 2*(disc_d-shaft_d)/7;
inner_rod_offset = -3;
inner_rod_rotate_offset = 360/num_inner_rods/2;
inner_rod_d = inner_rod_slot_d-(ring_inner_d-disc_d);
center_bearing_outer_d = 22.0+0.03;
center_bearing_inner_d = 8.0-0.03;
center_bearing_h = 7.0+0.2;
center_rod_d = center_bearing_inner_d;//disc_d+shaft_d-ring_inner_d;
center_rod_h = center_bearing_h*3;

ring_plate_thick = center_bearing_h/2;


//echo(inner_rod_d);

assert(shaft_bearing_inner_d-disc_offset*2 < center_bearing_outer_d);
assert(shaft_d > 2*nozzle_d);
assert(inner_rod_d > 2*nozzle_d);
assert(disc_d > shaft_d+nozzle_d);
assert(center_rod_d > 2*nozzle_d);
//echo(center_rod_d);

module ring2D() {
    difference() {
        offset(spacing) // bc offset occurs later w/ spacing
        circle(d=ring_outer_d);
        circle(d=ring_inner_d);
    }
}

module innerRods2D() {
    for (i=[0:num_inner_rods-1]) {
        rotate([0,0,360*i/num_inner_rods + inner_rod_rotate_offset])
        translate([0,(disc_d+shaft_d)/4+inner_rod_offset])
        #circle(d=inner_rod_d);
    }
}

tooth_rounding = 2;
module outerRod2D() {
    translate([0,ring_inner_d/2])
    intersection() {
        circle(d=outer_rod_d);
        translate([0,-outer_rod_d/4])
        square([outer_rod_d, outer_rod_d/2], center=true);
    }
    //rotate([0,0,0])
    //offset(tooth_rounding) offset(-tooth_rounding)
    //square([outer_rod_d/2, outer_rod_d], center=true);
}

module outerRods2D() {
    for (i=[0:num_outer_rods-1]) {
        rotate([0,0,360*i/num_outer_rods])
        outerRod2D();
    }
}

module disc2D() {
    difference() {
        circle(d=disc_d);
        
        for(i=[0:num_inner_rods-1]) {
            rotate([0,0,360*i/num_inner_rods + inner_rod_rotate_offset])
            translate([0,shaft_d/2+(disc_d-shaft_d)/4+inner_rod_offset])
            circle(d=inner_rod_slot_d);
        }
        circle(d=shaft_d);
    }
}

// One chain-hulled sweep of ONE rod (the "top" rod) over one oscillation
module fullRodSweep2D(steps=256) {
    for (i=[0:steps-1]) {
        step_float = i/steps;
        theta = 360 * (ring_inner_d/(ring_inner_d-disc_d)-1) * step_float;
        spin  = -theta * ring_inner_d / disc_d;
        
        next_step_float = (i+1)/steps;
        next_theta = 360 * (ring_inner_d/(ring_inner_d-disc_d)-1) * next_step_float;
        next_spin = -next_theta * ring_inner_d / disc_d;

        // Ring + outer pins move by the inverse of the disc motion
        hull() {
            rotate([0,0,-spin])
            translate([0,-disc_offset])
            rotate([0,0,-theta]) 
            outerRod2D();
            rotate([0,0,-next_spin])
            translate([0,-disc_offset])
            rotate([0,0,-next_theta]) 
            outerRod2D();
        }
    }
}
//fullRodSweep2D();

// Cut disc using the swept rods
module cutDisc2D(steps=256) {
    difference() {
        disc2D();
        fullRodSweep2D(steps);
    }
}

// preview
//cutDisc2D(steps=256);

module outerRing2D() {
    offset(-spacing)
    union() {
        outerRods2D(); /// Cycloidal pins
        ring2D();
    }
}

module shaftCenter2D() {
    circle(d=center_rod_d);
}

module shaftEccentric2D() {
    circle(d=shaft_bearing_inner_d);
}

module showcase2D() {
    // Static (stationary) parts
    outerRing2D();
    #shaftCenter2D();

    // Dynamic (moving) parts
    theta = 360 * (ring_inner_d/(ring_inner_d-disc_d)-1) * $t;
    spin  = -theta * ring_inner_d / disc_d;

    rotate([0,0,theta])
    translate([0,disc_offset])
    rotate([0,0,spin]) {
        cutDisc2D();
        shaftEccentric2D();
    }

    rotate([0,0,-$t*360])
    innerRods2D();
}
//showcase2D();

module inverseShowcase2D() {
    // Same motion parameters you used for the disc
    theta = 360 * (ring_inner_d/(ring_inner_d-disc_d)-1) * $t;
    spin  = -theta * ring_inner_d / disc_d;

    // 1) Disc is stationary and centered
    cutDisc2D();

    // 2) Ring + outer pins move by the inverse of the disc motion
    rotate([0,0,-spin])
    translate([0,-disc_offset])
    rotate([0,0,-theta]) {
        outerRods2D();
        ring2D();
        circle(d=center_rod_d);
        rotate([0,0,-$t*360])
        innerRods2D();
    }
}
inverseShowcase2D();


//*** BEGIN 3D ***//
module outerRing() {
    linear_extrude(drive_h)
    outerRing2D();
}

module cutDisc() {
    linear_extrude(drive_h)
    cutDisc2D();
}

module innerRodDisc() {
    translate([0,0,-drive_h*0.5]) {
        linear_extrude(drive_h*0.5)
        circle(r=(disc_d+shaft_d)/4+inner_rod_d);
        linear_extrude(drive_h*1.5) // Change me?
        innerRods2D();
    }
}

module testInnerRodDisc() {
    difference() {
        innerRodDisc();
        for (i=[0:3]) {
            rotate([0,0,360*i/4])
            translate([0,12,-drive_h*0.5])
            cylinder(d=10, h=drive_h*0.5);
        }
    }
}

module centerShaft() {
    linear_extrude(drive_h)
    shaftEccentric2D();
    translate([0,-disc_offset,drive_h])
    linear_extrude(center_rod_h)
    shaftCenter2D();
}

module showcase() { // non-moving 3D
    testInnerRodDisc();
    color([1,0.5,0])
    translate([0,disc_offset,0]) {
        cutDisc();
        centerShaft();
    }
    color([0,0.5,1])
    outerRing();
    
}
//showcase();

module discPrint() {
    //cutDisc();
    centerShaft();
}
//color([1,0.5,0])
//scale([1,1,-1])
//translate([0,disc_offset,-ring_plate_thick-drive_h])
//discPrint();

num_struts = 3;
plate_rounding = 3;
module ringPlate() {
    linear_extrude(ring_plate_thick) 
    difference() {
        offset(-plate_rounding) offset(plate_rounding) {
            difference() {
                circle(d=ring_outer_d);
                circle(d=ring_inner_d-outer_rod_d);
            }
            for (i=[0:num_struts-1]) {
                rotate([0,0,i*360/num_struts])
                translate([(ring_inner_d-outer_rod_d)/4,0,0])
                square([(ring_inner_d-outer_rod_d)/2, center_bearing_outer_d/3], center=true);
            }
            circle(d=center_bearing_outer_d+center_bearing_outer_d/3);
        }
        circle(d=center_bearing_outer_d);
    }
}

module ringPrint() {
    ringPlate();
    translate([0,0,ring_plate_thick])
    outerRing();
}
//ringPrint();


//testInnerRodDisc();
