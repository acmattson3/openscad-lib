// Apartment Number Tile

$fn = 16;

character = "XX";
boldness = 1.0;
tile_wid = 30.0;
tile_len = 48.0;
font_size = 30;

screw_head_dia = 6.4;
screw_shaft_dia = 2.95;
screw_head_h = 2.7;
screw_hole_inset = 2.0;

tile_h = 1.96;
letter_h = 0.84; // On top of tile_h
tile_rounding = 2.0;

module screwHole() {
    cylinder(d1=screw_shaft_dia, d2=screw_head_dia, h=screw_head_h);
    
}

module numberTile() {
    color("#f3f3f3")
    linear_extrude(tile_h+letter_h)
    offset(boldness)
    scale([1,1.3])
    text(character, "Arial", halign="center", valign="center", size=font_size);
    color("#333333")
    linear_extrude(tile_h)
    offset(tile_rounding) offset(-tile_rounding)
    square([tile_wid*len(character), tile_len], center=true);
}

difference() {
    numberTile();
    translate([0, (tile_wid)/1.4-screw_hole_inset])
    #screwHole();
}