module wantRect(l, w) {
    translate([-w/2,-l/2,0])
        square([w, l]);
}

module wantCirc(r) {
    circle(d=r*2,$fn=60);
}

