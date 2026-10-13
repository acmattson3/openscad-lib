// Ender 3 Pro Pen Plotter Tool

use <fillets.scad>;
use <tpu_springs.scad>;

$fn=32;

ptfe_dia = 4.21;
spring_inner_dia = 6.4;//7.0; // ~0.1 less than actual
pen_shaft_dia = 3.22+0.4; // Actual was ~2.96, but we want free sliding
pen_insert_dia = 4.1; // Actual was ~3.93, but we don't want too tight
pen_insert_len = 9.55;
pen_head_dia = 5.65;
desired_spring_len = 10.0;//16.0; // Force felt good here
min_spring_len = 4.5;//7.0; // As far as we're comfortable
rod_dia = 2.15+0.4; // Actual was 2.0
min_rod_len = (49.9-2.9)/2; // The total length we have to work with (try for less?)

m3_shaft_len = 10.0;
m3_shaft_dia = 3.0;
m3_head_dia = 5.3;
m3_head_len = 3.0+10.0;

wall_thick = 1.6;
rounding = 3.0;
fillet_rad = 1.0;
lid_unoffset = 3.0;
screw_spot_len = m3_shaft_len;
lid_extra_offset = 1.5;

mount_hole_bed_dist = 45.5;
pen_head_len = 10.0;
pen_out_dist = pen_head_len-wall_thick;
pen_squish_amount = 2.0;
mount_hole_rod_dia = 4.7;
mount_screw_hole_dist=14.4;
mount_hole_rod_len = 4.5;
//screw_hole_dia=3.0;


num_rods = 3;

slider_case_spacing = 0.4;

slider_dia = 26.0;
slider_len = min_rod_len-desired_spring_len-2*wall_thick;
//echo(slider_len);

//#linear_extrude(slider_len+2)
//circle(d=8.6);

module sliderSolid2D(unoffset=0.0) {
    offset(rounding-unoffset) offset(-rounding+unoffset)
    circle(d=slider_dia, $fn=num_rods);
}

module ptfeHoles2D() {
    for (i=[0:num_rods-1]) {
        rotate([0,0,i*360/num_rods])
        translate([slider_dia/4,0])
        circle(d=ptfe_dia);
    }
}

module rodHoles2D() {
    for (i=[0:num_rods-1]) {
        rotate([0,0,i*360/num_rods])
        translate([slider_dia/4,0])
        circle(d=rod_dia);
    }
}

module penHole2D() {
    circle(d=pen_insert_dia);
}

module sliderLower3D() {
    linear_extrude(pen_insert_len)
    difference() {
        sliderSolid2D();
        ptfeHoles2D();
        circle(d=pen_insert_dia);
    }
    fil_rad = pen_insert_dia/2-pen_shaft_dia/2;
    translate([0,0,pen_insert_len-fil_rad])
    fillet(fil_rad, pen_shaft_dia/2, false, true);
    //#fillet(pen_insert_dia-pen_shaft_dia, pen_shaft_dia, false, true);
}
//sliderLower3D();

module sliderUpper3D() {
    linear_extrude(slider_len-pen_insert_len)
    difference() {
        sliderSolid2D();
        ptfeHoles2D();
        circle(d=pen_shaft_dia);
    }
}

module sliderSpringNub() {
    linear_extrude(min_spring_len/2)
    difference() {
        circle(d=spring_inner_dia);
        circle(d=pen_shaft_dia);
    }
    fillet(fillet_rad, spring_inner_dia/2, true, false);
}

module slider3D() {
    translate([0,0,slider_len])
    sliderSpringNub();
    translate([0,0,pen_insert_len])
    sliderUpper3D();
    sliderLower3D();
}
//translate([0,0,wall_thick])
//slider3D();

module sliderCaseSolid2D(unoffset=0.0) {
    offset(wall_thick+slider_case_spacing)
    sliderSolid2D(unoffset);
}
//#sliderCaseSolid2D();

module sliderCaseWalls2D() {
    difference() {
        sliderCaseSolid2D();
        offset(-wall_thick)
        sliderCaseSolid2D();
    }
}
//#sliderCaseWalls2D();

module sliderCaseScrewSpots() {
    translate([0,0,min_rod_len-wall_thick-screw_spot_len]) {
        hull() {
            linear_extrude(screw_spot_len)
            sliderCaseSolid2D(lid_unoffset);
            translate([0,0,-lid_unoffset])
            linear_extrude(0.01)
            sliderCaseSolid2D();
        }
        hull() {
            translate([0,0,-0.01+screw_spot_len])
            linear_extrude(0.01)
            offset(lid_extra_offset)
            sliderCaseSolid2D(lid_unoffset);
            translate([0,0,-0.01+screw_spot_len-lid_extra_offset])
            linear_extrude(0.01)
            sliderCaseSolid2D(lid_unoffset);
        }
    }
}

module m3_screw() {
    translate([0,0,-m3_shaft_len])
    union() {
    translate([0,0,m3_shaft_len])
    linear_extrude(m3_head_len)
    circle(m3_head_dia/2);
    linear_extrude(m3_shaft_len)
    circle(m3_shaft_dia/2);
    }
}
//translate([20,0,0])
//m3_screw();

module screwHoles() {
    for (i=[0:num_rods-1]) {
        rotate([0,0,i*360/num_rods])
        translate([slider_dia/2,0,min_rod_len])//-wall_thick/2])
        m3_screw();
    }
}
//screwHoles();

module screwHoles2D() {
    for (i=[0:num_rods-1]) {
        rotate([0,0,i*360/num_rods])
        translate([slider_dia/2,0])//-wall_thick/2])
        circle(d=m3_shaft_dia);
    }
}

module sliderCase3D() {
    linear_extrude(wall_thick)
    sliderCaseSolid2D();
    linear_extrude(min_rod_len-wall_thick)
    sliderCaseWalls2D();
    sliderCaseScrewSpots();
}
//#sliderCase3D();

module sliderCaseCut3D() {
    difference() {
        sliderCase3D();
        translate([0,0,wall_thick])
        linear_extrude(min_rod_len)
        offset(-wall_thick)
        sliderCaseSolid2D();
        screwHoles();
        linear_extrude(wall_thick) {
            rodHoles2D();
            circle(d=pen_head_dia);
        }
    }
}
//#sliderCaseCut3D();

module sliderCaseLid2D() {
    offset(lid_extra_offset)
    sliderCaseSolid2D(lid_unoffset);
}

module cutSliderCaseLid2D() {
    difference() {
        sliderCaseLid2D();
        rodHoles2D();
    }
}

module sliderCaseLid3D() {
    linear_extrude(wall_thick)
    cutSliderCaseLid2D();

    //translate([0,0,-min_spring_len/2]) {
    rotate([180,0,0]) {
        cylinder(d=spring_inner_dia, h=min_spring_len/2);
        fillet(fillet_rad, spring_inner_dia/2, true, false);
    }
}

module cutSliderCaseLid3D() {
    difference() {
        translate([0,0,min_rod_len-wall_thick])
        sliderCaseLid3D();
        translate([0,0,min_rod_len-wall_thick-min_spring_len/2])
        linear_extrude(wall_thick+min_spring_len/2)
        circle(d=pen_shaft_dia);
        screwHoles();
    }
}
//cutSliderCaseLid3D();

//$fn=4;
module printableSpring() {
    #tpuSpring(spring_inner_dia+4, spring_inner_dia+0.8, desired_spring_len, 0.8, 5);
}
printableSpring();

module completeAssembly() {
    difference() {
        union() {
            #sliderCaseCut3D();
            color("orange")
            #cutSliderCaseLid3D();
            color("yellow")
            translate([0,0,wall_thick])
            slider3D();
            translate([0,0,wall_thick+slider_len])
            printableSpring();
        }
        cube(150);
    }
}
//completeAssembly();
//tpuSpring(spring_inner_dia+3, spring_inner_dia, desired_spring_len, 0.8, 5);

module printable() {
    sliderCaseCut3D();

    translate([-slider_dia, 0, min_rod_len])
    rotate([180,0,180])
    cutSliderCaseLid3D();
    translate([slider_dia/2, slider_dia, 0])
    rotate([0,0,60])
    slider3D();
}
//printable();

