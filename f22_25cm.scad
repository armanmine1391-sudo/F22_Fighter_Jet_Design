// F-22 inspired 25 cm scale fighter model for OpenSCAD
// Designed as a printable, modular concept with detachable wings,
// rear brushless motor mounts, and simple landing gear.
// Length target: ~250 mm

$fn = 48;

length = 250;
wing_span = 170;
body_width = 34;
body_height = 24;
wing_thickness = 3.5;
engine_mount_d = 16;
engine_mount_h = 22;
wheel_d = 20;
wheel_w = 6;

module wing_planform() {
    polygon(points = [
        [0, 0],
        [88, 0],
        [98, 18],
        [92, 40],
        [60, 60],
        [18, 36],
        [0, 14]
    ]);
}

module fuselage_main() {
    // Main body, wide in middle, narrow toward nose and tail
    hull() {
        translate([-100, 0, 0]) scale([0.8, 0.7, 0.7]) sphere(r = 18);
        translate([-35, 0, 0]) scale([1.3, 1.0, 0.9]) sphere(r = 21);
        translate([30, 0, 0]) scale([1.2, 1.0, 0.9]) sphere(r = 19);
        translate([80, 0, 0]) scale([0.8, 0.7, 0.7]) sphere(r = 12);
    }

    // Slightly flattened upper body for stealth look
    // This keeps the nose smooth while giving a stronger wing root region.
    translate([-5, 0, 0]) scale([1.2, 0.9, 0.75]) sphere(r = 18);
}

module nose_sharpener() {
    translate([-110, 0, 0])
        rotate([0, 90, 0])
            cylinder(h = 40, r1 = 4, r2 = 14);
}

module wing_left() {
    translate([10, 0, 10])
        rotate([0, 0, -8])
        mirror([0, 1, 0])
        linear_extrude(height = wing_thickness)
            wing_planform();
}

module wing_right() {
    translate([10, 0, 10])
        rotate([0, 0, 8])
        linear_extrude(height = wing_thickness)
            wing_planform();
}

module central_wing_root() {
    // Thickened connection at fuselage center to support symmetric wing mounting.
    translate([5, 0, 8])
        rotate([90, 0, 0])
        cylinder(h = 18, r = 12, center = true);
}

module tail_fin_left() {
    translate([78, 0, 18])
        rotate([0, 0, 18])
        mirror([0, 1, 0])
        linear_extrude(height = 3)
            polygon(points = [
                [0, 0],
                [34, 0],
                [22, 18],
                [10, 24],
                [0, 18]
            ]);
}

module tail_fin_right() {
    translate([78, 0, 18])
        rotate([0, 0, -18])
        linear_extrude(height = 3)
            polygon(points = [
                [0, 0],
                [34, 0],
                [22, 18],
                [10, 24],
                [0, 18]
            ]);
}

module horizontal_tail(side = 1) {
    translate([80, side * 18, 10])
        rotate([0, 0, 10 * side])
        linear_extrude(height = 2.5)
            polygon(points = [
                [0, 0],
                [28, 0],
                [32, 10],
                [16, 16],
                [0, 10]
            ]);
}

module engine_pod(side = 1) {
    // Two rear brushless motor pods, mirrored and mounted just behind the main wing area.
    // The engine shaft is aligned along the aircraft X axis in this model.
    translate([70, side * 28, 0])
        rotate([0, 90, 0]) {
            difference() {
                cylinder(h = 22, r = 9, center = false);
                translate([4, 0, 0])
                    cylinder(h = 24, r = 5, center = false);
            }
            // rear fan shroud
            translate([18, 0, 0])
                cylinder(h = 4, r1 = 10, r2 = 7, center = false);
        }
}

module wheel() {
    // Simplified but printable wheel and tire shape.
    difference() {
        cylinder(h = wheel_w, r = wheel_d / 2, center = true);
        cylinder(h = wheel_w + 1, r = 3.2, center = true);
    }
}

module landing_gear() {
    // Main landing gear: two wheels mounted near the center body.
    for (y = [18, -18]) {
        translate([18, y, -18]) {
            rotate([0, 0, 20]) {
                hull() {
                    translate([0, 0, 0]) rotate([90, 0, 0]) cylinder(h = 4, r = 2.4, center = true);
                    translate([8, 0, 0]) rotate([90, 0, 0]) cylinder(h = 4, r = 2.4, center = true);
                }
                translate([10, 0, -10]) rotate([90, 0, 0]) wheel();
            }
        }
    }

    // Nose wheel
    translate([75, 0, -16]) {
        hull() {
            translate([0, 0, 0]) rotate([90, 0, 0]) cylinder(h = 4, r = 2.2, center = true);
            translate([8, 0, 0]) rotate([90, 0, 0]) cylinder(h = 4, r = 2.2, center = true);
        }
        translate([10, 0, -8]) rotate([90, 0, 0]) wheel();
    }
}

module wing_mount_socket(side = 1) {
    // Small detachable socket for split wings.
    translate([10, side * 14, 10])
        rotate([90, 0, 0])
            cylinder(h = 6, r = 4, center = true);
}

module f22_25cm() {
    union() {
        color([0.78, 0.82, 0.86]) fuselage_main();
        color([0.78, 0.82, 0.86]) nose_sharpener();

        // Main wing roots
        color([0.82, 0.84, 0.88]) central_wing_root();

        // Detachable wings
        color([0.78, 0.8, 0.84]) wing_right();
        color([0.78, 0.8, 0.84]) wing_left();

        // Tails / fins
        color([0.78, 0.8, 0.84]) tail_fin_left();
        color([0.78, 0.8, 0.84]) tail_fin_right();
        color([0.78, 0.8, 0.84]) horizontal_tail(1);
        color([0.78, 0.8, 0.84]) horizontal_tail(-1);

        // Rear engine pods
        color([0.25, 0.27, 0.32]) engine_pod(1);
        color([0.25, 0.27, 0.32]) engine_pod(-1);

        // Landing gear
        color([0.18, 0.18, 0.2]) landing_gear();

        // Wing sockets for mounting split wings after printing.
        color([0.18, 0.18, 0.2]) wing_mount_socket(1);
        color([0.18, 0.18, 0.2]) wing_mount_socket(-1);
    }
}

f22_25cm();

// Optional assembly helper:
// If you want the wings to be separate printable parts, comment the above call and use:
// wing_right();
// wing_left();
// fuselage_main();
// engine_pod(1); engine_pod(-1);
// landing_gear();
