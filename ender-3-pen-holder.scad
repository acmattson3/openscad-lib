// Pen Holder

$fn = 32;

hex_colors = ["#000000", "#9D5352", "#C7663E", "#BAA961", "#87BD5C", "#4BBD5D", "#328F68", "#4DD1C1", "#292F7D", "#69409C", "#BF4E95"];
text_colors = ["Black", "Red", "Orange", "Yellow", "Lime", "Green", "Turqoise", "Cyan", "Blue", "Purple", "Pink"];
num_colors = 11;

pen_od = 8.87;

screw_shaft_dia = 5.0;
screw_shaft_len = 7.9-4.5;
screw_head_dia = 9.6;
screw_head_len = 3.6;
screw_spacing = 1.4;

holder_section_wid = 15.8;
holder_len = 45.0 + screw_shaft_dia + screw_spacing*2;
holder_h = 6.0;
total_wid = holder_section_wid*num_colors; // Don't change me plez
rounding = 5.0;
font_size = 5.0;
font_spacing = 1.0;
text_inset = 1.0;
boldness = 0.2;

module penHole2D() {
    circle(d=pen_od, $fn=6);
}
//penHole2D();

module penTestFit() {
    linear_extrude(2)
    difference() {
        circle(d=pen_od+4);
        penHole2D();
    }
}
//penTestFit();

module sectionText(num) {
    translate([0,font_spacing/2])
    offset(boldness)
    text(text_colors[num], size=font_size);
    translate([0,-font_size-font_spacing/2])
    offset(boldness)
    text(hex_colors[num], size=font_size);
}
//sectionText(2);

module screwHole() {
    linear_extrude(screw_shaft_len)
    circle(d=screw_shaft_dia);
    translate([0,0,screw_shaft_len])
    linear_extrude(holder_h-screw_shaft_len)
    circle(d=screw_head_dia);
}
//#screwHole();

module screwHoles() {
    screw_offset = screw_head_dia/2+screw_spacing;
    translate([holder_len/2-screw_offset,-total_wid/2+screw_offset,0])
    screwHole();
    translate([holder_len/2-screw_offset,total_wid/2-screw_offset,0])
    screwHole();
}
//#screwHoles();

module penHolder(hex_color, text_color) {
    difference() {
        linear_extrude(holder_h)
        difference() {
            offset(rounding) offset(-rounding)
            square([holder_len, total_wid], center=true);
            for (i=[0:num_colors-1]) {
                translate([-holder_len/2+holder_section_wid/2,-total_wid/2+holder_section_wid/2+i*holder_section_wid])
                penHole2D();
            }
        }
        translate([pen_od/2+font_spacing,0,holder_h-text_inset])
        linear_extrude(text_inset) {
            for (i=[0:num_colors-1]) {
                translate([-holder_len/2+holder_section_wid/2,-total_wid/2+holder_section_wid/2+i*holder_section_wid])
                sectionText(i);
            }
        }
        screwHoles();
    }
}
penHolder();