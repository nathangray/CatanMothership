
// Tab & slot
use <TABS.scad>;

// Inner hollow
INNER_R = 13;
INNER_H = 62;

// Magnets
MAGNET_LOCATION=95;
MAGNET_WIDTH=10;

// Tabs variables
tab_number = 3;
tab_length=3;
insert_depth = 8;
rotation=-30;

difference() {
	translate([0,0,14]) rotate([0,0,8.8]) scale([0.995,0.995, 1]) import("body_repaired.stl");
	
	// Hollow it out
	translate([0,0,INNER_H]) sphere(INNER_R);
	translate([0,0,-1]) {
		cylinder(h=INNER_H+1,r=INNER_R);
		translate([0,0,insert_depth]) mirror([0,0,1]) slots(
			tab_number=tab_number,
			groove_depth=tab_length,
			center_hole=INNER_R*2,
			insert_depth=insert_depth,
			lock=0.5,
			rotation=rotation
		);
	}
	
	// Fame magnets
	translate([0,0,MAGNET_LOCATION]) cylinder(h=30, r=10);
	translate([0,0,MAGNET_LOCATION-4]) cylinder(h=2.5, r=5.5);
}
	