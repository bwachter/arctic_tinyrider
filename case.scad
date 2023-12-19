use <lego/LEGO.scad>;

layers=1;

x=58.5;
y=69;
h=3;
screw=3;

brick_height=9.6;
top=(brick_height*layers)+3;

$fn=25;

module support_triangle(side_length, side_height){
  polygon(points=[[0,0],[side_height,side_length],[side_height,0]], paths=[[0,1,2]]);
}

translate([-33.5,-4])
import("top plate.stl");

difference(){
  union(){
    // right side bottom plate
    translate([-23.5,0,0]){
      cube([23.5,51,3]);
    }

    // left side bottom plate
    translate([48.5, 14,0]){
      cube([23.5,37,3]);
    }
    translate([48.5, 0,0]){
      cube([3,30,3]);
    }
    // outside wall left side
    color("green") translate([48.5, -5,0]){
      cube([3,21,12.0]);
    }
    translate([-23.5,-5,0]){
      cube([75,5,3]);
    }
    translate([-23.5,10,0]){
      cube([75,3,3]);
      translate([75,-11,3])
        rotate([90,0,270]) {
        color("green")
          linear_extrude(75){
          support_triangle(5, 5);
        }
      }
    }

    // small triangle supporting the sloped brick on the left
    translate([-3.5,19,0]){
      translate([75.5,-9,3])
        rotate([90,180,270]) {
        color("green")
          linear_extrude(22){
          support_triangle(3, 4.5);
        }
      }
    }

    translate([24.2,55,3]){
      // front 6
      color("white") place(0, 0, 0) block(
        block_bottom_type="closed",
        width=1,
        length=6
        );
      // right 4
      color("white") uncenter(0,1) place(-1, -4, 0) block(
        block_bottom_type="closed",
        width=1,
        length=5
        );
      // left 4
      color("white") uncenter(0,1) place(-1, 3, 0) block(
        block_bottom_type="closed",
        width=1,
        length=5
        );
      // right technics brick
      color("white") uncenter(0, 1) rotate([0,0,90])
        place(6, -4, 0) block(
          horizontal_holes=true,
          block_bottom_type="closed",
          width=1,
          length=5
          );
      // this is a double brick to avoid a gap for more stability
      color("green") uncenter(1, 1) rotate([0,0,90])
        place(6, -8, 0) block(
          block_bottom_type="closed",
          width=1,
          length=2
          );
      // left  brick
      color("white") uncenter(0, 1) rotate([0,0,90])
        place(-5, -3, 0) block(
          horizontal_holes=true,
          block_bottom_type="closed",
          width=1,
          length=3
          );
      // back brick
      color("white") uncenter(0, 1)
        place(-8, -2, 0) block(
          block_bottom_type="closed",
          width=1,
          length=9
          );
      // brick over the gears
      color("red")
        uncenter(1,1)
        rotate([0,0,90])
        place(-4, -7, 0) block(
          block_bottom_type="closed",
          width=3,
          length=4
          );
      if (layers >= 2){
        // second layer
        color("white") uncenter(1, 1) place(-1, 2, 1) rotate([0,0,90]) block(
          block_bottom_type="closed",
          width=1,
          length=2
          );
        color("white") uncenter(1, 1) place(-1, -3, 1) rotate([0,0,90]) block(
          block_bottom_type="closed",
          width=1,
          length=2
          );
        color("white") place(0, 0, 1) block(
          block_bottom_type="closed",
          width=1,
          length=4,
          horizontal_holes=true
          );
        // right side
        color("white") place(-1, -4, 1) block(
          horizontal_holes=true,
          block_bottom_type="closed",
          width=1,
          length=2
          );
        color("white") uncenter(0, 1) rotate([0,0,90])
          place(6, -1, 1) block(
            block_bottom_type="closed",
            width=1,
            length=1
            );
        color("white") uncenter(1, 1) rotate([0,0,90])
          place(6, -3, 1) block(
            horizontal_holes=true,
            block_bottom_type="closed",
            width=1,
            length=2
            );
        color("white") uncenter(1, 1) rotate([0,0,90])
          place(6, -5, 1) block(
            block_bottom_type="closed",
            width=1,
            length=2
            );

        color("white") uncenter(1, 1) rotate([0,0,90])
          place(6, -7, 1) block(
            horizontal_holes=true,
            block_bottom_type="closed",
            width=1,
            length=2
            );
        // left side
        color("white") place(-1, 4, 1) block(
          horizontal_holes=true,
          block_bottom_type="closed",
          width=1,
          length=2
          );
        color("white") uncenter(0, 1) rotate([0,0,90])
          place(-5, -1, 1) block(
            block_bottom_type="closed",
            width=1,
            length=1
            );
        color("white") uncenter(1, 1) rotate([0,0,90])
          place(-5, -3, 1) block(
            horizontal_holes=true,
            block_bottom_type="closed",
            width=1,
            length=2
            );
        color("white") uncenter(1, 1) rotate([0,0,90])
          place(-5, -5, 1) block(
            block_bottom_type="closed",
            width=1,
            length=2
            );
        color("white") uncenter(1, 1) rotate([0,0,90])
          place(-5, -7, 1) block(
            horizontal_holes=true,
            block_bottom_type="closed",
            width=1,
            length=2
            );
        // back
        color("white") uncenter(0, 1)
          place(-8, -6, 1) block(
            block_bottom_type="closed",
            width=1,
            length=1
            );
        color("white") uncenter(0, 0)
          place(-8, -4, 1) block(
            horizontal_holes=true,
            block_bottom_type="closed",
            width=1,
            length=2
            );
        color("white") uncenter(0, 0)
          place(-8, -2, 1) block(
            block_bottom_type="closed",
            width=1,
            length=2
            );
        // center block
        color("white") uncenter(0, 0)
          place(-8, 0, 1) block(
            horizontal_holes=true,
            block_bottom_type="closed",
            width=1,
            length=2
            );
        color("white") uncenter(0, 0)
          place(-8, 2, 1) block(
            block_bottom_type="closed",
            width=1,
            length=2
            );
        color("white") uncenter(0, 0)
          place(-8, 4, 1) block(
            horizontal_holes=true,
            block_bottom_type="closed",
            width=1,
            length=2
            );
        color("white") uncenter(0, 1)
          place(-8, 5, 1) block(
            block_bottom_type="closed",
            width=1,
            length=1
            );
      }
    }
  }

  // differences come here
  translate([-23.5,10,0]){
    translate([100,-15,3])
      rotate([90,0,270]) {
      linear_extrude(115){
        support_triangle(10, 10);
      }
    }
  }

  translate([50,-15,-40])
    rotate([0,90,0])
    cylinder(r=50, h=30);

  // cutout for screw head
  translate([46,4,3])
    cylinder(r=3, h=30);

  // the cutouts always are on the top most layer
  // cutout for ESC power cable
  translate([64,25.4,top-8.2])
    cube([10,3,9]);

  // cutout for the servo
  translate([38.4,41,top-4.2])
    cube([2,18,7]);

}
