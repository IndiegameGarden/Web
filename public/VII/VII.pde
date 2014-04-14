
// Theo van Doesburg Composition VII look alike

// settings to play with!
int numShapes=28;  // about 28/29 in the original
int numShapesPerColor;
boolean isCheckOverlaps = true;  // true in the original
boolean isCheckForOffScreen = true; // true in the original
float  minimumSpacing = 10;  // min space between shapes (if isCheckOverlaps == true)
float  maxColorDev = 2;  //
// the colors to use
color[] aColors = new color[] { 
  color(154, 46, 34), color(38, 55, 107), 
  color(232, 229, 212), color(208, 180, 96)
};
int currentWorkNumber = 0; // to explore the space of random works/paintings

// vars
ArrayList<Shape> shapesList = new ArrayList<Shape>();

void setup() {
  size(600, 600);
  //size(displayWidth,displayHeight);
  int numColors = aColors.length;
  numShapesPerColor = numShapes/numColors;
  createNew(currentWorkNumber);
}

void draw() {
  drawIt();
}

void mouseClicked() {
  if (mouseButton == LEFT)
    currentWorkNumber++;
  else
    currentWorkNumber--;
  createNew(currentWorkNumber);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT){ 
      currentWorkNumber--;
    }
    else
      currentWorkNumber++;
  }
  else
    currentWorkNumber++;
  createNew(currentWorkNumber);
}

void drawIt() {
  background(16, 15, 23);
  fill(16, 15, 23);
  rect(0, 0, width, height);
  for (int i=0; i < shapesList.size(); i++) {
    shapesList.get(i).draw();
  }
}

void createNew(int workNumber) {
  randomSeed(workNumber);
  //println("Composition VII." + workNumber);
  int colorIndex = 0;
  int colorCounter = 0;
  shapesList.clear();
  for (int i=0; i < numShapes; i++) {
    boolean isOk;
    Shape s;
    // re-create shape again if it overlaps or is off-screen
    do {
      isOk = true;
      s = new Shape(colorIndex);
      // check if collides with existing ones
      if (isCheckOverlaps && s.isOverlap(shapesList))
        isOk = false;
      if (isCheckForOffScreen && s.isOffScreen())
        isOk = false;
      if (isOk) {
        colorCounter++;
        if (colorCounter >= numShapesPerColor) {
          colorCounter = 0;
          colorIndex++;
        }
      }
    }
    while (!isOk);
    shapesList.add(s);
  }
}


class Shape {

  color col;
  int  x, y, w, h;
  int type;

  Shape(int colorIndex) {
    int numCols = aColors.length;
    float m = maxColorDev;
    col = aColors[colorIndex] + color(random(-m, m), random(-m, m), random(-m, m));    
    x= int(random(minimumSpacing, width-minimumSpacing));
    y= int(random(minimumSpacing, height-minimumSpacing));

    // there are 3 different types of shapes
    type = int(round(random(0.25, 2.5)));
    switch(type) {
    case 0:
      w= int(random(40, 42));
      h=w;
      break;
    case 1:
      w= int(random(60, 200));
      h= int(random(20, 30));
      break;
    case 2:
      w= int(random(20, 30));
      h= int(random(60, 200));
      break;
    }
  }

  void draw() {
    noStroke();
    fill(col);
    rect(x, y, w, h);
  }

  boolean isOverlap(ArrayList<Shape> others) {
    // use extra 'empty' area around shape based on minimumSpacing
    int s = (int)round(minimumSpacing/2);
    for (int i=0; i < others.size(); i++) {
      if (this.intersects(others.get(i),s))
        return true;
    }
    return false;
  }

  boolean intersects(Shape o, int extraSpacing) {
    int tw = this.w + extraSpacing*2;
    int th = this.h + extraSpacing*2;
    int ow = o.w + extraSpacing*2;
    int oh = o.h + extraSpacing*2;
    if (ow <= 0 || oh <= 0 || tw <= 0 || th <= 0) {
      return false;
    }
    int tx = this.x - extraSpacing;
    int ty = this.y - extraSpacing;
    int rx = o.x - extraSpacing;
    int ry = o.y - extraSpacing;
    ow += rx;
    oh += ry;
    tw += tx;
    th += ty;
    return ((ow < rx || ow > tx) &&
      (oh < ry || oh > ty) &&
      (tw < tx || tw > rx) &&
      (th < ty || th > ry));
  }

  boolean isOffScreen() {
    return (x<minimumSpacing) || (y<minimumSpacing) ||
      ((x+w)>(width-minimumSpacing)) || ((y+h)>(height-minimumSpacing)) ;
  }
}


