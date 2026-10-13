// Shower handle extender
$fn = 48;

handle_base_lower_d = 20.55;
handle_base_upper_d = 22.7;
hose_d = 12;
handle_base_len = 24.0;
handle_holder_thick = 5.0;
extension_len = 120.0;
handle_angle = 30;

module handle(extra_d=0, extra_h=0, cut=false, ball=true) {
    difference() {
        union() {
            rotate([0,handle_angle,0]) {
                cylinder(h=handle_base_len, d1=handle_base_lower_d+extra_d, d2=handle_base_upper_d+extra_d);
                if (extra_h > 0) {
                    translate([0,0,handle_base_len])
                    #cylinder(h=extra_h, d=handle_base_upper_d+extra_d);
                }
            }
            if (ball) sphere(d=handle_base_lower_d+extra_d);
        }
        if (cut) {
            rotate([0,handle_angle,0])
            translate([handle_base_upper_d/2+2.8*handle_holder_thick,0,handle_base_len/2-0.05])
            #cube([handle_base_upper_d+2*handle_holder_thick, handle_base_upper_d+2*handle_holder_thick, handle_base_len+0.12], center=true);
        }
    }
}
translate([0,0,extension_len])
handle(extra_d=-1);
translate([handle_holder_thick,0,0])
difference() {
    union() {
        translate([-handle_holder_thick,0,0])
        cylinder(d2=hose_d, d1=handle_base_lower_d, h=extension_len);
        //handle(extra_d=handle_holder_thick*2, cut=true);
    }
    #handle(extra_d=handle_holder_thick*2, cut=true, extra_h=25);
    handle(extra_h=15, extra_d=0.8);
    translate([0,0,-50])
    cube(100, center=true);
}
translate([handle_holder_thick,0,0])
difference() {
handle(extra_d=handle_holder_thick*2, cut=true);
handle(extra_h=15, extra_d=0.8);
    translate([0,0,-50])
    cube(100, center=true);
}