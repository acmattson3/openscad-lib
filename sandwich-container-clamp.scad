// Sandwich Container Clamp

$fn = 32;

connection_bar_dia = 2.75;
connection_bar_len = 4.37;
connection_bar_dist = 54.06; // From their closest ends
connection_bar_outline_dia = 5.15;
connection_bar_outer_thick = 4.0;

rounding = 5;
plate_thick = 2.0;
plate_angle = 75; // Degrees from bottom plate to back plate
bottom_plate_wid = 10.0;
bottom_plate_len = connection_bar_dist;
top_plate_len = connection_bar_dist + 2*connection_bar_len + 2*connection_bar_outer_thick;
top_plate_wid = 21.0;

clip_bottom_dist = 12.5; // Distance from bottom plate to clip that grabs the top of the container
clip_bump_dia = 0.4*2; // The semicircle bump that snaps it in
clip_len = 9.9;
clip_wid = 3.3;
clip_dist = 40.3;

module bottomPlate() {
    linear_extrude(plate_thick)
    square([bottom_plate_len, bottom_plate_wid], center=true);
}

module clipTab() {
    translate([0,0,plate_thick])
    rotate([90,-90,0])
    union() {
        translate([clip_wid/2,0,-plate_thick/2]) {
            linear_extrude(plate_thick)
            square([clip_wid, clip_len], center=true);
        }
        rotate([90,0,0])
        translate([clip_wid-clip_bump_dia,plate_thick/2,-clip_len/2])
        linear_extrude(clip_len)
        circle(d=clip_bump_dia*2);
    }
}

module topPlate() {
    translate([0,bottom_plate_wid/2,0])
    rotate([plate_angle,0,0])
    translate([0,top_plate_wid/2,0]) {
        linear_extrude(plate_thick)
        offset(rounding) offset(-rounding)
        square([top_plate_len, top_plate_wid], center=true);
        translate([clip_dist/2+clip_len/2,clip_bottom_dist-bottom_plate_wid+plate_thick/2,0])
        clipTab();
        translate([-clip_dist/2-clip_len/2,clip_bottom_dist-bottom_plate_wid+plate_thick/2,0])
        clipTab();
    }
}

module connectionBar(one_side=false) {
    translate([0,0,connection_bar_outline_dia/2])
    rotate([90,0,90])
    translate([0,0,-connection_bar_len/2-connection_bar_outer_thick])
    union() {
        linear_extrude(connection_bar_outer_thick)
        offset(connection_bar_outline_dia/2)
        square([bottom_plate_wid, 0.01], center=true);
        
        if (!one_side) {
        translate([-bottom_plate_wid/2,0,connection_bar_outer_thick])
        linear_extrude(connection_bar_len)
        circle(d=connection_bar_dia);
        
        translate([0,0,connection_bar_outer_thick+connection_bar_len])
        linear_extrude(connection_bar_outer_thick)
        offset(connection_bar_outline_dia/2)
        square([bottom_plate_wid, 0.01], center=true);
        }
    }
}

module finalClamp() {
    topPlate();
    hull() {
        bottomPlate();
        translate([connection_bar_dist/2+connection_bar_len/2,0,0])
        connectionBar(true);
    }
    hull() {
        bottomPlate();
        translate([-(connection_bar_dist/2+connection_bar_len/2),0,0])
        rotate([0,0,180])
        connectionBar(true);
    }
    translate([connection_bar_dist/2+connection_bar_len/2,0,0])
    connectionBar();
    translate([-(connection_bar_dist/2+connection_bar_len/2),0,0])
    connectionBar();
    translate([0,bottom_plate_wid/2,connection_bar_outline_dia/2])
    rotate([0,90,0])
    translate([0,0,-top_plate_len/2])
    cylinder(d=connection_bar_outline_dia, h=top_plate_len);
}

finalClamp();