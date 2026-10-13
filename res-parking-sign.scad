// Resident parking sign

$fn = 32;

text_h = 0.4;
sign_thick = 2;
sign_wid = 200;
sign_len = 160;


screw_head_dia = 6.65;
screw_head_h = 2.35;
screw_shaft_len = 11.43;
screw_shaft_dia = 3.2;
module screw() {
    translate([0,0,0])
    cylinder(d=screw_head_dia, h=screw_head_h);
    translate([0,0,-screw_shaft_len])
    cylinder(d=screw_shaft_dia, h=screw_shaft_len);
}
//screw();

module sign_text() {
    offset(0.5)
    text("Resident", halign="center");
    translate([0,-15])
    offset(0.5)
    text("Parking Only", halign="center");
}

module disclaimer() {
    offset(0.2)
    text("Violators will be", halign="center");
    translate([0,-15])
    offset(0.2)
    text("towed at owner's", halign="center");
    translate([0,-30])
    offset(0.2)
    text("expense.", halign="center");
}

module final_sign() {
color("#808080")
linear_extrude(sign_thick)
offset(30) offset(-30)
square([sign_wid, sign_len], center=true);
translate([0,45,sign_thick])
color("#ffff00")
linear_extrude(text_h)
scale(2)
sign_text();
translate([0,-15,sign_thick])
color("#ffff00")
linear_extrude(text_h)
scale(1.5)
disclaimer();
}

difference() {
    final_sign();
    translate([0,sign_len/2-screw_head_dia,sign_thick/2])
    screw();
    translate([0,-(sign_len/2-screw_head_dia),sign_thick/2])
    screw();
}