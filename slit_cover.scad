// Slit Cover

$fn = 64;

// Dimensions of the slit itself
slit_len = 260.0; // 520.0
slit_wid = 8.0;

// Cover parameters
insert_depth = 10.0; // How far cover sits in slit
overhang = 7.0; // Overlap on either side
triang_thick = 5.0; // Thickness of covering portion
rounding = 0.5;

module slitCrossSection2D() {
    offset(-rounding) offset(rounding)
    offset(rounding) offset(-rounding)
    union() {
    square([slit_wid, insert_depth], center=true);
    traing_offset = (slit_wid/2.0)+overhang;
    translate([0, insert_depth/2.0, 0])
    polygon([[-traing_offset, 0], [traing_offset, 0.0], [0.0, triang_thick]]);
    }
}

linear_extrude(slit_len)
slitCrossSection2D();