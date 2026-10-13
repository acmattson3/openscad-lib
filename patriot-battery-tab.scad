// 2013 Keep Patriot Battery Cover Holder Tab

$fn = 64;

hole_wid = 12.0;
hole_len = 6.9;
rounding = 0.85;

module hole2D() {
    offset(rounding) offset(-rounding)
    square([hole_len, hole_wid]);
}




hole2D();