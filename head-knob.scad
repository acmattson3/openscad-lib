$fn = 32;

thread_dia = 6.8;
thread_in_len = 20.6;
shaft_dia = 8.4;
shaft_in_len = 3.4;

difference() {
    scale(0.5)
    translate([0,0,-5])
    import("andrew-head.stl");
    #cylinder(d=thread_dia, h=thread_in_len);
    #cylinder(d=shaft_dia, h=shaft_in_len);
    translate([0,0,-50])
    cube(100, center=true);
}