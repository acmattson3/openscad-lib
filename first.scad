
module movingPart(s) {
    wantCube=0;
    if (wantCube) {
        cube([s,s,s]);
    } else {
        translate([s/2,s/2,0])
            cylinder(d=s,h=s); 
    }
    
    
}

translate([0,0,0]) {
    movingPart(12);
}

translate([20,0,0]) {
    movingPart(8);
}