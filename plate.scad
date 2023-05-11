module plate(serial = "VX.XXXX") {
    height=20;
    width_0 = 15.23;
    char_width = 10;
    width = width_0 + len(serial) * char_width;

    engraving_depth = 2;

    font_size = 8;
    font_face = "Play";

    screw_offset = 13.5;
    screw_pos = width / 2 - screw_offset;

    epsilon = .01;

    module base() {
        shoulder_height=11;
        shoulder_width=5;
        radius = 2;
        radius_top = 2.85;

        module corner(pos = [0,0,0], r = radius) {
            thickness = 3;

            translate(pos) hull() {
                rotate_extrude() translate ([r,0]) difference() {
                    circle(radius);
                    translate([-radius, -radius*2]) square(radius*2);
                }
                translate([0,0,thickness - epsilon]) cylinder(epsilon, r = r);
            }
        }

        hull() for (flip = [0:1]) {
            mirror([flip,0,0]) {
                corner([width/2,radius * 2,0]);
                corner([width/2-shoulder_width, height - radius - radius_top, 0], radius_top);
                corner([width/2+radius-radius_top, shoulder_height, 0], radius_top);
            };
        };
    };

    module screw_hole(x) {
        inner_diameter = 1.9;
        outer_diameter = 2.9;
        surface_diameter = 3;
        taper_length = 1;

        translate([x,height/2,-epsilon]) union() {
            translate([0, 0, -10]) cylinder(20, r = inner_diameter);
            cylinder(taper_length, inner_diameter, outer_diameter);
            translate([0,0,1 - epsilon]) cylinder(10, r = surface_diameter);
        }
    }

    difference() {
        base();
        union() {
            translate([0, (height - font_size) / 2, engraving_depth]) linear_extrude(10, convexity=len(serial) + 4)
                text(text=serial, font = font_face, halign = "center", size = font_size);
            screw_hole(screw_pos);
            screw_hole(-screw_pos);
        }
    }
}
