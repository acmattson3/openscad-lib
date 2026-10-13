// Desk hole insert for example workspace

$fn = 128;

hole_dia = 54.2;
hole_depth = 30.0;
lip_len = 10.0;
wall_thick = 0.8;
hole_inner_dia = hole_dia-wall_thick;
lip_max_thick = 0.24;

module insideHole3D() {
    translate([0,0,-hole_depth])
    linear_extrude(hole_depth)
    difference() {
        circle(d=hole_dia);
        circle(d=hole_inner_dia);
    }
}

module holeLip3D() {
    //rotate_extrude() {
        polygon([
            [hole_inner_dia/2, 0], 
            [hole_inner_dia/2+lip_len, 0],
            [hole_inner_dia/2, hole_inner_dia/2+lip_len]
            
        ]);
    //}
}

module holeInsert() {
    union() {
        insideHole3D();
        holeLip3D();
    }
}

holeLip3D();
insideHole3D();