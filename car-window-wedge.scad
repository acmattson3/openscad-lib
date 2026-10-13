// Car window wedge

$fn = 64;

wedge_h = 30.0;
wedge_len = 60.0;
wedge_wid = 50.0;
wedge_rounding = 2;

linear_extrude(wedge_wid)
offset(wedge_rounding) offset(-wedge_rounding)
offset(-wedge_rounding) offset(wedge_rounding)
polygon([
    [0, 0],
    [wedge_len, 0],
    [0, wedge_h]
]);
