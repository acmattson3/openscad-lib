/* Andrew C Mattson
// CS F453 HW0
// Card Holder
//
// Notes:
// I have many modules that build on one
// beginning rectangle. I think I should have
// instead had many modules for the different
// holes and shapes, then joined them together
// in one module (to an extent; the ring
// attachment would be one part made up of
// multiple that would be entirely built
// separately and then unioned later, etc.).
*/

$fs=0.1;
$fa=2;

holderRounding = 3;
sliceRounding = 3;

fingerGapDia = 19.5;
fingerGapLen = 33.5-fingerGapDia;

cardSlotDims = [ // l,w,h
    86.6,
    53.8+5.0, // card rests 5mm inside of holder
    1.1,
];

ringHoleOffset=0;
ringHoleDia=5.0;
ringHoleLen=14.2-ringHoleDia;
ringWallThick=4.0;
ringAttachThick=3;

rimSliceDims = [
    cardSlotDims[0],
    4.0+sliceRounding
];

cardHolderDims = [ // l,w,h
    98.0, 
    62.5,
    5.0
];

module wantRect(l, w) {
    translate([-l/2,-w/2,0])
        square([l, w]);
}

module wantCirc(s) {
    circle(d=s,$fn=60);
}

module cardSlot2D() {
    wantRect(cardSlotDims[0], cardSlotDims[1]);
}

module cardSlot() {
    linear_extrude(height=cardSlotDims[2], convexity=4)
        cardSlot2D();
}

module cardHolder2D() {
    wantRect(cardHolderDims[0], cardHolderDims[1]);
}

module roundedCardHolder2D() {
    offset(r=holderRounding)
    offset(r=-holderRounding)
    cardHolder2D();
}

module cardHolder() {
    linear_extrude(height=cardHolderDims[2], convexity=4)
        roundedCardHolder2D();
}


cardElev=cardHolderDims[2]/2-cardSlotDims[2]/2;
cardOffset=(cardHolderDims[1]-cardSlotDims[1])/2;
module slottedHolder() {
    difference() {
        cardHolder();
        translate([0,cardOffset,cardElev])
            #cardSlot();
    }
}

module fingerGap2D() {
    hull() {
        translate([0,fingerGapLen/2,0])
        wantCirc(fingerGapDia);
        translate([0,-fingerGapLen/2,0])
        wantCirc(fingerGapDia);
    }

}

module fingerGap() {
    linear_extrude(height=cardHolderDims[2]/2, convexity=4)
        fingerGap2D();
}

module fingerGappedHolder() {
    difference() {
        slottedHolder();
        translate([0,cardOffset,cardHolderDims[2]/2])
        fingerGap();
    }
}

module rimSlice2D() {
    translate([0,cardHolderDims[1]/2-rimSliceDims[1]/2+sliceRounding,0])
    wantRect(rimSliceDims[0], rimSliceDims[1]);
}

module rimSlice() {
    translate([0,0,cardHolderDims[2]/2+cardSlotDims[2]/2])
    linear_extrude(height=cardHolderDims[2]/2, convexity=4)
        offset(r=sliceRounding) 
        offset(r=-sliceRounding)
        rimSlice2D();
}

module slicedCardHolder() {
    difference() {
        fingerGappedHolder();
        #rimSlice();
    }
}

module ringHole2D() {
    hull() {
        translate([0,ringHoleLen/2,0])
        wantCirc(ringHoleDia);
        translate([0,-ringHoleLen/2,0])
        wantCirc(ringHoleDia);
    }
}


module ringAttachment2D() {
    difference() {
    difference() {
        hull() {
            roundedCardHolder2D();
            translate([-cardHolderDims[0]/2-ringWallThick-ringHoleOffset,0,0])
            offset(r=ringWallThick)
            ringHole2D();
        }
        translate([-cardHolderDims[0]/2-ringHoleOffset-ringHoleDia,0,0])
        ringHole2D();
    }
    roundedCardHolder2D();
    }
}

module ringAttachment() {
    translate([0,0,cardHolderDims[2]/2-ringAttachThick/2])
    linear_extrude(height=ringAttachThick, convexity=4)
        ringAttachment2D();
}

union() {
slicedCardHolder();
ringAttachment();
}