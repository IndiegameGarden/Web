
// TODO list
// -remove sidebar bug when zooming

// variables to tweak
boolean isRandomParty = false;
float dxs = 2;  // sampling grid size x
float dys = 2;   // sampling grid size y
float dx = 8;               // rendering grid size x
float dy = 8;               // rendering grid size y
float brightnessThresh = 0.33; // threshold for dark-pixel detection in sampling image
float dotSizeMax = 0.7;         // relative size 0..1 of dots, can be also >1
float bpm = 131.747;          // bpm for selected song
float imagePeriod = 4.0 * (60.0/bpm);     // time period (s) that each image is shown
int   imageIndex = 0;        // first image to show
float BGCOL=0;  // background color value 0-1

// other vars
ArrayList<PImage> aImages = new ArrayList<PImage>();
float hueOffset = random(0, 0.2);
int   prevMillis=0;  // time keeping
float imageTime = 0.0;  // time shown for current image
float x, y;
float totShapeHeight, totShapeWidth;
float lastInnerWidth, lastInnerHeight;

void setup() {
  //goFullScreen();
  colorMode(RGB, 1);
  background(0.90196); // 230 = E6
  //size(displayWidth, displayHeight);
  lastInnerWidth = window.innerWidth;
  lastInnerHeight = window.innerHeight;
  size(window.innerWidth * 0.999, window.innerHeight * 0.999);  
  //size(900,600); 
  noStroke();
  loadImages();
}

boolean sketchFullScreen() {
  return true;
}

/*
function goFullScreen() {
  var canvas = document.getElementById("dance");
  if (canvas.requestFullScreen)
    canvas.requestFullScreen();
  else if (canvas.webkitRequestFullScreen)
    canvas.webkitRequestFullScreen();
  else if (canvas.mozRequestFullScreen)
    canvas.mozRequestFullScreen();
}
*/

void loadImages() {
  PImage img;
  for (int i=1; i <= 15; i++) {
    img = loadImage( i + ".jpg" );
    if (img != null) aImages.add(img);
  }   
  //println(aImages.size() + " images loaded.");
}

void renderImageDots(PImage im, float x, float y, float hueOffset, float timeFraction, float dotSizeScale) {
  color c; 
  float xsmax = (im.width-dxs/2);
  float ysmax = (im.height-dys/2);
  for (float xs = dxs/2; xs <= xsmax ; xs+=dxs ) {
    for (float ys = dys/2; ys < ysmax ; ys+=dys ) {
      c = im.get( (int)(round(xs)), (int)(round(ys)) );  // sample pixel
      if (brightness(c) < brightnessThresh) {  // if pixel dark...
        colorMode(HSB);
        fill(0.5+0.5*cos(hueOffset + 2*xs/im.width), 0.6+0.4*timeFraction, 0.6+0.4*timeFraction, timeFraction);  // draw shape
        ellipse(x + xs/dxs*dx, y + ys/dys*dy, dx*dotSizeScale, dy*dotSizeScale);
        //ellipse(x + ys/dys*dx, y + xs/dxs*dy, dx*dotSizeScale, dy*dotSizeScale); // rotated mode!
      }
    }
  }
  totShapeWidth = xsmax/dxs*dx;
  totShapeHeight = ysmax/dys*dy;
}

void renderImageFull(PImage im, float x, float y, float hueOffset, float timeFraction) {
  color c;
  colorMode(HSB);
  tint(hueOffset, 0.4+0.5*timeFraction, 0.8+0.2*timeFraction, timeFraction);
  image(im, x, y);
}

void mouseClicked() {
  imageTime= imagePeriod; // skip to next period
  if (mouseButton == LEFT)
    isRandomParty = false;
  if (mouseButton == RIGHT)
    isRandomParty = !isRandomParty;
}

void keyPressed() {
  switch(key) {
  case '5':    
    imagePeriod /= 2.0; 
    break;
  case '6':    
    imagePeriod *= 2.0; 
    break;
  case 'r':
  case 'R':
    isRandomParty = !isRandomParty;
    break;
  case '1':
    if(dxs>=2.0) dxs /= 2.0; 
    if(dys>=2.0) dys /= 2.0;
    break;
  case '2':
    dxs *= 2.0; 
    dys *= 2.0;
    break;
  case '3':
    if(dx>=1.5) dx /= 1.5; 
    if(dy>=1.5) dy /= 1.5; 
    break;
  case '4':
    dx *= 1.5; 
    dy *= 1.5; 
    break;
  case '0':
    BGCOL = 1-BGCOL;
    break;    
  default:
    imageTime= imagePeriod; // skip to next period      
    isRandomParty = false;
    if ( key >= 'A' && key <= 'Q' ) {
      imageIndex = key - 'A';
    }
    else if (key >='a' && key <= 'q') {
      imageIndex = key - 'a';
    }
    break;
  }
}

void draw() {
  boolean isChangePos = false;
  //goFullScreen();
  
  // auto-resizing behaviour for browser
  if (lastInnerWidth != window.innerWidth || lastInnerHeight != window.innerHeight) {
    size(window.innerWidth * 0.999, window.innerHeight * 0.999);  
    background(0);
    lastInnerWidth = window.innerWidth;
    lastInnerHeight = window.innerHeight;  
  }  

  // time keeping
  float dt = ((float)(millis() - prevMillis))/1000;
  prevMillis = millis();
  imageTime += dt;

  if (imageTime >= imagePeriod ) {
    // time for next image and next position
    imageTime = 0.0;   // reset timer 
    imageIndex++;      // pick next image
    if (imageIndex >= aImages.size() )
      imageIndex = 0;
    hueOffset = random(0, 0.8);      // pick new hue value
    isChangePos = true;
  }

  float timeFraction = imageTime/imagePeriod ;

  // random party mode
  if (isRandomParty || isChangePos ) {
    x = dx * round(random(0, width-totShapeWidth)/dx);
    y = dy * round(random(-32, height-totShapeHeight)/dy);
  }

  // fade-out of previous image
  colorMode(RGB);
  fill(BGCOL, BGCOL, BGCOL, 0.044);
  rect(0, 0, width, height);

  // render new image of dots
  renderImageDots(aImages.get(imageIndex), x, y, hueOffset, timeFraction, dotSizeMax);
}


