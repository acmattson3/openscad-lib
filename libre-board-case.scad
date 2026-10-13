// Libre Computer Board Case
$fn=60;
board_len = 85.0;
board_wid = 56.0;
board_thick = 1.3;
rounding_len = 2;
screw_dia = 2.65;
screw_offset = 3.5;
mid_screw_dist = 61.5-(board_len/2);

micro_usb_wid = 7.0;
micro_usb_ht = 1.9;
micro_usb_offset = 10.5; // From corner

hdmi_wid = 16.4;
hdmi_ht = 6.5;
hdmi_offset = 32.0; // From corner

module wantRect(l, w) {
    translate([-l/2,-w/2,0])
    square([l, w]);
}

module wantCirc(r) {
    circle(r);
}

module boardBody() {
    offset(rounding_len) offset(-rounding_len)
    wantRect(board_len, board_wid);
}

module screwHoles() {
    translate([mid_screw_dist-screw_offset, board_wid/2-screw_offset]) 
    wantCirc(screw_dia/2);
    translate([-(board_len/2-screw_offset), board_wid/2-screw_offset]) 
    wantCirc(screw_dia/2);
    translate([-(board_len/2-screw_offset), -(board_wid/2-screw_offset)]) 
    wantCirc(screw_dia/2);
    translate([mid_screw_dist-screw_offset, -(board_wid/2-screw_offset)]) 
    wantCirc(screw_dia/2);
}

module screwHoleBoard() {
    difference() {
        boardBody();
        screwHoles();
    }
}


module screwHoleBoard3D() {
    linear_extrude(board_thick) 
    screwHoleBoard();
}

module microUSBPort() {
    translate([micro_usb_offset, 3.0, board_thick])
    linear_extrude(micro_usb_ht)
    wantRect(micro_usb_wid, 6.0);
}

module hdmiPort() {
    translate([hdmi_offset, 3.0, board_thick])
    linear_extrude(hdmi_ht)
    wantRect(hdmi_wid, 6.0);
}


translate([board_len/2, board_wid/2])
screwHoleBoard3D();
#microUSBPort();
#hdmiPort();