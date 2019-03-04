
// Battery holder
use <flex_battery.scad>;

// Shell tolerances
TOLERANCE = 0.3;

// Outer shell
OUTER_R_B = 14.8; //Bottom OD-0.2 for tolerance
OUTER_R_T = 13-TOLERANCE; // Outer radius for top section
OUTER_H_B = 6; // Height for lower
HEIGHT_INNER = 44;

// Inner hollow
INNER_R = 11.8;


// Tabs variables
tab_number = 3;
tab_length=3;
insert_depth = 8;


//#translate([0,0,0]) rotate([0,0,-3]) scale([0.995,0.995, 1]) import("base.stl");
/*
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
			translate([OUTER_R_B-1,-2,-8.4]) cube([1.5-TOLERANCE,4-TOLERANCE,5]);
			
			
		}
		
		// Hollow it out
		translate([0,0,-INNER_R/2-1]) cylinder(h=HEIGHT_INNER +1, r = INNER_R);
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
*/
	// Arduino board
//	rotate([0,0,00]) translate([-6, 0,-10]) rotate([0,0,-90]) arduino();

	// Battery holders
	battery_holder();
	
	// Light pokey bit
	difference() {
		translate([-1,0,-16]) cube([8,1.8,30],true);
		for(z=[0,8, 16]) translate([-1,5,-8-z]) rotate([90,0,0])cylinder(h=10, r=2);
	}


module battery_holder() {
	//battery_holder_compact();
	battery_holder_flex();
}

module battery_holder_flex() {
	n=1;
	intersection() {
		// Outer shell
		translate([0,0,-60]) cylinder(h=150, r=OUTER_R_T-TOLERANCE);
	
		
		// Flex holders
		union() {
			translate([-5,5.75,54]) rotate([0,90,0]) flexbatter(n=n,l=46.1,d=10.45,hf=0.84,shd=0,el=1,xchan=[0.77],eps=0);
			translate([-5,-5.75,54]) rotate([0,90,0]) flexbatter(n=n,l=46.1,d=10.45,hf=0.84,shd=0,el=1,xchan=[0.77],eps=0);
		}
	}
	
	// Plug/insertion bit
	intersection() {
		// Inner hole
		translate([0,0,-35]) cylinder(h=HEIGHT_INNER +1, r = INNER_R);
		union() {
			translate([6.5,0,0]) cube([20,40,5],true);
			translate([0,-10,5]) cube([10,5,5],true);
			translate([0,10,5]) cube([10,5,5],true);
			translate([0,0,5]) cube([10,8,5],true);
		}
	}
	//translate([0,0,5]) cylinder(h=5, r=INNER_R);
}

module battery_holder_compact() {
	rotate([0,-45,0]) translate([20,0,50]) cube([100,100,50],true);
	difference() {
		union() {
			translate([5,2,20]) rotate([-90,0,90]) import("Compact_AAA_Battery_Holder.stl");
			translate([5,-2,20]) mirror([0,90,0]) rotate([-90,0,90]) import("Compact_AAA_Battery_Holder.stl");
		}
		translate([0,0,25]) cube([10,10,40],true);
	}
 	translate([5,0,25]) linear_extrude(height=45,center=true, twist=0)polygon([[0,-1.5],[0,1.5],[-5,0]]);
	// Join to main tube
	difference() {
		translate([0,0,-4]) cylinder(h=10.7, r = INNER_R);
		translate([-OUTER_R_T-5,-OUTER_R_T,2]) cube([2*OUTER_R_T, 2* OUTER_R_T, 10]);
		translate([-OUTER_R_T-9,-OUTER_R_T,-4.5]) cube([2*OUTER_R_T, 2* OUTER_R_T, 10]);
		rotate([0,30,0]) translate([-OUTER_R_T+2,-OUTER_R_T,-7]) cube([2*OUTER_R_T, 2* OUTER_R_T, 10]);
	}
}
module arduino_clip() {
	difference() {
		intersection() {
			// Outer shell
			translate([0,0,0]) cylinder(h=120, r=OUTER_R_T-TOLERANCE);
			union() {
				translate([7.5,-9.5,1.8]) cube([6,6,17]);
				translate([-11.5,-9.5,1.8]) cube([4,6,17]);
			}
		}
		translate([0,-5.0,1]) arduino(TOLERANCE);
	}
}
module arduino(tol=0) {
	translate([-9.3, 0,2]) rotate([90,0,0])
	union() {
		color("royalblue") cube([18.6+tol, 34.25, 1.6+tol]);
		translate([6.5,3.5,1.6]) color("silver") cube([6.2, 3.75, 2.6]);
		translate([9,14,1.6]) rotate([0,0,45]) color("black") cube([8.5,8.5,1]);
	}
}