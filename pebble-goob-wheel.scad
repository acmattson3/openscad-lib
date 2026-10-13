// Pebble GOOB Multimaterial Wheel

$fn = 128;

// Motor Shaft
axle_shaft_dia = 3.15;
axle_key_dia = 2.75;
axle_shaft_len = 6.5;
axle_base_dia = 22.0;
axle_base_len = 11.5;

// Magnet ring
magnet_dia = 5.0;
magnet_h = magnet_dia+0.4;
num_magnets = 10;

// Tire
tire_outer_dia = 54.6+8.0;
tire_inner_dia = 35.0-1.0;
tire_h = 19.0;//7.5;
tire_rounding = 2.0;//3.5;

// Tire Notch
notch_thick = (tire_outer_dia-tire_inner_dia)/(2*5);
notch_t_wid = 1.0*notch_thick;
notch_t_h = notch_thick/1.4;
num_notches = 3;
notch_rounding = 0.25;
notch_h = tire_h;

// Tire Tread
tire_tread_num = 20;
tire_tread_inset = (tire_outer_dia-tire_inner_dia)/10;
tread_h = tire_h;
tread_divisor = 6;

module tire2D() {
    difference() {
        circle(d=tire_outer_dia);
        circle(d=tire_inner_dia);
    }
}

module cylindricalTire() {
    linear_extrude(tire_h)
    tire2D();
}
//cylindricalTire();

// Provides mechanical connection between tire and hub
module tireNotch2D() {
    assert(notch_t_wid >= notch_thick);
    translate([0,tire_inner_dia/2+notch_thick/2-notch_t_h,0]) {
        hull() {
            translate([notch_t_wid-notch_thick, -notch_t_h])
            circle(d=notch_thick);
            translate([-(notch_t_wid-notch_thick), -notch_t_h])
            circle(d=notch_thick);
        }
        hull() {
            square(notch_thick, center=true);
            translate([0, -notch_t_h])
            square(notch_thick, center=true);
        }
        translate([0, -notch_t_h])
        square(notch_thick, center=true);
    }
}
//tireNotch2D();

module tireNotches() {
    translate([0,0,(tire_h-notch_h)/2])
    // notch section
    for (i=[0:num_notches-1]) {
        rotate([0,0,i*360/num_notches])
        //linear_extrude(tire_h)
        difference() {
            linear_extrude(notch_h) 
            tireNotch2D();
            //translate([0,0,tire_h/2])
            rotate([45,0,0])
            cube(tire_inner_dia/1.4, center=true);
            translate([0,0,tire_h])
            rotate([45,0,0])
            cube(tire_inner_dia/1.4, center=true);
        }
    }
}

module hub() {
    difference() {
        union() {
            translate([0,0,(tire_h-notch_h)/2])
            // notch section
            linear_extrude(notch_h) 
            circle(d=tire_inner_dia);
            // non-notch sections
            linear_extrude((tire_h-notch_h)/2)
            circle(d=tire_inner_dia);
            translate([0,0,notch_h+(tire_h-notch_h)/2])
            linear_extrude((tire_h-notch_h)/2)
            circle(d=tire_inner_dia);
        }
        //translate([0,0,(tire_h-notch_h)/2])
        // notch section
        tireNotches();
        //linear_extrude((tire_h-notch_h)/2)
        //tireNotches2D();
    }
}

module tireTread() {
    angle_takeup = 360/tire_tread_num;
    // The length of each piece of tread
    section_len = tire_outer_dia*sin(angle_takeup/2);
    r_squared = (tire_outer_dia/2)*(tire_outer_dia/2);
    half_l_squared = (section_len/2)*(section_len/2);
    section_dist = sqrt(r_squared-half_l_squared);
    translate([0,section_dist,(tire_h-tread_h)/2.0])
    linear_extrude(tread_h)
    polygon([
        [-section_len/tread_divisor, 0],
        [0, -tire_tread_inset],
        [section_len/tread_divisor, 0],
        [section_len/tread_divisor, 2*(tire_outer_dia/2-section_dist)],
        [-section_len/tread_divisor, 2*(tire_outer_dia/2-section_dist)]
    ]);
}
//tireTread();

module tireTreads() {
    for (i=[0:tire_tread_num]) {
        rotate([0,0,i*360/tire_tread_num])
        tireTread();
    }
}
//tireTreads();

module roundedTire() {
    assert(2*tire_rounding < tire_h);
    union() {
    difference() {
        union() {
            translate([0,0,tire_rounding])
            minkowski() {
                linear_extrude(tire_h-2*tire_rounding)
                circle(d=tire_outer_dia-2*tire_rounding);
                sphere(r=tire_rounding);
            }
            tireNotches();
        }
        hub();
        tireTreads();
        //magnetHoles();
    }
    }
}

module hubAxleHole() {
    linear_extrude(axle_base_len)
    circle(d=axle_base_dia);
    translate([0,0,axle_base_len])
    linear_extrude(axle_shaft_len)
    intersection() {
        circle(d=axle_shaft_dia);
        translate([0,(axle_shaft_dia-axle_key_dia)/2])
        square([axle_shaft_dia, axle_key_dia], center=true);
    }
}
//hubAxleHole();

text_h = 0.2;
hub_text = "GOOB";
text_boldness = 0.0;
module hubText() {
    translate([0,0,tire_h-text_h])
    linear_extrude(text_h)
    offset(text_boldness)
    text(hub_text, tire_inner_dia/3, halign = "center", valign = "center", font = "rockwell condensed");
}

module magnetHoles() {
    union() {
    for (i=[0:num_magnets-1]) {
        rotate([0,0,360/num_magnets*i])
        linear_extrude(magnet_h)
        translate([((tire_inner_dia/2)+(axle_base_dia/2))/2,0,0])
        circle(d=magnet_dia);
    }
    }
}

module cutHub() {
    union() {
    difference() {
        hub();
        hubAxleHole();
        hubText();
        //magnetHoles();
    }
    }
}

module tireAndHub() {
    roundedTire();
    color("#662222")
    cutHub();
}

module displayTireAndHub() {
    difference() {
        tireAndHub();
        cube(100);
    }
}

//roundedTire();
//cutHub();
displayTireAndHub();