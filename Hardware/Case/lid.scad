/* [Case settings] */
Addons = 0; // [0:1:6]
BoxThickness = 3; // [1:0.5:5] 
AddonHeight = 14;

DistanceBetweenObjects = 10;
ShowCaseAssembled = false;
ShowBoards = true;

ShowCase = true;
ShowLid = true;
ShowLargeHalf = true;
ShowSmallHalf = true;

// 6chan standard sizes
InteriorBoxHeight = 67;
SplitHeight = 18;
// Do NOT change this setting or CT won't fit
InteriorBoxWidth = 62; // [60:0.1:65]


/* [Render quality settings] */
// Set to at least to 150 before render and save as .stl file, otherwise you can go down to 40 for quick 3D view
$fn                       = 60;   // [20:1:300]

if (ShowCase) {
    case();
}
if (ShowLid) {
    if(ShowCaseAssembled) {
        translate([InteriorBoxWidth/2+(BoxThickness*2)-0.5,InteriorBoxHeight/2+(BoxThickness/2)-0.5,24+(AddonHeight*Addons)+BoxThickness/2+DistanceBetweenObjects]) rotate([0,180,0]) lid();
    } else {
        translate([-(InteriorBoxWidth/2+(BoxThickness)+DistanceBetweenObjects),InteriorBoxHeight/2+(BoxThickness),0]) lid();
    }
}

module lid() {
    color("LightCyan",alpha = 0.5)
    union() {
// Lid base
cube([InteriorBoxHeight+(BoxThickness*2),InteriorBoxWidth+(BoxThickness*2),BoxThickness],center=true);

// Lid sides
translate([0,0,BoxThickness-0.001])
    difference() {
    cube([InteriorBoxHeight,InteriorBoxWidth,6],center=true);
    cube([InteriorBoxHeight-4,InteriorBoxWidth-4,6+0.001],center=true);
    }

CubePoints = [
  [  -13,  -2,  0 ],  //0
  [ 13,  -2,  0 ],  //1
  [ 13,  2,  0 ],  //2
  [ -13,  2,  0 ],  //3
  [ -10,  -0.5,  0.5 ],  //4
  [ 10,  -0.5,  0.5 ],  //5
  [ 10,  0.5,  0.5 ],  //6
  [  -10,  0.5,  0.5 ]]; //7
  
CubeFaces = [
  [0,1,2,3],  // bottom
  [4,5,1,0],  // front
  [7,6,5,4],  // top
  [5,6,2,1],  // right
  [6,7,3,2],  // back
  [7,4,0,3]]; // left

translate([InteriorBoxHeight/2,0,BoxThickness+1])
rotate([90,0,90])
polyhedron( CubePoints, CubeFaces);    
}
}

module case() {
    difference() {
        union() {
            if(ShowSmallHalf) {
                color("SteelBlue",alpha = 1)
                SmallHalf();
            }
            if(ShowLargeHalf) {
                color("LightSteelBlue",alpha = 1)
                LargeHalf();
            }
        }
        
        union() {
            // Power Hole
            color("Yellow")
            translate([-0.02,10.6,BoxThickness+4])
            cube([BoxThickness+0.03,9.3,12]);
                        
            // CT Holes
            color("Yellow")
            for (ctline=[0:Addons]) {
            for (ctcolumn=[0:2]) {
                translate([BoxThickness+24+ctcolumn*14,InteriorBoxWidth+(BoxThickness*2)+0.01,7+BoxThickness+(AddonHeight*ctline)])
                rotate([90,0,0])
                cylinder(h=InteriorBoxWidth+BoxThickness*2+0.02,d=6);
            }
        }
        }
    }
    if(ShowBoards) {
        color("Salmon")
        union() {
            rotate([0,0,-90])
            translate([-61-BoxThickness,62.2+BoxThickness,2.8+BoxThickness])
            import("mainboard.stl");
                
            if(Addons>=1) {
                for (addon=[0:Addons]) {
                    rotate([0,0,-90])
                    translate([-66+BoxThickness/2,62.7+BoxThickness,2.8+BoxThickness+(AddonHeight*addon)])
                    import("addon.stl");
                }
            }
            rotate([0,0,-90])
            translate([-66+BoxThickness/2,62.7+BoxThickness,2.8+BoxThickness+(AddonHeight*Addons)])
            import("mcu.stl");
        }
    }
}

module LargeHalf() {
    union() {
    difference() {
        // Large half
        cube([InteriorBoxHeight+(BoxThickness*2),InteriorBoxWidth+(BoxThickness*2),25+(AddonHeight*Addons)]);
        translate([BoxThickness-0.01,BoxThickness-0.01,BoxThickness-0.01])
        cube([InteriorBoxHeight+0.02,InteriorBoxWidth+0.02,25+(AddonHeight*Addons)+0.02]);
        translate([-0.01,-0.01,-0.01])
        cube([InteriorBoxHeight+(BoxThickness*2)+0.02,SplitHeight+0.01,25+(AddonHeight*Addons)+10+0.01]);

        translate([0-0.01,SplitHeight-0.15,-0.01])
        ridge();
        translate([0-0.01,SplitHeight-0.15,-0.01])
        cube([InteriorBoxHeight+(BoxThickness*2),3,BoxThickness/2]);
        translate([InteriorBoxHeight+(BoxThickness*2)+0.01,SplitHeight-0.15,-0.01])
        mirror([1,0,0])
        ridge();
    }
}
}

module SmallHalf() {
    union() {
    difference() {
        translate([0.01,0.01,0.01])
        cube([InteriorBoxHeight+(BoxThickness*2)+0.01,InteriorBoxWidth+(BoxThickness*2)+0.01,25+(AddonHeight*Addons)+0.01]);
        translate([BoxThickness,BoxThickness,BoxThickness])
        cube([InteriorBoxHeight,InteriorBoxWidth,24+(AddonHeight*Addons)]);
        translate([-0.1,SplitHeight-0.1,-0.1])
        cube([InteriorBoxHeight+(BoxThickness*2)+0.2,InteriorBoxWidth+(BoxThickness*2),25+(AddonHeight*Addons)+10]);
    }
    translate([0-0.01,SplitHeight-0.15,-0.01])
    ridge();
    translate([InteriorBoxHeight+(BoxThickness*2)+0.01,SplitHeight-0.15,-0.01])
    mirror([1,0,0])
    ridge();
    }
    translate([0-0.01,SplitHeight-0.15,-0.01])
    cube([InteriorBoxHeight+(BoxThickness*2),3,BoxThickness/2]);
}
        
module ridge() {
    linear_extrude(height = 25+(AddonHeight*Addons)+0.04, center = false, convexity = 10, twist = 0)
        polygon(points=[[0,0],[0,3],[BoxThickness/2+0.6,3],[BoxThickness/2+0.6,2],[BoxThickness/2+0.1,2],[BoxThickness/2+0.6,0]]);
}