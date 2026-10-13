// Lobe

$fn=64;

module dShaftBore2D(
    shaft_diameter = 3.0,
    flat_to_round = 2.4,
) {
    d = shaft_diameter;
    r = d / 2;

    flat_x = r - flat_to_round;

    //linear_extrude(height = height, center = true)
        intersection() {
            circle(d = d, $fn = 96);

            translate([flat_x, -d])
                square([2 * d, 2 * d], center = false);
        }
}

module lobedDisc2D(
    lobes = 5,
    diameter = 50,
    variance = 6,
    shaft_diameter = 3.0,
    flat_to_round = 2.4,
    bore_clearance = 0.10,
    points_per_lobe = 40
) {
    points = lobes * points_per_lobe;

    difference() {
        //linear_extrude(height = thickness, center = true)
            polygon([
                for (i = [0 : points - 1])
                    let (
                        a = 360 * i / points,
                        r = diameter / 2 + (variance / 2) * cos(lobes * a)
                    )
                    [r * cos(a), r * sin(a)]
            ]);

        dShaftBore2D(
            shaft_diameter = shaft_diameter,
            flat_to_round = flat_to_round,
        );
    }
}

num_lobes = 5;
disc_d = 60;
lobe_variance = 10;
motor_shaft_d = 3.0;
motor_key_d = 2.6;
bearing_d = 8.7;

translate([-disc_d/2+lobe_variance/2-bearing_d/2,0,0])
circle(d=8.7);

//linear_extrude(5)
lobedDisc2D(
    lobes = num_lobes,
    diameter = disc_d,
    variance = lobe_variance,
    shaft_diameter = motor_shaft_d,
    flat_to_round = motor_key_d,
);