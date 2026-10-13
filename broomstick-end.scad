// Broom handle end (rag holder)
$fn = 48;

thread_wid = 2.8+0.6;
rod_dia = 15.5+0.6;
rod_h = 25.0+3.0; 
rod_base_dia = rod_dia+thread_wid;
rod_base_h = 6.1;

// 17.5 is four threads and three spaces
//                  four threads  three spaces
thread_dist = (17.5-thread_wid*4)/3;

rev_h = thread_dist+thread_wid;
num_revs = 5;


module threadBallHelper(rot, h) {
    rotate([0,0,rot])
    translate([rod_dia/2,0,h])
    sphere(d=thread_wid);
}

module broomEnd() {
    // Base
    cylinder(d=rod_base_dia, h=rod_base_h);
    // Smoothing
    translate([0,0,rod_base_h])
    cylinder(d2=rod_dia, d1=rod_base_dia, h=(rod_base_dia-rod_dia)/2);
    // Rod
    cylinder(d=rod_dia, h=rod_h);
    
    difference() {
    translate([0,0,rod_base_h-thread_wid/2])
        for (i=[0:num_revs-1]) {
            base_h = rev_h*i;
            for (j=[0:$fn-1]) {
                curr_rot = (360/$fn)*j;
                curr_h = base_h+(rev_h/$fn)*j;
                next_rot = (360/$fn)*(j+1);
                next_h = base_h+(rev_h/$fn)*(j+1);
                hull() {
                    threadBallHelper(curr_rot, curr_h);
                    threadBallHelper(next_rot, next_h);
                }
            }
        }
        translate([0,0,rod_h])
        linear_extrude(50)
        square(50, center=true);
    }
}
//broomEnd();

module testEnd() {
    difference() {
        cylinder(d=rod_base_dia+1, h=rod_h+1);
        broomEnd();
        //cube(100);
    }
}
//testEnd();

module strongEnd(thick) {
    difference() {
        cylinder(d=rod_base_dia+2*thick, h=rod_h+thick);
        broomEnd();
        //cube(100);
    }
}

rag_len = 150;
rag_wid = rag_len;
block_thick = 11.0;
base_thick = 8.0;
rag_overlap = 12.0;
corner_rounding = 2.0;
end_thick = 3.0;
downshift = 12.5;
end_angle = 45;
base_block_len = rag_len-rag_overlap-block_thick;
hull_dist = base_block_len/2;


module ragEndBaseScrewless() {
    linear_extrude(base_thick)
    offset(corner_rounding) offset(-corner_rounding)
    square([base_block_len,rag_wid], center=true);
    difference() {
        hull() {
            linear_extrude(base_thick)
            offset(corner_rounding) offset(-corner_rounding)
            translate([-hull_dist/2+hull_dist-base_block_len/2,0,0])
            square([hull_dist,rag_wid], center=true);
            translate([-base_block_len/2,0,-downshift])
            rotate([0,end_angle,0])
            translate([0,0,-(rod_h+end_thick)/2])
            cylinder(h=rod_h, d=2*end_thick+rod_base_dia);
        }
        translate([-base_block_len/2,0,-downshift])
        rotate([0,end_angle,0])
        translate([0,0,-(rod_h+end_thick)/2])
        cylinder(h=rod_h, d=2*end_thick+rod_base_dia);
    }
}
//ragEndBaseScrewless();

screw_h = 18.0;
screw_head_h = 4.0;
screw_head_dia = 10.2+0.6;
screw_shaft_h = screw_h-screw_head_h;
screw_thread_dia = 5.6;
screw_shaft_dia = 4.0;
module screwHoleBase() {
    cylinder(h=screw_h, d=screw_thread_dia);
    cylinder(h=screw_head_h, d1=screw_head_dia, d2=screw_thread_dia);
    translate([0,0,-30])
    cylinder(d=screw_head_dia, h=30);
}
//screwHoleBase();

screw_x_shift = base_block_len/2-screw_head_dia/2-2*rag_overlap;
screw_y_shift = rag_wid/2-screw_head_dia;

module screwHolesBase() {
    translate([screw_x_shift, screw_y_shift])
    screwHoleBase();
    translate([-screw_x_shift, screw_y_shift])
    screwHoleBase();
    translate([screw_x_shift, -screw_y_shift])
    screwHoleBase();
    translate([-screw_x_shift, -screw_y_shift])
    screwHoleBase();
}

module screwHoleBlock() {
    cylinder(h=block_thick-0.8, d=screw_shaft_dia);
}

module screwHolesBlock() {
    translate([screw_x_shift, screw_y_shift])
    screwHoleBlock();
    translate([-screw_x_shift, screw_y_shift])
    screwHoleBlock();
    translate([screw_x_shift, -screw_y_shift])
    screwHoleBlock();
    translate([-screw_x_shift, -screw_y_shift])
    screwHoleBlock();
}

module ragEndBase() {
    difference() {
        ragEndBaseScrewless();
        screwHolesBase();
    }
    translate([-base_block_len/2,0,-downshift])
    rotate([0,end_angle,0])
    translate([0,0,-(rod_h+end_thick)/2])
    strongEnd(end_thick);
}
//rotate([0,180,0])
//ragEndBase();

module squarynder(h, d) {
    rotate([0,0,90])
    union() {
        cylinder(h=h, d=d);
        translate([-d/4,0,h/2])
        cube([d/2,d,h], center=true);
    }
}
//squarynder(5,5);

module ragEndBlock() {
    difference() {
        translate([0,0,block_thick/2])
        hull() {
            translate([base_block_len/2-block_thick/2,0,0])
            rotate([90,0,0])
            translate([0,0,-rag_wid/2])
            squarynder(h=rag_wid, d=block_thick);
            translate([-(base_block_len/2-block_thick/2),0,0])
            rotate([90,0,0])
            translate([0,0,-rag_wid/2])
            squarynder(h=rag_wid, d=block_thick);
        }
        //linear_extrude(block_thick)
        //offset(corner_rounding) offset(-corner_rounding)
        //square([base_block_len,rag_wid], center=true);
        #screwHolesBlock();
    }
}
//ragEndBlock();

// Rag wraps around block on two edges (the top and bottom
// two), and the base clamps the rag between the base and
// the block.
module ragEndShowcase() {
    ragEndBase();
    translate([0,0,base_thick+10.0])
    ragEndBlock();
    
}
ragEndShowcase();

























