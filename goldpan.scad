// Goldpan

$fn = 64;
pan_height = 65.0/2;
pan_dia_upper = 210.0/2;
pan_dia_lower = 115.0/2;
pan_wall_thick = 5;
ridge_angle = 100;
ridge_extremity = 0.2;
ridge_freq = 6;
ridge_start = 3;

module solid_pan() {
    hull() {
    cylinder(0.01, pan_dia_lower);
    translate([0,0,pan_height])
    cylinder(0.01, pan_dia_upper);
    }
}

module solid_pan_and_ridges() {
    solid_pan();
    //pan_ridges();
}

module ridge_shape(ridge_h) {
    lower_rad = (pan_dia_upper-pan_dia_lower)*ridge_extremity;
    upper_rad = pan_height*ridge_extremity;
    translate([0,0,ridge_h+lower_rad])
    rotate_extrude(angle=ridge_angle) {
    ridge_dist = ((ridge_h*(pan_dia_upper-pan_dia_lower))/pan_height)+pan_dia_lower;
    translate([ridge_dist+pan_wall_thick/2,0])
    polygon([[-lower_rad/3,0], [lower_rad,0], [0,-upper_rad]]);
        
    }
}

module hollowed_pan() {
    difference() {
    solid_pan();
    translate([0,0,pan_wall_thick])
    solid_pan();
    }
}

module pan_rim() {
    translate([0,0,pan_height])
    rotate_extrude() {
        translate([pan_dia_upper-sqrt(2)*pan_wall_thick/2,0])
        circle(d=sqrt(2)*pan_wall_thick);
    }
    
}


union() {
for (i=[ridge_start:ridge_freq:round(pan_height*9/10-pan_height*ridge_extremity)]) {
ridge_shape(i);
}
hollowed_pan();
}
difference() {
pan_rim();
translate([0,0,pan_height/2])
cube([300,300,pan_height], center=true);
}
