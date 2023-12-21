$fn=30;

difference(){
  translate([-200,-100,0])
    import("rod linkage hard x2.stl");

  translate([10.1,84.1,0])
  cylinder(r=3, h=1.6);
}

  translate([10.1,84.1,2.2]){
    difference(){
      cylinder(r=2.5, h=1.5);
      cylinder(r=1.1, h=2);
  }
}
