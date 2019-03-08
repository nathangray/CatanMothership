// Tab & slot
use <TABS.scad>;
// Battery holder
use <flex_battery.scad>;

// Shell tolerances
TOLERANCE = 0.3;

// Outer shell
OUTER_R_B = 14.3; // Mating part is 15 
OUTER_R_T = 13-TOLERANCE; // Outer radius for top section
OUTER_H_B = 6; // Height for lower
HEIGHT_INNER = 44;

// Inner hollow
INNER_R = 11.4;


// Tabs variables
tab_number = 3;
tab_length=3;
insert_depth = 8;


//#translate([0,0,0]) rotate([0,0,-3]) scale([0.995,0.995, 1]) import("base.stl");
tab_ring();
// Arduino board
//	rotate([0,0,00]) translate([-6, 0,-10]) rotate([0,0,-90]) arduino();



module tab_ring() {
difference() {
	union() { 
		difference() { union() {
			translate([0,0,-OUTER_R_B/2-1]) cylinder(h=OUTER_H_B +1, r = OUTER_R_B); // Lower
			translate([0,0,-OUTER_R_B/2-1]) cylinder(h=HEIGHT_INNER +1, r = OUTER_R_T); // Upper
			
			// Tabs
			rotate([0,0,30]) translate([0,0,2+TOLERANCE]) tabs(
				tab_number=tab_number,
				groove_depth=tab_length,
				center_hole=OUTER_R_T*2,
				insert_depth=insert_depth,
				lock=0.5
			);
			
			// Alignment key
			translate([OUTER_R_B-1,-2,-8.1]) cube([1.9,4-TOLERANCE,5]);
			
			
		}
		
		// Hollow it out
		translate([0,0,-8]) cylinder(h=HEIGHT_INNER +10, r = INNER_R);
		translate([0,0, -8]) sphere(INNER_R);
		translate([0,0,35]) cube([50,50,50],true)
		
		// Nozzle hole
		translate([0,0,-30]) cylinder(h=15, r=6);
		
	}
	// Arduino slot
	translate([0, 0,-10]) rotate([0,0,-90]) arduino_clip();
	}


	// Battery holder cutout
	translate([0,0,11.5])  cube([10,50,10],true);
}
}
