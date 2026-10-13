// Radius gauges, with positives and negatives

$fn = 64;

rad_min = 1;
rad_max = 10;
rad_step = 1;

num_steps = ((rad_max-rad_min+1)/rad_step);
//echo(num_steps);

disc_d = 60;
disc_thick = 2;

function rad_at(i) = rad_min + i*rad_step;
function angle_weight(i) = asin(rad_at(i)/(disc_d/2));
function sum(v, i=0) = i >= len(v) ? 0 : v[i] + sum(v, i+1);

weights_total = sum([for (i=[0:num_steps-1]) angle_weight(i)]);

module disc2D() {
    circle(d=disc_d);
}

module negativeDisc2D() {
    difference() {
        disc2D();
        for (i=[0:num_steps-1]) {
            curr_rad = rad_min+i*rad_step;
            curr_angle = 360 * (
                sum([for (j=[0:i-1]) angle_weight(j)]) + angle_weight(i)/2
            ) / weights_total;
            //echo(curr_rad);
            rotate([0,0,curr_angle])
            translate([0,disc_d/2+curr_rad/2]) {
                #circle(r=curr_rad);
            }
        }
    }
}
//negativeDisc2D();

module positiveDisc2D() {
    union() {
        disc2D();
        for (i=[0:num_steps-1]) {
            curr_rad = rad_min+i*rad_step;
            curr_angle = 360 * (
                sum([for (j=[0:i-1]) angle_weight(j)]) + angle_weight(i)/2
            ) / weights_total;
            //echo(curr_rad);
            rotate([0,0,curr_angle])
            translate([0,disc_d/2-curr_rad/2]) {
                #circle(r=curr_rad);
            }
        }
    }
}

module textCutoutNegative2D() {
    for (i=[0:num_steps-1]) {
        curr_rad = rad_min+i*rad_step;
        curr_angle = 360 * (
            sum([for (j=[0:i-1]) angle_weight(j)]) + angle_weight(i)/2
        ) / weights_total;
        //echo(curr_rad);
        rotate([0,0,curr_angle])
        translate([0,disc_d/2-curr_rad/2]) {
            translate([0,-3])
            text(str(curr_rad), size = 2, halign="center");
        }
    }
}
//textCutoutNegative2D();

module textCutoutPositive2D() {
    for (i=[0:num_steps-1]) {
        curr_rad = rad_min+i*rad_step;
        curr_angle = 360 * (
            sum([for (j=[0:i-1]) angle_weight(j)]) + angle_weight(i)/2
        ) / weights_total;
        //echo(curr_rad);
        rotate([0,0,curr_angle])
        translate([0,disc_d/2+curr_rad/2]) {
            translate([0,-3])
            text(str(curr_rad), size = 2, halign="center", valign="bottom");
        }
    }
}
//#textCutoutPositive2D();

module positiveDisc() {
    difference() {
        linear_extrude(disc_thick)
        positiveDisc2D();
        translate([0,0,disc_thick-0.4])
        linear_extrude(0.4)
        textCutoutPositive2D();
    }
}
//positiveDisc();

module negativeDisc() {
    difference() {
        linear_extrude(disc_thick)
        negativeDisc2D();
        translate([0,0,disc_thick-0.4])
        linear_extrude(0.4)
        textCutoutNegative2D();
    }
}
negativeDisc();