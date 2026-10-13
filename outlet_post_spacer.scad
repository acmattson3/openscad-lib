// Wobbly outlet spacer post

$fn = 32;

outlet_screw_dia = 3.65;
post_dia = outlet_screw_dia + 3.6*2;
post_h = 15.0;

intersection() {
    linear_extrude(post_h)
    difference() {
        circle(d=post_dia);
        circle(d=outlet_screw_dia);
    }
    translate([1,0,post_h/2])
    cube([post_dia-2, post_dia, post_h], center=true);
}