// Head candle mold

wall_thick = 0.4;

translate([0,0,wall_thick])
minkowski() {
    import("../andrew-head.stl");
    sphere(r=wall_thick);
}