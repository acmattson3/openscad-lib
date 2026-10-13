// Loose solder wire holder

$fn = 32;

holder_len = 32.0;
holder_wid = 25.0;
holder_h = 73.0;
screw_dia = 4.0;
screw_v_offset = 57.0;
screw_h_offset = 34.0;
wall_thick = 1.6;

module holder2D() {
    difference() {
        hull() {
            square([holder_len, holder_h], center=true);
            translate([screw_h_offset-holder_len/2,holder_h/2-screw_v_offset,0])
            offset(wall_thick)
            circle(d=screw_dia);
        }
        translate([screw_h_offset-holder_len/2,holder_h/2-screw_v_offset,0])
        circle(d=screw_dia);
    }
}

module holder3D() {
    difference() {
        linear_extrude(holder_wid)
        holder2D();
        translate([0,wall_thick,holder_wid/2])
        cube([holder_len-2*wall_thick, holder_h-wall_thick, holder_wid-2*wall_thick], center=true);
    }
}

holder3D();