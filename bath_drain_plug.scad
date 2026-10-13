// Bathtub Drain Plug

plug_seal_len = 1.5; // +/- rib difference
tub_drain_lower_dia = 16.0 - plug_seal_len;
tub_drain_upper_dia = 18.66 - plug_seal_len;
tub_drain_dia_diff = tub_drain_upper_dia - tub_drain_lower_dia;
plug_shaft_len = 16;

// Plug top parameters
has_plug_top = false;
plug_top_upper_dia = tub_drain_upper_dia-plug_seal_len;
plug_top_lower_dia = plug_top_upper_dia*5/3;
plug_top_len = 8;
plug_top_len_ratio = 1;


$fn = 60;

// Make circle given diameter
module wantCirc(dia) {
    circle(dia/2);
}

module wantCyl(lower_dia, upper_dia, height) {
    hull() {
    linear_extrude(0.01)
    wantCirc(lower_dia);
    translate([0, 0, height-0.01])
    linear_extrude(0.01)
    wantCirc(upper_dia);  
    }
}

num_ribs = 10;
rib_res = 5;
pi = 3.14159;
module plugShaft() {
    union() {
    for (i=[0:plug_shaft_len*rib_res]) {
        translate([0,0,-0.01])
        hull() {
        translate([0,0,i/rib_res])
            linear_extrude(0.01)
            wantCirc((tub_drain_lower_dia+(i/(plug_shaft_len*rib_res))*tub_drain_dia_diff) + plug_seal_len*sin( (4*pi*(num_ribs))*(i/rib_res)) );
        translate([0,0,(i+1)/rib_res])
            linear_extrude(0.01)
            wantCirc((tub_drain_lower_dia+(i/(plug_shaft_len*rib_res))*tub_drain_dia_diff) + plug_seal_len*sin( (4*pi*(num_ribs))*((i+1)/rib_res)) );
        }
        //echo(i/rib_res);
    }
}
}

module plugTop() {
    if (has_plug_top) {
    wantCyl(plug_top_upper_dia, plug_top_lower_dia, plug_top_len*(plug_top_len_ratio));
    translate([0,0,plug_top_len*(plug_top_len_ratio)])
    wantCyl(plug_top_lower_dia, plug_top_upper_dia, plug_top_len*(1-plug_top_len_ratio));
    }
}

plugShaft();
translate([0,0,plug_shaft_len])
plugTop();