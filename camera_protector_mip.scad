// MiP camera insert/protector

$fn = 48;

insert_wid = 9.6;
insert_len = 14.0;
base_thick = 0.6;
cam_h = 2.1+0.3;
bezel_wall_thick = 4.0;
side_wall_thick = 1.0;
cam_dia = 7.2;
cam_wid = 8.34;
insert_dist = 5.6;

difference() {
    union() {
        linear_extrude(base_thick)
        square([insert_wid, insert_len], center=true);
        translate([0,-insert_dist/2-side_wall_thick/2,0])
        linear_extrude(base_thick+cam_h+bezel_wall_thick)
        square([cam_wid+side_wall_thick*2, insert_len-insert_dist+side_wall_thick], center=true);
    }
    translate([0,-insert_dist/2+0.04-0.2,base_thick])
    linear_extrude(cam_h)
    square([cam_wid, cam_wid+0.4], center=true);
    translate([0,0,bezel_wall_thick+base_thick+cam_h])
    mirror([0,0,1])
    linear_extrude(bezel_wall_thick, scale=1.15)
    hull() {
        translate([0,-insert_dist/2])
        circle(d=cam_dia);
        translate([0,insert_dist/2])
        circle(d=cam_dia);
    }
}