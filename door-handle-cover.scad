// TPU Air Door Handle Cover

$fn = 64;

door_ball_dia = 53.25;
door_ball_h = 41.0;
handle_h = 67.5+2; // Door-to-ball, +2 for squishing to door
base_h = 10.0; // Platform before neck
neck_dia = 48.0; // Not the actual dia, but the desired spacing
base_dia = 65.25; // Platform before neck

//deadbolt_base_base_h = 4.0;
deadbolt_base_h = 4.8+0.5;
deadbolt_h = 24.0 + deadbolt_base_h+0.5;//31.7+1.0;//27.6+1;
//deadbolt_base_lower_dia = 69.4-1.0; // Platform
//deadbolt_base_upper_dia = 68.4;
deadbolt_base_dia = 68.4;
deadbolt_top_upper_dia = 44.2;//42.5;
deadbolt_top_lower_dia = 53.9;//60.0;

wall_thick = 10.0; // At thinnest parts

module handle3D() {
    cylinder(d=base_dia, h=base_h);
    translate([0,0,base_h])
    cylinder(d1=base_dia, d2=neck_dia, h=base_h);
    translate([0,0,handle_h-door_ball_dia/2+(door_ball_dia-door_ball_h)])
    intersection() {
        sphere(d=door_ball_dia);
        translate([0,0,-(door_ball_dia-door_ball_h)/2])
        cube([door_ball_dia, door_ball_dia, door_ball_h], center=true);
    }
    cylinder(d=neck_dia, h=handle_h-door_ball_h/2);
}

module handleCover() {
    difference() {
        union() {
            minkowski() {
                handle3D();
                sphere(d=wall_thick*2);
            }
            translate([0,0,handle_h-door_ball_dia+door_ball_h+door_ball_dia/6])
            cylinder(d1=door_ball_dia+2*wall_thick-3.5, d2=door_ball_dia+10, h=door_ball_dia-door_ball_h+10-door_ball_dia/6);
        }
        handle3D();
        translate([0,0,-500])
        cube(1000, center=true);
        //cube(1000);
    }
}
//handleCover();

module deadboltBase3D() {
    cylinder(h=deadbolt_base_h, d=deadbolt_base_dia);
}

module deadboltTop3D(extra=0.0, base_ext=0.0) {
    translate([0,0,deadbolt_base_h])
    cylinder(d1=deadbolt_top_lower_dia+extra+base_ext, d2=deadbolt_top_upper_dia+extra, h=deadbolt_h-deadbolt_base_h+extra/2);
}

module deadbolt3D(base_ext = 0.0) {
    deadboltBase3D();
    deadboltTop3D(base_ext=base_ext);
}
//deadbolt3D();

module deadboltCover() {
    difference() {
        union() {
            minkowski() {
                //deadbolt3D();
                deadbolt3D(base_ext = 9.0);
                sphere(d=2*wall_thick);
            }
            deadboltTop3D(extra=2*wall_thick);
            //translate([0,0,deadbolt_base_h])
            //cylinder(d1=deadbolt_top_lower_dia+2*wall_thick, d2=deadbolt_top_upper_dia+2*wall_thick, h=deadbolt_h-deadbolt_base_h+wall_thick);
        }
        deadbolt3D();
        translate([0,0,-500])
        cube(1000, center=true);
        //cube(1000);
    }
}
deadboltCover();