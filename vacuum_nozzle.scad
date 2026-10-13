// Vacuum hose adapter
// For optimal suction, the nozzle's area at any
// slice in the XY plane should remain constant.
// If the area changes, we are constricting/expanding
// the air as it flows, which works against suction.
//
// This model transitions from a circle (pi*r^2) to a
// rounded slot (pi*r^2 + 2*r*l, where l is the slot length).
// 
// So, for constant area, the following must always be true
// across the entire length of the nozzle (using diameters):
// A = pi*(d/2)^2 + l*d   (l is initially zero; just a circle)
// Initially, d = hose_internal_dia
// With known hose_internal_dia, we also know A.
// d can change however we want; just solve for l...
// OR, l changes how we want, and we solve for d.
//
// Below, you see both solutions, and one is clearly optimal.


// Number of discrete steps (OpenSCAD doesn't
// generate true continuous geometry)
$fn=48; 

hose_internal_dia = 40.4; // Starting circle diameter
hose_external_dia = 44.4+0.1; // External hose diameter, plus spacing
attach_overhang_dist = 7.4; // How far we slide onto vacuum hose
wall_thick = 0.6; // == 2.4, or 6 lines with a 0.4mm printer nozzle
nozzle_len = 60.0; // The length of our vacuum nozzle
final_taper_dia = 8.0; // The final desired slot diameter/width
// Transition distance between hose attachment and our nozzle
taper_dist = hose_external_dia-hose_internal_dia;

// Our known, constant area that we must maintain
known_area = PI*hose_internal_dia*hose_internal_dia/4;

// The friction-fitting end; identical in both nozzles.
module hoseAttachment() {
    // Goes over vacuum hose (friction fit)
    linear_extrude(attach_overhang_dist)
    difference() {
        offset(wall_thick)
        circle(d=hose_external_dia);
        circle(d=hose_external_dia);
    }
    
    // Taper quickly to match internal hose diameter
    translate([0,0,attach_overhang_dist])
    difference() {
        hull() { // Bulk
            linear_extrude(0.01) // Bottom
            offset(wall_thick)
            circle(d=hose_external_dia);
            translate([0,0,taper_dist-0.01]) // Top
            linear_extrude(0.01)
            offset(wall_thick)
            circle(d=hose_internal_dia);
        }
        hull() { // Cutout
            linear_extrude(0.01) // Bottom
            circle(d=hose_external_dia);
            translate([0,0,taper_dist-0.01]) // Top
            linear_extrude(0.01)
            circle(d=hose_internal_dia);
        }
    }
}
//hoseAttachment();

// Helper module: A 2D slot, given diameter and distance
// end_dist isn't the true slot length, but rather the 
// distance between the rounded slot end's centers.
module taperSegment2D(taper_dia, end_dist) {
    hull() {
        translate([-end_dist/2,0])
        circle(d=taper_dia);
        translate([end_dist/2,0])
        circle(d=taper_dia);
    }
}

// The tapering portion of the nozzle, with variable diameter.
module hoseTaperDia() {
    // taper_dia will have a final value it approaches while the nozzle
    // approaches nozzle_len.
    
    // Diameter starts at vacuum hose diameter
    initial_taper_dia = hose_internal_dia;
    
    // final_taper_dia already defined globally
    
    // Total change in diameter over whole loop
    delta_taper_dia = initial_taper_dia-final_taper_dia;
    
    // Each discrete nozzle segment's length
    segment_len = nozzle_len/$fn;
    
    // Given $fn, our resolution, break the problem into discrete steps
    for (i=[0:$fn-1]) {
        // The nozzle's current length
        current_total_len = nozzle_len * i/$fn;
        // We decide the current diameter (I chose to be linear)
        current_taper_dia = initial_taper_dia - delta_taper_dia*i/$fn;
        // The diameter at the start of the next step
        next_taper_dia = initial_taper_dia - delta_taper_dia*(i+1)/$fn;
        // Solve for dist at current dia (EASY).
        current_end_dist = (known_area - PI*current_taper_dia*current_taper_dia/4)/current_taper_dia;
        // Solve for the dist at the start of the next step
        next_end_dist = (known_area - PI*next_taper_dia*next_taper_dia/4)/next_taper_dia;
        
        translate([0,0,current_total_len]) // Move segment up
        difference() {
            hull() { // Bulk
                linear_extrude(0.001) // Base
                offset(wall_thick)
                taperSegment2D(current_taper_dia,current_end_dist);
                translate([0,0,segment_len])
                linear_extrude(0.001) // Top
                offset(wall_thick)
                taperSegment2D(next_taper_dia,next_end_dist);
            }
            hull() { // Cutout
                linear_extrude(0.001) // Base
                taperSegment2D(current_taper_dia,current_end_dist);
                translate([0,0,segment_len]) // Top
                linear_extrude(0.001)
                taperSegment2D(next_taper_dia,next_end_dist);
            }
        }        
    }
    
}

// The tapering portion of the nozzle, with variable slot length.
module hoseTaperDist() {
    // end_dist will have a final value it approaches while the nozzle
    // approaches nozzle_len.
    
    // Initially zero; just a circle, so no length.
    initial_end_dist = 0.0;
    
    // Ends at the desired slot diameter, so we solve for final distance.
    final_end_dist = (known_area - PI*final_taper_dia*final_taper_dia/4)/final_taper_dia; 
    
    // Total change in slot distance (same as final_end_dist)
    delta_end_dist = final_end_dist-initial_end_dist;
    
    // Each discrete nozzle segment's length
    segment_len = nozzle_len/$fn;
    
    // Given $fn, our resolution, break the problem into discrete steps
    for (i=[0:$fn-1]) {
        // The nozzle's current length
        current_total_len = nozzle_len * i/$fn;
        // We decide the slot's current length (I chose to be linear)
        current_end_dist = initial_end_dist + delta_end_dist*i/$fn;
        // The dist at the start of the next step
        next_end_dist = initial_end_dist + delta_end_dist*(i+1)/$fn;
        // Solve for dia at current dist (HARD).
        current_taper_dia = 2/PI*(sqrt(current_end_dist*current_end_dist+PI*known_area)-current_end_dist);
        // Solve for the dia at the start of the next step
        next_taper_dia = 2/PI*(sqrt(next_end_dist*next_end_dist+PI*known_area)-next_end_dist);
        
        translate([0,0,current_total_len]) // Move segment up
        difference() {
            hull() { // Bulk
                linear_extrude(0.001) // Base
                offset(wall_thick)
                taperSegment2D(current_taper_dia,current_end_dist);
                translate([0,0,segment_len]) // Top
                linear_extrude(0.001)
                offset(wall_thick)
                taperSegment2D(next_taper_dia,next_end_dist);
            }
            hull() { // Cutout
                linear_extrude(0.001) // Base
                taperSegment2D(current_taper_dia,current_end_dist);
                translate([0,0,segment_len]) // Top
                linear_extrude(0.001)
                taperSegment2D(next_taper_dia,next_end_dist);
            }
        }        
    }
    
}

// Helper: Renders the full adapter where we chose diameter at each step
// Harsh curves on the slot's ends, which probably hurts air flow.
module adapterDia() {
    translate([0,0,attach_overhang_dist+taper_dist])
    hoseTaperDia();
    hoseAttachment();
}
//adapterDia();

// Helper: Renders the full adapter where we chose distance at each step
// Clearly the winner; the air can flow much straighter.
module adapterDist() {
    translate([0,0,attach_overhang_dist+taper_dist])
    hoseTaperDist();
    hoseAttachment();
}
adapterDist();

// Helper: Shows both versions of our adapter side-by-side
module showcaseBoth() {
    translate([0,-50,0]) {
        adapterDist();
    }
    
    translate([0,50,0]) {
        adapterDia();
    }
}
//showcaseBoth();

// Tip: Differencing your centered part with a large default
// cube can help you to visually verify your internal geometry!
//difference() {
//    adapterDist();
    //adapterDia();
//    cube(1000);
//}