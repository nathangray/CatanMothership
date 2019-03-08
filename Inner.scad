
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
INNER_R = 11.4;


// Tabs variables
tab_number = 3;
tab_length=3;
insert_depth = 8;


//#translate([0,0,0]) rotate([0,0,-3]) scale([0.995,0.995, 1]) import("base.stl");
//#tab_ring();

// Arduino board
//	rotate([0,0,00]) translate([-6, 0,-10]) rotate([0,0,-90]) arduino();


// Battery holders
battery_holder();
	
// Light pokey bit
light_stick();

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
	#translate([0,0,-35]) cylinder(h=HEIGHT_INNER +1, r = INNER_R);
		union() {
			translate([5.0,0,0]) cube([20,40,5],true);
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

module arduino_clip() {
	difference() {
		intersection() {
			// Outer shell
			translate([0,0,0]) cylinder(h=120, r=OUTER_R_T-TOLERANCE);
			union() {
				translate([8.5,-9.5,1.9]) cube([4,6,17]);
				translate([-12.5,-9.5,1.9]) cube([4,6,17]);
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

module light_stick() {
	
difference() {
	translate([-1,0,-16]) cube([8,1.8,35],true);
	for(z=[0 : 8 : 24]) translate([-1,5,-5-z]) rotate([90,0,0])cylinder(h=10, r=2);
}
}