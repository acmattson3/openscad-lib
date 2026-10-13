// Scraper (for door ice)
// Started 2025-02-13

handle_len = 100.0;
handle_dia = 20.0;
blade_wid = 60.0;
blade_len = 50.0;
scraper_thick = 5.0;

module blade2D() {
    scale([1,2,1])
    difference() {
        circle(d=blade_len);
        translate([0,-blade_len/2])
        square([blade_len, blade_len], center=true);
    }
}

rounding = 5.0;
module handle2D() {
    offset(rounding) offset(-rounding)
    translate([0,handle_len/2+blade_len/1.5])
    square([handle_dia, handle_len], center=true);
}

module scraperBody3D() {
linear_extrude(scraper_thick) {
    handle2D();
    blade2D();
}
}


module finalScraper3D() {
    difference() {
        scraperBody3D();
        translate([0,0,scraper_thick/2.0+1.6])
        rotate([30,0,0])
        cube([blade_wid, scraper_thick*4, scraper_thick*sqrt(2.0)], center=true);
    }
}


finalScraper3D();