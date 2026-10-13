// Laptop Fill-ins

thick = 1.0;
lip_out = 1.35;

module mainOutline2D() {
//linear_extrude(1)
rotate([0,0,-0.505])
scale(0.26925)
translate([29.25,0,0])
import("laptop_edge-2-plain.svg", center=true);
}

module bezel2D() {
    intersection() {
        mainOutline2D();
        translate([0,-160])
        square([lip_out,320]);
    }
    intersection() {
        mainOutline2D();
        translate([0,-103.4])
        rotate([0,0,-0.6])
        square([320, lip_out]);
    }
    intersection() {
        mainOutline2D();
        translate([-1.4,-100.4])
        rotate([0,0,-0.6-45.0])
        #square([320, lip_out]);
    }
}
//mainOutline2D();

module thing() {
linear_extrude(1.5)
bezel2D();
linear_extrude(thick)
mainOutline2D();
}

//translate([20,0,0])
thing();