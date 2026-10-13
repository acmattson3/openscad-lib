// Crate "shelf" inserts
// 20.2x17 cm^2
shelf_len = 202.0;
shelf_wid = 170.0;
shelf_h = 150.0/4.0; // 150mm total height, 4 shelves total

wall_thick = 0.8;
spacing = wall_thick*2.0;


// Side wall without handle
module wall3D(wid) {
    translate([0,0,shelf_h/2.0])
    rotate([90,0,0])
    translate([0,0,-wall_thick/2.0])
    linear_extrude(wall_thick)
    square([wid, shelf_h], center=true);
}

module uncutBox3D() {
    union() {
        translate([0,shelf_wid/2-wall_thick/2.0,0])
        wall3D(shelf_len);
        translate([0,-shelf_wid/2+wall_thick/2.0,0])
        wall3D(shelf_len);
        
        rotate([0,0,90]) {
        translate([0,shelf_len/2-wall_thick/2.0,0])
        wall3D(shelf_wid);
        translate([0,-shelf_len/2+wall_thick/2.0,0])
        wall3D(shelf_wid);
        }
    }
}

module solidBoxTop3D() {
    translate([0,0,shelf_h/2.0])
    cube([shelf_len, shelf_wid, (shelf_h*7.0)/8.0], center=true);
}

diff = wall_thick+spacing;
module solidBoxBottom3D() {
    translate([0,0,shelf_h/(2*8.0)])
    cube([shelf_len-diff, shelf_wid-diff, shelf_h/8.0], center=true);
}

module solidBox3D() {
    union() {
        solidBoxTop3D();
        solidBoxBottom3D();
    }
}

module hulledSolidBox3D() {
    hull() {
    solidBox3D();
    solidBox3D();    
    }
    
}

difference() {
hulledSolidBox3D();
translate([0,0,shelf_h*(7.0/8.0)])
hulledSolidBox3D();
}

