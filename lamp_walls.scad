outer_wall_dia = 132.8; // The lamp's outer base diameter
rod_dia = 11.2; // The lamp's inner rod diameter
outer_rounding = 3; // How rounded the outer walls are
wall_thick = 3.0; // The thickness of the outer walls
gap_size = 0.4; // The gap between sliding parts
locking_circle_dia = 18.0;
wall_height = 80.0;

module wantCirc(s) {
    circle(d=s,$fn=60);
}

module wantRect(l, w) {
    translate([-l/2,-w/2,0])
        square([l, w]);
}

module lamp_wall_base_2d() {
    difference() {
    wantCirc(outer_wall_dia);
    wantCirc(rod_dia);
    };
}

// The slot to slip the walls onto the lamp
module rod_cutout_2d() {
    union() {
    translate([0, outer_wall_dia/4])
    wantRect(rod_dia-0.3, outer_wall_dia/2);
    translate([0, outer_wall_dia/4])
    wantCirc(locking_circle_dia);
    }
}

module lamp_base_outer_2d() {
    offset(r=outer_rounding) 
    offset(r=-outer_rounding)
    difference() {
    lamp_wall_base_2d();
    rod_cutout_2d();
    }
}

// The part to be cut out of the 3D object
module lamp_base_inner_2d() {
    offset(r=-wall_thick)
    lamp_wall_base_2d();
}

module locking_key() {
    offset(-gap_size)
    difference() {
    wantCirc(outer_wall_dia-0.1);
    lamp_base_outer_2d();
    wantCirc(rod_dia);
    }
}

module lamp_base_2d() {
    union() {
    locking_key();
    lamp_base_outer_2d();
    }
}

module lamp_walls_3d() {
    difference() {
        difference() {
        linear_extrude(wall_height)
            lamp_wall_base_2d();
        translate([0, 0, wall_thick])
        linear_extrude(wall_height - wall_thick)
            wantCirc(outer_wall_dia-wall_thick);
        }
        linear_extrude(wall_thick)
        wantCirc(outer_wall_dia+0.2);
    }
}

module wall_cutout_2d() {
    difference() {
        offset(-0.01)
        lamp_wall_base_2d();
        offset(0.1)
        lamp_base_2d();
    }
}

module wall_cutout_3d() {
    intersection() {
    translate([0, 0, wall_thick])
    linear_extrude(wall_height-wall_thick) {
        offset(0.015)
        wall_cutout_2d();
    }
    lamp_walls_3d();
    }
}

module final_lamp_walls_3d() {
    difference() {
        lamp_walls_3d();
        wall_cutout_3d();
    }
}

union() {
final_lamp_walls_3d();
linear_extrude(wall_thick)
lamp_base_2d();
}














