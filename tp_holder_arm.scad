// TP holder

$fn = 64;

tp_d = 150.0;
tp_h = 125.0;

roller_tip_d = 15.65 + 2.0; // We don't want a tight fit at all.
roller_tip_h = 7.0 - 1.0; // We want shallower than actual.

holder_dist = 130.0; // By the screw holes
screw_dist = 36.0; // On one arm

screw_head_d = 9.0 + 0.4;
screw_shaft_d = 3.85;
screw_head_h = 2.5;

wall_thick = 5.0;
arm_wid = roller_tip_d;// + 2*wall_thick;
arm_len = roller_tip_h + 2*wall_thick;
arm_base_wid = screw_dist+4;
wire_thick = 2.0;

module tpRoll() {
    translate([-tp_h/2,0,tp_d/2])
    rotate([0,90,0])
    difference() {
        cylinder(d=tp_d, h=tp_h);
        cylinder(d=tp_d/3, h=tp_h);
    }
}
//tpRoll();

module rollerHole2D() {
    translate([0, tp_d/2])
    circle(d=roller_tip_d);
}

module armTempBase2D() {
    temp_thick = 6;
    translate([0,-temp_thick/2])
    square([arm_wid, temp_thick], center=true);
}

module armFeatures() {
    rollerHole2D();
    armTempBase2D();
}
//armFeatures();

module armChonk() {
    hull() {
        armFeatures();
    }
}

module armOutline() {
    difference() {
        offset(wall_thick)
        armChonk();
        armFeatures();
    }
}
//armOutline();

module armLighter() {
    difference() {
        armOutline();
        offset(wall_thick) offset(-wall_thick)
        offset(-wall_thick)
        armOutline();
    }
}
//armLighter();

module armBase2D() {
    difference() {
        offset(-2*wall_thick) offset(2*wall_thick)
        offset(2) offset(-2)
        union() {
            offset(wall_thick)
            armChonk();
            square([arm_base_wid+2*wall_thick, 2*wall_thick+screw_head_h], center=true);
        }
        offset(wall_thick)
        armChonk();
        translate([0,-100])
        square(200, center=true);
    }
}
//armBase2D();

module arm2D() {
    difference() {
        armLighter();
        translate([0,-100])
        cube(200, center=true);
    }
    armBase2D();
}
//arm2D();

module screwHole() {
    translate([0,screw_head_h+wall_thick, arm_len/2])
    rotate([90,0,0]) {
        linear_extrude(30.0)
        circle(d=screw_shaft_d);
        translate([0,0,-screw_head_h*3])
        linear_extrude(screw_head_h*4)
        circle(d=screw_head_d);
    }
}

module screwHoles() {
    translate([screw_dist/2,0,0])
    screwHole();
    translate([-screw_dist/2,0,0])
    screwHole();
}
//screwHoles();

module arm() {
    translate([0, tp_d/2])
    cylinder(d=roller_tip_d+wall_thick, h=arm_len-roller_tip_h);
    difference() {
        linear_extrude(arm_len)
        arm2D();
        translate([0,-500,0])
        cube(1000, center=true);
        screwHoles();
    }
}
arm();







