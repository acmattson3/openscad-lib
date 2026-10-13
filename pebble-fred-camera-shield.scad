// Pebble Fred Camera Shield

$fn = 64;

rim_thick = 0.4;
rim_depth = 0.8;
inner_dia = 7.2;
rim_shield_thick = 3.0;
squish = 1.25;

module rimInsert() {
    translate([0,0,-rim_depth])
    linear_extrude(rim_depth)
    difference() {
        circle(d=inner_dia+2*rim_thick);
        circle(d=inner_dia);
    }
}
rimInsert();

module offsetSphere(amount, dia) {
    translate([amount+dia/2,0,0])
    scale([1,1,squish])
    sphere(d=dia);
}

module rimShield() {
    difference() {
        for (i=[0:$fn-1]) {
            hull() {
                rotate([0,0,i*360/$fn])
                offsetSphere(inner_dia/2, rim_shield_thick);
                rotate([0,0,(i+1)*360/$fn])
                offsetSphere(inner_dia/2, rim_shield_thick);
            }
        }
        translate([0,0,-inner_dia/2-rim_shield_thick])
        cube(inner_dia+2*rim_shield_thick, center=true);
        cylinder(h=rim_shield_thick*squish, d1=inner_dia, d2=inner_dia+2*rim_shield_thick);
        translate([0,0,squish*1.25*rim_shield_thick+inner_dia/2])
        cube(2*rim_shield_thick+inner_dia, center=true);
    }
} 
rimShield();
//cube(rim_shield_thick/2);