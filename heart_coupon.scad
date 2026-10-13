$fn = 60;

text_thick = 1;
heart_size = 20;
heart_thick = 2;

module flat_heart() {
  union() {
    // Base square
    square([heart_size, heart_size]);

    // Circle near top-left corner
    translate([heart_size/2, heart_size])
      circle(r = heart_size/2);

    // Circle near top-right corner
    translate([heart_size, heart_size/2])
      circle(r = heart_size/2);
  }
}

//rotate([0,0,-45])
//translate([-13,15,heart_thick])
//linear_extrude(height = text_thick)
//text("Test");
linear_extrude(height = heart_thick)
flat_heart();