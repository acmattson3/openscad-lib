$fn = 32;

tub_drain_lower_rad = 36.0/2.0;
tub_drain_upper_rad = 43.0/2.0;
tub_drain_rad_diff = tub_drain_upper_rad - tub_drain_lower_rad;
drain_len = 23.0;

filter_lip_len = 8.0;
filter_lip_taper_dist = 1.6;
filter_lip_taper_min = 0.01;
filter_wall_thick = 2.0;
filter_hole_rad = 2.5;
num_holes = 10;
hole_height_mult = 0.7;

module drain_profile() {
    linear_extrude(drain_len, scale = tub_drain_upper_rad/tub_drain_lower_rad)
    circle(r=tub_drain_lower_rad);
}

module water_well() {
    translate([0,0,filter_wall_thick])
        linear_extrude(drain_len-filter_wall_thick, scale = (tub_drain_upper_rad-filter_wall_thick)/(tub_drain_lower_rad-filter_wall_thick))
            circle(r=tub_drain_lower_rad-filter_wall_thick);
}

module filter_walls() {
    difference() {
        drain_profile();
        water_well();
    }
}

module punched_filter_walls() {
    difference() {
        filter_walls();
        for (i=[0:num_holes]) {
            rotate_amount = (i/num_holes)*360;
            rotate([0,0,rotate_amount+(180/num_holes)])
            translate([0,0,filter_hole_rad*1.2])
            filter_hole();
        }
        for (i=[0:num_holes]) {
            rotate_amount = (i/num_holes)*360;
            rotate([0,0,rotate_amount])
            filter_hole();
        }
    }
}

module filter_lip() {
    difference() {
        translate([0,0,drain_len-filter_wall_thick])
        hull () {
        linear_extrude(filter_wall_thick)
            circle(r=tub_drain_upper_rad+2.0*filter_lip_len-2.0*filter_lip_taper_dist);
        linear_extrude(filter_lip_taper_min)
            circle(r=tub_drain_upper_rad+2.0*filter_lip_len);
        }
        water_well();
    }
}

module filter_hole() {
    translate([tub_drain_upper_rad,0,drain_len*hole_height_mult])
    rotate([0,60,0])
    cylinder(r=filter_hole_rad, h=filter_wall_thick*10.0, center=true);
}

//punched_filter_walls();
difference() {
union() {
punched_filter_walls();
filter_lip();
}
//cube(100);
}



