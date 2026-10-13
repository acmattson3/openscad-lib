req_volume=3.1416*127*127*203.2; // pi * r^2 * h

pot_top_r=200;
pr2=pot_top_r;
pot_bottom_r=(pot_top_r*7)/10;
pr1=pot_bottom_r;
pot_h=230;
wall_thickness=1.6;
inside_scale=(pot_h-wall_thickness)/pot_h;

revs=0.25; // Number of helix revolutions
num_helices=10;

module pot_outer() {
    cylinder(r2=pot_top_r, r1=pot_bottom_r, h=pot_h);
}

module pot_inner() {
    scale([inside_scale,inside_scale,inside_scale]) pot_outer();
}

helix_size=wall_thickness*2.5;
res=30; // Resolution of helix
module pot_helix() {
    // pr2 = upper radius
    // t = time, from 0 to revs (discrete)
    // res = resolution (res # points per 1 t)
    // pot_h = height of pot
    // Calc 3 below to make helix
    
    for (t=[-1:(revs*res)]) {
        helix_x1=cos(360*(t/res))*( (((t/res)/revs)*(pr2-pr1))+pr1 );
        helix_y1=sin(360*(t/res))*( (((t/res)/revs)*(pr2-pr1))+pr1 );
        helix_z1=pot_h*((t/res)/revs);
        
        helix_x2=cos(360*((t+1)/res))*( ((((t+1)/res)/revs)*(pr2-pr1))+pr1 );
        helix_y2=sin(360*((t+1)/res))*( ((((t+1)/res)/revs)*(pr2-pr1))+pr1 );
        helix_z2=pot_h*(((t+1)/res)/revs);
        
        hull() {
            translate([helix_x1,helix_y1,helix_z1])
                sphere(helix_size);
            translate([helix_x2,helix_y2,helix_z2])
                sphere(helix_size);
        }
    }
}

module pot_helices() {
    for (i=[0:num_helices]) {
        rotate(360*(i/num_helices))
        pot_helix();
    }
}

cleanup_cube_size=500;
module cleanup_cubes() {
    translate([0,0,pot_h+cleanup_cube_size/2])
    cube(cleanup_cube_size, center=true);
    translate([0,0,-cleanup_cube_size/2])
    cube(cleanup_cube_size, center=true);
}

module pot_with_helices() {
    difference() {
        union() {
            pot_outer();
            pot_helices();
            scale([-1,1,1])
            pot_helices();
            pot_rim_lower();
        }
        translate([0,0,pot_h-inside_scale*pot_h])
        pot_inner();
    }
}

num_drain_holes = 10;
drain_hole_r = 12;
drain_hole_center_dist = pot_bottom_r*6/10;
drain_hole_h=wall_thickness;
module drain_holes(cyl_scale=1) {
    for (i=[0:num_drain_holes]) {
        hole_x=drain_hole_center_dist*cos(360*(i/num_drain_holes));
        hole_y=drain_hole_center_dist*sin(360*(i/num_drain_holes));

        translate([hole_x,hole_y,0])
        scale([cyl_scale,cyl_scale,cyl_scale])
        cylinder(r=drain_hole_r, h=drain_hole_h);
    }
}

rim_res = 30;
rim_multiplier=1.2;
rim_height_mod=-0.7;
module pot_rim_upper() {
    for (i=[0:rim_res-1]) {
        x1=pr2*cos(360*(i/rim_res));
        y1=pr2*sin(360*(i/rim_res));
        x2=pr2*cos(360*((i+1)/rim_res));
        y2=pr2*sin(360*((i+1)/rim_res));
        
        hull() {
        translate([x1, y1, pot_h+rim_height_mod])
        rotate([45,45,360*(i/rim_res)])
        cube(helix_size*rim_multiplier, center=true);
        translate([x2, y2, pot_h+rim_height_mod])
        rotate([45,45,360*((i+1)/rim_res)])
        cube(helix_size*rim_multiplier, center=true);
        }
    }
}

module pot_rim_lower() {
    for (i=[0:rim_res-1]) {
        x1=pr1*cos(360*(i/rim_res));
        y1=pr1*sin(360*(i/rim_res));
        x2=pr1*cos(360*((i+1)/rim_res));
        y2=pr1*sin(360*((i+1)/rim_res));
        
        hull() {
        translate([x1, y1, 0])
        sphere(helix_size);
        translate([x2, y2, 0])
        sphere(helix_size);
        }
    }
}

module pot_final() {
    union() {
    difference() {
        pot_with_helices();
        cleanup_cubes();
        drain_holes();
    }
    pot_rim_upper();
    }
}

collector_wall_dist = 10;
collector_h = 25;
collector_wall_thick=8;
module water_collector_outside() {
    cylinder(r2=(1+collector_h/pot_h)*pot_bottom_r+collector_wall_dist+collector_wall_thick, r1=pot_bottom_r+collector_wall_dist+collector_wall_thick, h=collector_h);
}

collector_in_scale = (pot_h-collector_wall_thick)/pot_h;
module water_collector_inside() {
    scale([collector_in_scale, collector_in_scale, collector_in_scale])
    water_collector_outside();
}

stilt_height = 8;
module water_collector_stilts() {
    rotate(360/num_drain_holes/2)
    scale([1,1,stilt_height/drain_hole_h])
    drain_holes(0.7);
}

module water_collector() {
    union() {
    difference() {
        water_collector_outside();
        translate([0,0,collector_h-collector_in_scale*collector_h])
        water_collector_inside();
    }
    water_collector_stilts();
    }
}

//translate([0,0,stilt_height])
pot_final();
//water_collector();
