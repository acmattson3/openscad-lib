// Shower Rod Rubber End

face_lower_dia = 27.6; // Front face diameter
face_thick = 3.8;      // Face (rubber pad) thickness
face_upper_dia = 28.0; // Upper face diameter
rod_dia = 7.6;         // Rod diameter
rod_len = 4.3;         // Lip to rubber pad distance
lip_dia = 9.4;         // Lip diameter
lip_to_tip = 3.2;      // Tip length/lip-tip distance
tip_dia = 5.5;         // Tip diameter

$fn = 60;

module rubberPad() {
    cylinder(d1=face_lower_dia, d2=face_upper_dia, h=face_thick);
}

module rod() {
    translate([0, 0, face_thick])
    linear_extrude(rod_len)
    circle(d=rod_dia);
}

module lipAndTip() {
    translate([0, 0, face_thick + rod_len])
    cylinder(d1=lip_dia, d2=tip_dia, h=lip_to_tip);
}

support_len = 1.5;
module supportedLipAndTip() {
    hull() {
    lipAndTip();
    translate([0, 0, face_thick + rod_len - support_len])
    linear_extrude(0.01)
    circle(d=rod_len);
    }
}

union() {
rubberPad();
hull() {
rod();
supportedLipAndTip();
}
}

