// Pebble Base Ramps

base_h = 5.7;
base_len = 154.7;
base_wid = 128.3;
ramp_base_dist = base_h*2;

module rampSegment2D() {
    polygon([
        [0, 0],
        [0, ramp_base_dist],
        [base_h, ramp_base_dist]
    ]);
}
rotate([0,-90,0])
linear_extrude(base_len)
rampSegment2D();

translate([0,-ramp_base_dist*2,0])
rotate([0,-90,0])
linear_extrude(base_len)
rampSegment2D();

translate([0,-ramp_base_dist*4,0])
rotate([0,-90,0])
linear_extrude(base_wid)
rampSegment2D();