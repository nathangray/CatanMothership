

		%translate([0,0,0]) rotate([0,0,-3]) scale([0.995,0.995, 1]) import("base.stl");
		$fn=72;
difference() {
	translate([0,0,-29]) cylinder(h=8, r=6);
	translate([0,0,-32]) cylinder(h=20, r=5.2);
}
intersection() {
	difference() {
		translate([0,0,0]) rotate([0,0,-3]) scale([0.995,0.995, 1]) import("base.stl");
		translate([0,0,-32]) cylinder(h=20, r=5.2);
	}
	
	// Cut off nozzle
	translate([0,0,-48]) cylinder(h=26, d1=40, d2=10);
}