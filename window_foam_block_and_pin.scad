// Window Foam Block & Pin
// 2025-03-01
$fn = 32;

foam_thick = 12.5; // Foam sheet
cmd_len = 21.8; // Command Strip
cmd_wid = 15.7;
cmd_thick = 0.52;

// Pin Dimensions
pin_rounding = 2.0;
pin_len = cmd_len/2.0;
pin_wid = 60.0;
pin_h = pin_len/2.0;
pin_gap = 0.2;

// Block Dimensions
rounding = 4.0;
block_h = foam_thick + pin_h*1.5 - cmd_thick;
block_len = cmd_len+rounding;
block_wid = cmd_wid;


module blockSolid3D() {
    translate([0,block_h/2.0,0])
    linear_extrude(block_wid)
    offset(rounding) offset(-rounding)
    square([block_len, block_h], center=true);
    
    
}

module pinHole3D() {
    translate([0,foam_thick-cmd_thick+pin_h/2.0,block_wid/2.0])
    cube([pin_len, pin_h, block_wid], center=true);
    
}

module block3D() {
    //cube([10.0, foam_thick-cmd_thick, 20.0]);
    translate([0,-(block_wid+rounding)/2.0,0])
    //rotate([90,0,0])
    difference() {
    blockSolid3D();
    pinHole3D();
    }
}


module pin3D() {
    hull() {
        translate([0,0,pin_h-2*pin_gap])
        linear_extrude(0.01)
        offset(pin_rounding) offset(-pin_rounding)
        square([pin_len-pin_gap, block_wid*1.5-pin_gap], center=true);
        linear_extrude(0.01)
        offset(pin_rounding) offset(-pin_rounding)
        square([pin_len-pin_gap, pin_wid-pin_gap], center=true);
    }
}

//block3D();
//#translate([0,0,foam_thick-cmd_thick+pin_gap/2.0])
pin3D();











