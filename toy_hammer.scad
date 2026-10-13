hammer_rounding=5;
// Hammer Configurations
hammer_wid=60-hammer_rounding;
hammer_len=40-hammer_rounding;
hammer_height=hammer_len/1.5;
hammer_cutout_amount=1.7;
hammer_cutout_rad=hammer_len/hammer_cutout_amount;
hammer_cutout_scale_x=1.3;

// Handle Configurations
handle_rounding=3;
handle_wid=20-handle_rounding*2;
handle_len=100-handle_rounding*2;
handle_height=handle_wid;
handle_grip_rad=8;

module wantRect(l, w) {
    translate([-w/2,-l/2,0])
        square([w, l]);
}

module wantCirc(r) {
    circle(d=r*2,$fn=60);
}

module hammerHeadCutout() {
    scale([hammer_cutout_scale_x,1])
    translate([hammer_wid/(2*hammer_cutout_scale_x), hammer_len/2, 0])
        wantCirc(hammer_cutout_rad);
}

module hammerHead2D() {
        difference() {
        wantRect(hammer_len, hammer_wid);
        hammerHeadCutout();
    }
}

module hammerHead3D() {
    translate([0,0,hammer_rounding])
    minkowski() {
    linear_extrude(hammer_height)
        hammerHead2D();
    sphere(hammer_rounding);
    }
}

module handleGripHoles() {
    translate([handle_grip_rad,-handle_len,0])
    linear_extrude(handle_wid+2*handle_rounding)
    union() {
    translate([0,handle_grip_rad])
    wantCirc(handle_grip_rad);
    translate([0,3*handle_grip_rad-0.9])
    wantCirc(handle_grip_rad);
    translate([0,5*handle_grip_rad-1.8])
    wantCirc(handle_grip_rad);
    translate([0,7*handle_grip_rad-2.7])
    wantCirc(handle_grip_rad);
    }
}

module handle2D() {
    difference() {
    wantRect(handle_len, handle_wid);
    translate([handle_wid/2,-handle_len/2,0])
        handleGripHoles();
    }
}

module handle3D() {
    minkowski() {
    difference() {
    translate([0,-handle_len/2,handle_rounding])
    rotate([-90,0,0]) translate([0,-handle_wid/2,-handle_len/2])
    cylinder(h=handle_len, r=handle_wid/2);
    handleGripHoles();
    }
    sphere(handle_rounding);
    }
}

union() {
hammerHead3D();
translate([-5,0,handle_wid/2])
mirror([1,0,0])
handle3D();
}