// Configs
container_end_wid_dia = 100;
container_end_len_dia = 50;
mid_scale_factor  = 1.35;
container_height  = 50;
container_thick   = 3;

// Automatically determined
container_end_wid = container_end_wid_dia/2;
container_end_len = container_end_len_dia/2;
container_mid_wid = container_end_wid * mid_scale_factor;
container_mid_len = container_end_len * mid_scale_factor;
num_slices = floor(container_height/2);

module wantEllipse(rw, rl) {
    scale([1,rl/rw])
    circle(rw);
}

module wantDisk(rw, rl, h) {
    linear_extrude(h)
        wantEllipse(rw, rl);
}

module simpleDisk(R) {
    rl = container_end_len;
    rw = container_end_wid;
    ratio = rl/rw; // Assumes we always maintain this ratio
    
    wantDisk(R, R*ratio, 0.1);
}

module containerSolidHalf() {
    r1=container_end_wid;
    r2=container_mid_wid;
    h=container_height;
    
    for (y=[1 : num_slices]) {
        R=((4/(h*h)) * (r1-r2)) * ((y-(h/2))*(y-(h/2))) + r2;
        R_prev=((4/(h*h)) * (r1-r2)) * (((y-1)-(h/2))*((y-1)-(h/2))) + r2;
        hull () {
            translate([0, 0, (y/num_slices)*(h/2)])
                simpleDisk(R);
            translate([0, 0, ((y-1)/num_slices)*(h/2)])
                simpleDisk(R_prev);
        }
    }
}

module containerSolid() {
    h=container_height;
    union() {
        containerSolidHalf();
        translate([0,0,h]) mirror([0,0,1])
        containerSolidHalf();
    }
}

module containerHollow() {
    ratio_x = (container_end_wid-container_thick)/container_end_wid;
    ratio_y = (container_end_len-container_thick)/container_end_len;
    ratio_z = ((container_height/2)-container_thick)/(container_height/2);
    difference() {
        containerSolid();
        translate([0, 0, container_thick]) 
        scale([ratio_x, ratio_y, ratio_z])
        containerSolid();
        
    }
    
}

difference() {
    containerHollow();
    cube(1000);
}
