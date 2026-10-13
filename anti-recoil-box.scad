// Anti-Recoil Device Case

$fn = 32;

board_len = 71.0;
board_wid = 66.0;
boards_h = 35.5;

wall_thick = 1.6;
rounding = 1.6;

potent_dia = 7.2;
potent_x = 38.5-3.5+7.3-potent_dia/2; // Distance to USB-facing side
potent_z = 14.3-2.75; // Distance to center of dial knob
potent_len = 15.0; // Length of knob shaft

led_dia = 5.3;
led_h = 7.5;
led_dist = 6.5; // Distance between the LEDs' edges
led_center_dist = led_dist + led_dia;
led_x = 55.0;
led_y = 18.75; // Distance from the left (-y) side

button_len = 6.1;
button_wid = button_len;
button_h = 3.0;
pimple_h = 1.0;
button_cap_h = 12.0 - pimple_h; // Length of button cap shaft
button_cap_len = button_len + 2.0; 
button_cap_wid = button_cap_len;
button_cap_rounding = 1.0;
button_cap_spacing = 0.1;

button_x = 3.0+button_len/2+1;
button_y = 52.9-button_len/2+2; // Distance from -y wall
rec_button_y = 19.5+button_len+3; // Anti-recoil toggle distance from reset
rec_button_x = 13.0+button_len-0.5;

micro_usb_len = 6.0;
micro_usb_wid = 8.2;
micro_usb_h = 3.5;
micro_usb_y = 1.0+18.5-micro_usb_wid/2;
micro_usb_z = 6.3-micro_usb_h;

usb_len = 10.0;
usb_wid = 15.0;
usb_h = 7.0;
usb_y = 24.75+usb_wid/2;
usb_z = 15.0-usb_h;

power_jack_len = 14.5;
power_jack_wid = 9.0;
power_jack_h = 11.0;
power_jack_y = 40.8+power_jack_wid/2;
power_jack_z = 14.3-power_jack_h;

module caseBox() {
    linear_extrude(boards_h+2*wall_thick)
    offset(rounding) offset(-rounding)
    square([board_len+2*wall_thick, board_wid+2*wall_thick], center=true);
}

module caseVoid() {
    translate([0,0,wall_thick])
    linear_extrude(boards_h)
    square([board_len, board_wid], center=true);
}

module caseHollow() {
    difference() {
        caseBox();
        caseVoid();
    }
}

module potentHole() {
    translate([board_len/2-potent_x,board_wid/2-potent_len/2,potent_dia/2+wall_thick+potent_z])
    rotate([-90,0,0])
    cylinder(h=potent_len, d=potent_dia);
}

module ledShape() {
    cylinder(d=led_dia, h=7.5);
}

// Shape is relative to the yellow LED's center
module ledHoles() {
    translate([board_len/2-led_x,led_y-board_wid/2,2*wall_thick+boards_h-led_h/2])
    union() {
        ledShape();
        translate([0, led_center_dist, 0])
        ledShape();
    }
}

module buttonShape() {
    linear_extrude(button_h)
    square([button_len, button_wid], center=true);
}

module buttonCapHole(spacing=0.0) {
    linear_extrude(button_cap_h)
    offset(button_cap_rounding) offset(-button_cap_rounding)
    square([button_cap_len+2*spacing, button_cap_wid+2*spacing], center=true);
}

module buttonCap(spacing=0.0) {
    translate([0,0,-0.6*pimple_h])
    difference() {
    translate([0,0,0.6*pimple_h])
    buttonCapHole(spacing);
    buttonShape();
    }
}

// Shape is relative to the RESET button's center
module buttonCapHoles() {
    translate([board_len/2-button_x,button_y-board_wid/2,2*wall_thick+boards_h-led_h/2]) {
        buttonCapHole(spacing=button_cap_spacing);
        translate([-rec_button_x, -rec_button_y, 0])
        buttonCapHole(spacing=button_cap_spacing);
    }
}

module microUsbHole() {
    translate([board_len/2,micro_usb_y-board_wid/2,wall_thick+micro_usb_z])
    linear_extrude(micro_usb_h)
    square([micro_usb_len, micro_usb_wid], center=true);
}

module usbHole() {
    translate([board_len/2,usb_y-board_wid/2,wall_thick+usb_z])
    linear_extrude(usb_h)
    square([usb_len, usb_wid], center=true);
}

module powerJackHole() {
    translate([board_len/2,power_jack_y-board_wid/2,wall_thick+power_jack_z])
    linear_extrude(power_jack_h)
    square([power_jack_len, power_jack_wid], center=true);
}

//buttonCap();

difference() {
caseHollow();
#potentHole();
#ledHoles();
#buttonCapHoles();
#microUsbHole();
#usbHole();
#powerJackHole();

//cube([50,50,50]);
}