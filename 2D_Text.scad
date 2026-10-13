// Font configurations
title="COURSE: Example Title:";
body=["CLASS DAYS AND TIMES - TERM - INSTRUCTOR",
      "In ROOM or online:",
      "MEETING LINK",
      "(see course meeting instructions)",
      "OFFICE HOURS use the same meeting link."
];
font_name="Comic Sans MS:style=Bold";
title_size=36;
body_size=36;
line_height=1.5;

// Configurations for slicer
layer_height=0.25;

translate([0,body_size+15,0]) 
linear_extrude(layer_height) {
    translate([0,-5])
    square([768, 5]); // Underline
    text(title, size=title_size, font=font_name);
}


for (i=[0:len(body)-1]) {
    translate([0,-i*body_size*line_height,0])
    linear_extrude(layer_height) 
    text( body[i], font = font_name, size = body_size);
}