$fa=10;
$fs=10;

armLength = 180; // shoulder-to-elbow
shoulderR = 30; // size of shoulder circle
elbowR = 25;
elbowCenter=[armLength, 0, 20];

jointScale = [1, 1, 0.5];

module shrinkableEllipse(r, scale, shrink) {
    shrinkScale=[r*scale[0]-shrink,r*scale[1]-shrink,r*scale[2]-shrink]/r;
    scale(shrinkScale) sphere(r=r);
}

module armOutside(shrink=0) {
    hull() {
        shrinkableEllipse(shoulderR,jointScale,shrink);
        translate(elbowCenter)
            shrinkableEllipse(shoulderR,jointScale,shrink);
    }
}

// 50's style robot
//rotate([0, 90, 0])
//    cylinder(r=0.7*elbowR, h=armLength);

//armOutside();

module armDriveable(shrink=0) {
    difference() {
        armOutside(shrink);
        scale([1, 1, -1])
        translate([0, 0, -shrink])
            cylinder(r=shoulderR+shrink,h=100);
    }
}

module armHollow(outsideShrink, insideShrink) {
    difference() {
        armDriveable(outsideShrink);
        armDriveable(insideShrink);
    }
}

module setOfRibs(ribSpace=12) {
    for (x=[-shoulderR:ribSpace:armLength+elbowR])
        translate([x,0,0]) cube([wall,200,200], center=true);
}

wall=3;
ribs=0.8;
difference() {
    union() {
        armHollow(0, wall);
        intersection() {
            armHollow(wall,ribs);
            setOfRibs();
        }
    }
    cube([100,100,100]);
}