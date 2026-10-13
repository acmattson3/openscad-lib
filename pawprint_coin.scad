coin_dia=30;
coin_thick=4;
edge_quality=120;

module pawprint_import_obj() {
    //scale_factor=0.08305;
    //scale([scale_factor,scale_factor])
    //translate([-3.0,-7.0,0])
    translate([-15, -15, 0])
        import("pawprint_coin.stl");
}

translate([0,-14,0]) // Center the coin
rotate([-88,0,0]) // Flip the coin back over
difference() { // Cut off bottom of coin (so it sits up)
translate([0, 0, 14.0]) // Lift coin up
rotate([88, 0, 0]) // Sit coin upright
scale([1, 1, 7/4]) // Make coin thicker
pawprint_import_obj(); // Pawprint coin

translate([-50/2, -50/2, -50]) // Center and move cube down
cube(50);
}