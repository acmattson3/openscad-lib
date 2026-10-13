// Custom Thermostat Housing

wall_mount_len=90;
wall_mount_wid=50;
wall_mount_dep=20;
wall_mount_thick=5;
wall_mount_inside_scale_x=1-(wall_mount_thick/wall_mount_wid);
wall_mount_inside_scale_y=1-(wall_mount_thick/wall_mount_len);
wall_mount_inside_scale_z=1-(wall_mount_thick/wall_mount_dep);


mount_hole_len=8;
mount_hole_wid=3;
mount_hole_dep=5;
mount_holes_dist_inner_vert=80;
mount_holes_dist_inner_hor=40;

module wantRect(l, w) {
    translate([-w/2,-l/2,0])
        square([w, l]);
}

module wantCirc(s) {
    circle(d=s,$fn=60);
}

module mountBody2D() {
    wantRect(wall_mount_len, wall_mount_wid);
}

x=mount_holes_dist_inner_hor/2-mount_hole_wid/2;
y=mount_holes_dist_inner_vert/2-mount_hole_len/2;
module mountHoles2D() {
    translate([x, y])
        wantRect(mount_hole_len, mount_hole_wid);
    translate([-x, y])
        wantRect(mount_hole_len, mount_hole_wid);
    translate([x, -y])
        wantRect(mount_hole_len, mount_hole_wid);
    translate([-x, -y])
        wantRect(mount_hole_len, mount_hole_wid);
}

module mountHoleSupports2D() {
    l=mount_hole_len+wall_mount_thick;
    w=mount_hole_wid+wall_mount_thick;
    
    translate([x, y])
        wantRect(l, w);
    translate([-x, y])
        wantRect(l, w);
    translate([x, -y])
        wantRect(l, w);
    translate([-x, -y])
        wantRect(l, w);
}

module mountHolesSupported3D() {
    difference() {
        linear_extrude(wall_mount_dep)
            mountHoleSupports2D();
        linear_extrude(mount_hole_dep)
            mountHoles2D();    
    }
}

module wallMountBody3D() {
    difference() {
    linear_extrude(wall_mount_dep) 
        mountBody2D();
    scale([wall_mount_inside_scale_x,wall_mount_inside_scale_y])
    linear_extrude(wall_mount_dep*wall_mount_inside_scale_z)
        mountBody2D();
    }
}

module wallMount3D() {
    union() {
    mountHolesSupported3D();
    wallMountBody3D();
    }
}

wallMount3D();