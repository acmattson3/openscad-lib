// T-Shirt Folder Board (2D)

board_len = 300.0;
board_wid = 183.5;
board_rounding = 10.0;
handle_hole_len = 35.0;
handle_hole_wid = 108.0;
handle_hole_top_dist = 57.5;

difference() {
    offset(board_rounding) offset(-board_rounding)
    square([board_len, board_wid]);
    translate([handle_hole_len/2+handle_hole_top_dist,(board_wid-handle_hole_wid)/2+handle_hole_len/2])
    hull() {
        circle(d=handle_hole_len);
        translate([0,handle_hole_wid-handle_hole_len])
        circle(d=handle_hole_len);
    }
}