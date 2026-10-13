$fs=0.4;
$fa=1;

bearing_outer_dia=23;
bearing_inner_dia=15;
bearing_h=6;
gap_size=0.6;
half_gap=gap_size/2;

bearing_outer_r=bearing_outer_dia/2;
bearing_inner_r=bearing_inner_dia/2;

roller_h=bearing_h-3;
roller_r=(bearing_outer_r-bearing_inner_r)/4;
num_rollers=round((3.142*((bearing_inner_dia+bearing_outer_dia)/2))/(roller_r*4))+1;


module wantCyl(r, h) {
    cylinder(h=h,r=r);
}


module bearingOuter() {
    difference() {
    wantCyl(bearing_outer_r, bearing_h);
    wantCyl(((bearing_inner_r+bearing_outer_r)/2)+half_gap, bearing_h+0.01);
    }
}

module bearingInner() {
    difference() {
    wantCyl(((bearing_inner_r+bearing_outer_r)/2)-half_gap, bearing_h);
    wantCyl(bearing_inner_r, bearing_h+0.02);    
    }
}

module rollerGap() {
    translate([0, 0, (bearing_h-roller_h)/2]) 
    difference() {
    wantCyl(((bearing_outer_r+bearing_inner_r)/2)+half_gap+roller_r, roller_h+gap_size);
    wantCyl(bearing_inner_r-half_gap+roller_r, roller_h+gap_size);
    }
}

roller_dist_r=(bearing_inner_r+bearing_outer_r)/2;
rotate_angle_deg=360/num_rollers;
module rollers() {
    for (i=[0:num_rollers-1]) {
        x=roller_dist_r*cos(i*rotate_angle_deg);
        y=roller_dist_r*sin(i*rotate_angle_deg);
        translate([x,y,((bearing_h-roller_h)/2)+half_gap])
        wantCyl(roller_r,roller_h);
    }
}

module bearing() {
    difference() {
    union() {
        bearingOuter();
        bearingInner();
    }    
    rollerGap();
    }
}

difference() {
    union() {
    bearing();
    rollers();
    }
    cube(100);
}
