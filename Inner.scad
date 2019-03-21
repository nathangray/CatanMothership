
// Battery holder
use <flex_battery.scad>;

// Tab ring
use <TabRing.scad>;

use <fillets_and_rounds.scad>;

// Shell tolerances
TOLERANCE = 0.3;

// Outer shell
OUTER_R_B = 14.8; //Bottom OD-0.2 for tolerance
OUTER_R_T = 13-TOLERANCE; // Outer radius for top section
OUTER_H_B = 6; // Height for lower
HEIGHT_INNER = 44;

// Inner hollow
INNER_R = 11.0;


// Tabs variables
tab_number = 3;
tab_length=3;
insert_depth = 8;


//%translate([0,0,0]) rotate([0,0,-3]) scale([0.995,0.995, 1]) import("Bottom.stl");
//%tab_ring();

// Arduino board
%	rotate([0,0,00]) translate([-6, 0,-10]) rotate([0,0,-90]) arduino();

difference() {
// Battery holders
battery_holder();
	tab_ring();
}
	
// Button holder
rotate([0,0,-30]) translate([0,4,-13]) rotate([-90,0,0]) switch_holder();

// Light pokey bit
difference() {
	light_stick();
	translate([0,-2,-13]) cube([6.1,6,8],true);
}

module battery_holder() {
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
		translate([0,0,-35]) cylinder(h=HEIGHT_INNER +1, r = INNER_R - TOLERANCE);
		union() {
			translate([5.0,0,0]) cube([20,14,5],true);
			//translate([0,-10,5]) cube([10,5,5],true);
		//	translate([0,10,5]) cube([10,5,5],true);
		
			difference() {
				translate([-0.05,0,5]) cube([9.9,9,5],true);
				translate([-10,6.5,4.5]) rotate([0,90,0]) cylinder(h=120, r=3.1);
				translate([-10,-6.5,4.5]) rotate([0,90,0]) cylinder(h=120, r=3);
			}
		}
	
	}

	
	//translate([0,0,5]) cylinder(h=5, r=INNER_R);
}


module light_stick() {
	
difference() {
	translate([-1,0,-18]) cube([8,1.8,37],true);
	for(z=[0 : 8 : 24]) translate([-1,5,-5-z]) rotate([90,0,0])cylinder(h=10, r=2);
}
	// So no brim needed
	translate([-5,0,-35]) rotate([0,90,0]) cylinder(h=0.15, r=5);
}

// Switch holder
module switch_holder() {
	difference() {
		// Shell
		cube([10,10,10], true);
		// Main hollow
		cube([7.5, 7.5, 7], true);
		// Top/bottom opening
		translate([2, 0, 0]) cube([8.5, 5.5, 20], true);
		// Side
		translate([7, 0, 0]) cube([7.5, 7.5, 7], true);
	}
	
	%button();
}

// Actual switch / button
module button() {
	color("gray") cube([7,7,7],true);
	color("blue") {
		translate([0,0,4]) cube([4,4,1], true);
		translate([0,0,6]) cube([3,2,3], true);
	}
	color("silver") {
		// Pins...
	}
}