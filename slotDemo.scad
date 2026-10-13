$fs=0.1;
$fa=2;

// Outline of the moving part
// Coord system: 0,0 is center of part in XY,
// z=0 is base plate
module movingPart2D(s) {
    wantSquare=0;
    if (wantSquare) {
        translate([-s/2,-s/2,0]) // move to center
            square([s,s]);
    } else {
        //translate([s/2,s/2,0])
        circle(d=s,$fn=60); 
    }
}

pinSize=10;

// Path of the pin through the slot
path=[
    [0,0,0], // origin
    // arc points!
    for (angle=[0:$fa:90]) 
        25*[sin(angle),cos(angle),0],
    [45,-10,0], // far
];

module slot() {
    linear_extrude(height=pinSize,convexity=4) slot2D();
}

wall=2;
plateThick=8;
module plate2D() {
    difference() {
        hull() offset(r=wall) {
            slot2D();
            boltHoles2D();
        }
        boltHoles2D();
    }
}

// Set of bolt holes
boltHoles=[
    [15,-10],
    [40,10],
    [-15,25]
];

module boltHoles2D() {
    for (b=boltHoles) translate(b) circle(d=1/4*inch);
}

module slot2D() {
// i=[0:len(path)-2] -> i iterates over all values from zero to bound (len(path)-2)
for (i=[0:len(path)-2]) {
    hull() {
        for (di=[0:1]) {
        translate(path[i+di]) {
            movingPart2D(pinSize);
        }
    }
}
}
}

inch = 25.4;
module plate() {
    //translate([-8,-8,0])
        //cube([60,40,6]);
    linear_extrude(height=plateThick)
    difference() {
        hull() offset(r=wall) {
            slot2D();
            boltHoles2D();
        }
        boltHoles2D();
    }
    
}

module slottedPlate() {
    difference() {
        plate();
        translate([0,0,-0.1]) slot();
    }
}

slottedPlate();