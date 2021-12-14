import unlekker.modelbuilder.*;

UGeometry model;

int baseProportion;
int wallThickness;
int gridSize;

void setup() {
  size(1000,1000,P3D);
  
  baseProportion = 100;
  wallThickness = 7;
  gridSize = 4;
  
  build();
}

void draw() {
  background(255);
  noFill();
  
  // rotate the canvas when the mouse moves
  rotateX(map(mouseY, 0, height, -PI/2, PI/2));
  rotateY(map(mouseX, 0, width, -PI/2, PI/2));
  
  // start in the middle
  translate(width, height, 0);
  
  model.draw(this);
}

void drawPyramid(int pyrSize, float peakAngle) {  
  // the pyramid has 4 sides, each drawn as a separate triangle made of 3 vertices
  
  float peak = pyrSize * radians(peakAngle); // where in space it should go based on the angle
  UVec3 peakPt = new UVec3(20, 20, peak); // top of the pyramid
  
  // four corners
  UVec3 ptA = new UVec3(-pyrSize, -pyrSize, random(300));
  UVec3 ptB = new UVec3(pyrSize, -pyrSize, random(300));
  UVec3 ptC = new UVec3(pyrSize, pyrSize, random(300));
  UVec3 ptD = new UVec3(-pyrSize, pyrSize, random(300));
 
  
  UVec3[][] faces = {{ptA, ptB, peakPt},
{ptA, ptD, peakPt},
{ptB, ptD, peakPt},
{ptD, ptC, peakPt}};
  
  model.beginShape(SPHERE);
  for (int i = 0; i < faces.length; i++) {
    model.addFace(faces[i]);
  }
  model.endShape();  
}

void drawBase() {
  // base is made of 4 rectangles that cap off the bottoms of the pyramids, connecting the inner and the outer
  
  UGeometry[] rectangles = {UPrimitive.box(baseProportion*random(1.1,3), wallThickness*random(10), random(30))
                            };
                           
                            
  // UPrimitive's rectangles only take a width and a height, so to position them in space we need to translate                   
  UVec3 positions[] = {new UVec3(random(10), -baseProportion + wallThickness, random(0,10)),
                       new UVec3(random(20), baseProportion + wallThickness, random(-15,-10)),
                     new UVec3(-baseProportion + wallThickness, random(-1,-5), -1.4),
                   new UVec3(-baseProportion/2 + wallThickness, random(-10,-20), -2)};
                       
  for (int i = 0; i < rectangles.length; i++) {
    rectangles[i].translate(positions[i]);
    model.add(rectangles[i]); 
  }
}

int gridOffset(int d) {
  return (baseProportion - wallThickness * 2)  * d;
}

void build() {
  model = new UGeometry();
  for (int x = 0; x < gridSize; x++) {
    for (int y = 0; y < gridSize; y++) {
      float peakAngle = random(25, 70); // steepness of the pyramd
      model.translate(gridOffset(x), gridOffset(y), random(20));
      //drawPyramid(baseProportion, peakAngle/2); // outer pyramid
      drawPyramid(baseProportion - (wallThickness * 2), peakAngle); // inner
     // drawBase();
      model.translate(gridOffset(-x), gridOffset(-y), 0); // reset it back to the center
    }
  }
}

public void keyPressed() {
  if(key=='s') {
    model.writeSTL(this, "Pyramids.stl");
    println("STL written");
  }
}
