
// variables to tweak
boolean isRandomParty = false;
float dxs = 2;  // sampling grid size x
float dys = 2;   // sampling grid size y
float dx = 8;               // rendering grid size x
float dy = 8;               // rendering grid size y
float brightnessThresh = 0.33; // threshold for dark-pixel detection in sampling image
float dotSizeMax = 0.7;         // relative size 0..1 of dots, can be also >1
float bpm = 131.747;
float imagePeriod = 4.0 * (60.0/bpm);     // time period (s) that each image is shown
int   imageIndex = 0;        // first image to show

// other vars
ArrayList<PImage> aImages = new ArrayList<PImage>();
float hueOffset = random(0, 0.2);
int   prevMillis=0;  // time keeping
float imageTime = 0.0;  // time shown for current image
float x, y;

void setup() {
  goFullScreen();
  colorMode(RGB, 1);
  background(0.90196); // 230 = E6
  //size(displayWidth, displayHeight);
  size(window.innerWidth * 0.9999999, window.innerHeight * 0.9999999);  
  //size(900,600); 
  noStroke();
  loadImages();
}

boolean sketchFullScreen() {
  return true;
}

function goFullScreen(){
    var canvas = document.getElementById("dance");
    if(canvas.requestFullScreen)
        canvas.requestFullScreen();
    else if(canvas.webkitRequestFullScreen)
        canvas.webkitRequestFullScreen();
    else if(canvas.mozRequestFullScreen)
        canvas.mozRequestFullScreen();
}

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
  for (float xs = dxs/2; xs <= (im.width-dxs/2) ; xs+=dxs ) {
    for (float ys = dys/2; ys < (im.height-dys/2) ; ys+=dys ) {
      c = im.get( (int)(round(xs)), (int)(round(ys)) );  // sample pixel
      if (brightness(c) < brightnessThresh) {  // if pixel dark...
        colorMode(HSB);
        fill(0.5+0.5*cos(hueOffset + 2*xs/im.width), 0.6+0.4*timeFraction, 0.6+0.4*timeFraction, timeFraction);  // draw shape
        ellipse(x + xs/dxs*dx, y + ys/dys*dy, dx*dotSizeScale, dy*dotSizeScale);
        //ellipse(x + ys/dys*dx, y + xs/dxs*dy, dx*dotSizeScale, dy*dotSizeScale); // rotated mode!
      }
    }
  }
}

void renderImageFull(PImage im, float x, float y, float hueOffset, float timeFraction) {
  color c;
  colorMode(HSB);
  tint(hueOffset, 0.4+0.5*timeFraction, 0.8+0.2*timeFraction, timeFraction);
  image(im, x, y);
}

void mouseClicked() {
  imageTime= imagePeriod; // skip to next period
  isRandomParty = false;
  if (mouseButton == RIGHT)
    isRandomParty = true;
}

void keyPressed() {
  switch(key) {
  case 'f':    
    imagePeriod /= 2.0; 
    break;
  case 's':    
    imagePeriod *= 2.0; 
    break;
  case 'r':
    isRandomParty = !isRandomParty;
    break;
  case '1':
    dxs /= 2.0; dys /= 2.0;
    break;
  case '2':
    dxs *= 2.0; dys *= 2.0;
    break;
  case '3':
    dx /= 1.5; dy /= 1.5; break;
  case '4':
    dx *= 1.5; dy *= 1.5; break;
  default:
    imageTime= imagePeriod; // skip to next period      
    isRandomParty = false;
    break;
  }
}

void draw() {
  //goFullScreen();  

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
    x = dx * round(random(0, width-280)/dx);
    y = dy * round(random(-32, height-290)/dy); 
  }

  float timeFraction = imageTime/imagePeriod ;

  // random party mode
  if (isRandomParty) {
    //x = dx * (sin(34.245*timeFraction) + width*0.05*timeFraction); //random(2, 50);
    //y = dy * (cos(23.343*timeFraction) + width*0.05*timeFraction); //random(2, 25);
    x = dx*random(-1, 60);
    y = dy*random(-1, 30);
  }

  // fade-out of previous image
  colorMode(RGB);
  fill(1, 1, 1, 0.044);
  rect(0, 0, width, height);

  // render new image of dots
  renderImageDots(aImages.get(imageIndex), x, y, hueOffset, timeFraction, dotSizeMax);
}


