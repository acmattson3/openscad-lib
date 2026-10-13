$fs=0.1;
$fa=2;

rounding = 3;

butterstick_dims = [
    121+9, // l
    121+9, // w
    16     // h (=w)
];

butterdish_bottom_dims = [
    butterstick_dims[0]+20, // l
    butterstick_dims[1]+20, // w
    5.0 // h
];

module wantRect(l, w) {
    translate([-l/2,-w/2,0])
        square([l, w]);
}

module wantCirc(s) {
    circle(d=s,$fn=60);
}

rim_len = (butterstick_dims[0]+butterdish_bottom_dims[0])/2;
rim_wid = (butterstick_dims[1]+butterdish_bottom_dims[1])/2;
module butterdish_bottom2D() {
    #wantRect(butterstick_dims[0], butterstick_dims[1]); // Stick loc
    #offset(r=rounding) offset(r=-rounding)
    wantRect(rim_len, rim_wid); // Rim loc
    offset(r=rounding) offset(r=-rounding)
    wantRect(butterdish_bottom_dims[0], butterdish_bottom_dims[1]); // Dish edge
}


module butterdish_final() {
    linear_extrude(butterstick_dims[2])
    butterdish_bottom2D();
}

module soapdish_final() {
difference() {
butterdish_final();

linear_extrude(butterstick_dims[2]-4)
scale(0.95)
butterdish_bottom2D();
}
}

translate([0, 0, butterstick_dims[2]])
rotate([180, 0, 0])
soapdish_final();