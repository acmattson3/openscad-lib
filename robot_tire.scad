// Spiky TPU tire

$fn = 32;

shaft_flat_dia = 2.5;
shaft_round_dia = 3.0;
shaft_len = 5.25;

tire_inner_dia = 21.0;
tire_outer_dia = tire_inner_dia + 4.0;
tire_h = 15.0;

spike_l = 1.5;
spike_w = 3.0;
tire_spike_dist = tire_h;
num_spikes = 20;
num_spike_layers = 4;
spike_h = tire_spike_dist/num_spike_layers;

module motorShaft() {
    linear_extrude(shaft_len)
    difference() {
        circle(d=shaft_round_dia);
        translate([shaft_flat_dia+shaft_flat_dia/2, 0])
        square([shaft_flat_dia*2, shaft_flat_dia*2], center=true);
    }
}

module tireMotorInterface() {
    difference() {
    cylinder(d=tire_outer_dia, h=shaft_len/1.5);
    motorShaft();
    }
}

module tireSpike() {
    translate([tire_outer_dia/2-0.2, 0, spike_h/2])
    linear_extrude(spike_h/2, scale=0)
    polygon([[0,spike_w/2],[spike_l,0],[0,-spike_w/2]]);
    rotate([180,0,0])
    translate([tire_outer_dia/2-0.2, 0, -spike_h/2])
    linear_extrude(spike_h/2, scale=0)
    polygon([[0,spike_w/2],[spike_l,0],[0,-spike_w/2]]);
}

module tireSpikeRing() {
    for (i=[0:num_spikes]) {
        rotate([0,0,(i/num_spikes)*360])
        tireSpike();
    }
}

module tireTread() {
    for (i=[0:num_spike_layers-1]) {
        rotate([0,0,i*180/num_spikes])
        translate([0,0,i*(tire_spike_dist/num_spike_layers)])
        tireSpikeRing();
    }
}

module tire() {
    tireMotorInterface();
    tireTread();
    difference() {
    cylinder(d=tire_outer_dia, h=tire_h);
    cylinder(d=tire_inner_dia, h=tire_h);
    }
}

tire();