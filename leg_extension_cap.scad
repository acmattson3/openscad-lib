leg_bottom_len = 46; // Furniture leg bottom length
leg_bottom_wid = 46; // Furniture leg bottom width
sleeve_len = 30;     // Distance cap slips onto leg
extend_len = 210;    // Leg extension length (0 for cap only)
wall_thick = 4;      // Thickness of cap walls
leg_smoothing = 4;

module wantRect(l, w) {
    translate([-w/2,-l/2,0])
        square([w, l]);
}

module legCapSolid(h=sleeve_len) {
    linear_extrude(h)
        wantRect(leg_bottom_len, leg_bottom_wid);
}

module legCapSolidSmooth(h=sleeve_len) {
    linear_extrude(h)
        offset(leg_smoothing) offset(-leg_smoothing)
        wantRect(leg_bottom_len, leg_bottom_wid);
}

module legCap() {
    scale_x = (leg_bottom_len+(2*wall_thick))/leg_bottom_len;
    scale_y = (leg_bottom_wid+(2*wall_thick))/leg_bottom_wid;
    scale_z = (sleeve_len+(2*wall_thick))/sleeve_len;
    
    difference() {
        scale([scale_x, scale_y, scale_z])
            legCapSolidSmooth();
        translate([0,0,wall_thick])
            legCapSolid(sleeve_len+wall_thick);
    }
}

module legExtension() {
    linear_extrude(extend_len)
        offset(leg_smoothing) offset(-leg_smoothing)
        wantRect(leg_bottom_len, leg_bottom_wid);
}

module capAndExtension() {
    difference() {
    hull() {
        translate([0,0,extend_len])
            legCap();
        legExtension();
    }
    translate([0,0,extend_len+2*wall_thick])
    legCapSolid();
    }
}

//difference() {
if (extend_len)
    capAndExtension();
else
    legCap();
//cube(1000);
//}