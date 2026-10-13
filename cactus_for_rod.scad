$fn = 64;

lamp_rod_dia = 10.8;
clamp_thick = 4.0;
clamp_flange_len = 12.0;
clamp_height = 8.0;

m3_shaft_len = 10.0;
m3_shaft_dia = 2.8;
m3_head_dia = 5.3;
m3_head_len = 3.0;
connecting_rod_len = 20;

module cactus_top() {
    translate([-1.0,-1,-9])
    difference() {
    translate([13.75,0,0])
    import("cactusRingStand2.stl");
    translate([-35,-35,-41])
    cube([70,70,50]);
    }
}

module rod_clamp_half_2d() {
    union() {
    difference() {
        circle(clamp_thick+lamp_rod_dia/2);
        circle(lamp_rod_dia/2);
        translate([-(lamp_rod_dia/2+clamp_thick),0])
        square(2*(lamp_rod_dia/2+clamp_thick), false);
    }
    translate([lamp_rod_dia/2, -clamp_thick])
    square([clamp_flange_len, clamp_thick]);
    translate([-(lamp_rod_dia/2+clamp_flange_len), -clamp_thick])
    square([clamp_flange_len, clamp_thick]);
    
    }
}

module m3_screw() {
    translate([0,0,m3_shaft_len+m3_head_len])
    rotate([180,0,0])
    union() {
    translate([0,0,m3_shaft_len])
    linear_extrude(m3_head_len)
    circle(m3_head_dia/2);
    linear_extrude(m3_shaft_len)
    circle(m3_shaft_dia/2);
    }
}

module rod_clamp_half_3d() {
    linear_extrude(clamp_height)
    rod_clamp_half_2d();
}
module rod_clamp_halves_3d() {
    difference() {
    union() {
    rod_clamp_half_3d();
    translate([0,4,clamp_height])
    rotate([180,0,0])
    rod_clamp_half_3d();
    }
    translate([lamp_rod_dia/2+(clamp_flange_len+clamp_thick)/2,-clamp_thick,clamp_height/2])
    rotate([-90,0,0])
    #m3_screw();
    translate([-(lamp_rod_dia/2+(clamp_flange_len+clamp_thick)/2),-clamp_thick,clamp_height/2])
    rotate([-90,0,0])
    #m3_screw();
    }
}

module connecting_rod() {
    translate([-clamp_thick, -connecting_rod_len, 0])
    cube([clamp_thick*2, connecting_rod_len+clamp_thick, clamp_height]);
}

module clamp_and_rod() {
    translate([0,connecting_rod_len,-clamp_height/2])
    union() {
    translate([0,lamp_rod_dia/2+clamp_thick,0])
    rod_clamp_halves_3d();
    connecting_rod();
    }
}

module cactus_for_rod() {
    difference() {
    translate([0,0,clamp_height/2])
    union() {
    clamp_and_rod();
    sphere(7);
    cactus_top();
    }
    translate([0,0,-25])
    cube([100,100,50], center=true);
    }
}

cactus_for_rod();
