// Foam missile (for foot launcher)
$fn = 32;

missile_wall_thick = 0.4;
missile_od = 17.4;
missile_id = missile_od - missile_wall_thick;
missile_shaft_len = 210.0;
missile_tip_len = 70.5;
missile_tip_lower_dia = 25.5;
missile_tip_upper_dia = 43.2;
missile_tip_flatness = 0.75; // 1.0 is round, 0.0 is flat
spacing = 0.05;
fin_thick = 8*missile_wall_thick;
fin_len = 20.0;
fin_h = fin_len*2;
num_fins = 3;

module missileShaft2D(do_diff = true) {
    difference() {
        circle(d=missile_od);
        if (do_diff)
            circle(d=missile_id);
    }
}

module missileFin2D() {
    polygon([
        [0, fin_thick/2],
        [fin_len, 0],
        [0, -fin_thick/2]
    ]);
}
//missileFin2D();

module missileFin3D() {
    translate([missile_od/2,0,0])
    linear_extrude(fin_h, scale=0.01)
    missileFin2D();
}
//missileFin3D();

module missileFins3D() {
    for(i=[0:num_fins-1]) {
        rotate([0,0,(360/num_fins)*i])
        missileFin3D();
    }
}
//missileFins3D();

module missileShaft3D(do_diff = true) {
    linear_extrude(missile_wall_thick)
    circle(d=missile_od);
    linear_extrude(missile_shaft_len)
    missileShaft2D(do_diff);
    translate([0,0,missile_shaft_len])
    rotate([180,0,0])
    missileFins3D();
}
//missileShaft3D();

module missileShaftVase3D() {
    missileShaft3D(do_diff=false);
}
//missileShaftVase3D();

module missileSolidTip3D() {
    hull() {
        cylinder(d=missile_tip_lower_dia, h=0.01);
        translate([0,0,missile_tip_len-(missile_tip_upper_dia*missile_tip_flatness)/2])
        scale([1,1,missile_tip_flatness])
        sphere(d=missile_tip_upper_dia);
    }
}
//missileSolidTip3D();

module missileTip3D() {
    difference() {
        missileSolidTip3D();
        linear_extrude((5*missile_tip_len)/8)
        circle(d=missile_od+spacing);
    }
}
missileTip3D();

module missileTipPrintable() {
    translate([0,0,missile_tip_len])
    rotate([180,0,0])
    missileTip3D();
}
//missileTipPrintable();

module fullMissile() {
    translate([0,0,missile_shaft_len-(3*missile_tip_len)/4])
    #missileTip3D();
    translate([0,0,missile_shaft_len])
    rotate([180,0,0])
    missileShaft3D();
}
//fullMissile();