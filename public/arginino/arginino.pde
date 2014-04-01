float amountOfSquaresWidth =23.0;
float squareWidth;

float amountOfSquaresHeight =17.0;
float squareHeight;
float shrinkFactor = 0.5;
float topleftOffset = 5;

void setup() {
  //size(710, 500);
  size(window.innerWidth * 0.92, window.innerHeight * 0.92); 
  squareWidth = width/amountOfSquaresWidth;
  squareHeight = height/amountOfSquaresHeight;
  ellipseMode(CORNER);
  colorMode(HSB, 100);
  background(97);
  noStroke();
  drawIt();
}

void draw() {
}

void keyPressed() {
  drawIt();
}

void mouseClicked() {
  drawIt();
}

void drawIt() {
  background(97);
  for (int y=0;y<amountOfSquaresHeight;y=y+1) {  
    for (int x=0;x<amountOfSquaresWidth;x=x+1) {
      float r=8;
      if( random(0,1) > 0.5)
        r = 100;
      fill(random(0, r), random(50, 80), random(30, 99));
      ellipse(topleftOffset+(x*squareWidth), topleftOffset+(y*squareHeight), squareWidth * shrinkFactor, squareHeight * shrinkFactor);
    }
  }
}


