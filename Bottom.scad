
// Tab & slot
use <TABS.scad>;
// Battery holder
use <flex_battery.scad>;

// Outer shell
OUTER_R = 15; //13-0.4 for tolerance
OUTER_H = 20;

// Inner hollow
INNER_R = 11.8;

$fn=72;
difference() {
	translate([0,0,0]) rotate([0,0,-3]) scale([0.995,0.995, 1]) import("base.stl");
	
	// Alignment key
	translate([OUTER_R-1.5, -2,-7]) cube([2,4,8]);

	// Hollow it out
	translate([0,0, -8]) sphere(OUTER_R);
	translate([0,0,-8]) cylinder(h=OUTER_H + 2, r=OUTER_R-.5);
	translate([-INNER_R,5, 2]) cube([INNER_R*2, INNER_R*2, OUTER_H]);
	
	// Cut off nozzle
	translate([0,0,-48]) cylinder(h=26, d1=40, d2=10);
	translate([0,0,-30]) cylinder(h=15, r=6.2);
}
