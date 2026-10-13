$fn=30;

// Bearing size
bearing_dia=22;
bearing_r=bearing_dia/2;
bearing_inner_dia=8;
bearing_inner_r=bearing_inner_dia/2;
min_wall_thick=0.4;
bearing_h=7;
// Hole to cut for bearing to fit
in_place_cylinder_r=bearing_r-min_wall_thick/2; // Allow overlap of bearing walls into spinner

// Spinner configs
spinner_num_arms=3;
spinner_arm_len=1.8*bearing_dia;
spinner_end_size=bearing_r*1.1; 

// Hole to cut for bearing
module bearing_space() {
    cylinder(h=bearing_h,r=in_place_cylinder_r);
}

module bearing() {
    import("roller_bearing_v2.stl");
}

rotate_angle_deg=360/spinner_num_arms;
module spinner_2D() {
    for (i=[0:spinner_num_arms-1]) {
        x=spinner_arm_len*cos(i*rotate_angle_deg);
        y=spinner_arm_len*sin(i*rotate_angle_deg);
        
        x_inner=x*1/2;
        y_inner=y*1/2;
        
        union() {
            hull() {
            translate([x,y,])
                circle(r=spinner_end_size);
            translate([x_inner,y_inner])
                circle(r=spinner_end_size*2/3);
            }
            hull() {
            translate([x_inner,y_inner])
                circle(r=spinner_end_size*2/3);
            circle(r=bearing_r+2);
            }
        }
    }
}

rounding=10;
module spinner() {
    linear_extrude(bearing_h)
        offset(r=-rounding) offset(r=rounding)
        spinner_2D();
}

bearing_pad_height=0.88;
module bearing_pad() {
    union() {
    // Bearing pad
    cylinder(r=bearing_r, h=bearing_pad_height);

    // Cylinder to insert into bearing (and attach pad)
    translate([0,0,bearing_pad_height])
        cylinder(r1=bearing_inner_r, r2=bearing_inner_r-0.1, h=bearing_h/3);
    }
}


difference() {
    spinner();
    bearing_space();
}

bearing();

/*
pad_spacing=bearing_r*1.3;
translate([pad_spacing,0,0]) bearing_pad();
translate([-pad_spacing,0,0]) bearing_pad();*/


