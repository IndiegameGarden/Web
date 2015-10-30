/* @pjs font='m39.ttf' */

void addWorks() {
  work("dither","Dither");
  work("dance", "Dance!");
  work("arginino", null);
  work("VII", null);
  work("grid-location", "Grid Location");
  work("crashed-application", "crashed application");
  work("curved", "Curved");
  work("ultrasonic-reflections", "ultrasonic reflections");

  workJpg("indiegig", "IndieGig" ).hasNewline=true;
  exeJpg ("wreckz", "Glorious Wreckz Garden", "GloriousWreckzGarden.exe", 6249);
  exe ("igg", "Indiegame Garden", "Indiegame Garden 7.exe", 5513);
  work("quest14", "Quest for the Pixel Princess XIV");
  work("quest", "Quest for the Pixel Princess");
}

float lastInnerWidth, lastInnerHeight;
boolean isSelected = false;
float selx, sely; // mouse cursor pos of selected work
float dx=128; // grid
float dy=128;
float mbitPerSec = 4;
float tChange = 0;
int dxim=112; // image sz
int dyim=112;
String DOWNLOAD_DIR = "games";
String ICON_DIR = "images";
int MAX_COLS = 0;
int MAX_ROWS = 0;
float BRDx = ((dx-dxim)/2)/dx;
float BRDy = ((dy-dyim)/2)/dy;
int prevMillis = 0;
ArrayList<Work> aWorks = new ArrayList<Work>();
Work selWork = null;

// helper method 'icon'
Work icon(String id) {
  Work w = new Work(id, id, "png");
  w.isClickable = false;
  aWorks.add(w);
  return w;
}

// helper methods 'online work'
Work workAdd(String id, String title, String iconType) {
  Work w = new Work(id, title, iconType);
  aWorks.add(w);
  return w;
}
Work work(String id, String title) {
  return workAdd( id,  title,  "png");
}
Work workJpg(String id, String title) {
  return workAdd( id,  title,  "jpg");
}

// helper methods 'exe work'
Work exeAdd(String id, String title, String exeFile, int kbSize, String iconType) {
  Work w = new Work(id, title, iconType);
  w.isExe = true;
  w.exeFile = exeFile;
  w.kbSize = kbSize;
  aWorks.add(w);
  return w;
}
Work exe(String id, String title, String exeFile, int kbSize) {
   return exeAdd( id,  title,  exeFile,  kbSize, "png");
}
Work exeJpg(String id, String title, String exeFile, int kbSize) {
   return exeAdd(id,  title,  exeFile,  kbSize, "jpg");
}

void setup() {
  smooth();
  background(0);
  addWorks();
  lastInnerWidth = window.innerWidth;
  lastInnerHeight = window.innerHeight;
  MAX_COLS = floor(window.innerWidth * 0.9/dx);
  MAX_ROWS = 1+ceil(aWorks.size() / MAX_COLS );
  size(MAX_COLS * dx, MAX_ROWS * dy + (dy-dyim));
  PFont font;
  font = loadFont("m39.ttf");
  textFont(font,10);
  textAlign(LEFT);
}

void drawIcons(float dt) {
  PImage img;
  Work w;
  int n=0;
  //println("Drawing "+aWorks.size()+" works.");
  int x= 0;
  int y = 0;

  for (n=0; n < aWorks.size(); n++) {
    w = aWorks.get(n);
    if ( w.hasNewline && x > 0) {
      x=0;
      y++;
    }
    w.x = x;
    w.y = y;
    w.drawIt(dt);
    x++;
    if ( x >= MAX_COLS ) {
      x=0;
      y++;
    }
  }

  float bx = (dx-dxim)/2;
  float by = (dy-dyim)/2;
  w = findWork(selx, sely);
  if (isSelected && w!= null && w.isClickable) {
    selWork = w;
    w.rotateBy(dt/10.0);
    fill(255, 254, 253);
    String t = w.title;
    if (w.isExe) {
      t += " (" + w.mbSize() + " MB .EXE)";
    }
    tx = selx*dx+bx;
    ty = sely*dy+dy+by/4;
    text(t, tx-1,ty-1);
    text(t, tx+1,ty-1);
    text(t, tx-1,ty+1);
    text(t, tx+1,ty+1);
    fill(0, 14, 51);
    text(t, tx+0,ty+0);
  }

}

void changeWorksSlow(float dt) {
  float ox=selx, oy=sely;
  locateMouse();

  if ( random() < 0.004 ) {
    int n = (int) random(0,aWorks.size());
    w = aWorks.get(n);
    if (w.isClickable && w != selWork)
      w.changeIt(dt);
  }
}

void draw() {
  // time keeping
  float dt = ((float)(millis() - prevMillis))/1000;
  prevMillis = millis();

  // auto-resizing behaviour for browser
  if (lastInnerWidth != window.innerWidth || lastInnerHeight != window.innerHeight) {
    MAX_COLS = floor(window.innerWidth * 0.9/dx);
    MAX_ROWS = 1+ceil(aWorks.size() / MAX_COLS );
    size(MAX_COLS * dx, MAX_ROWS * dy + (dy-dyim));
    lastInnerWidth = window.innerWidth;
    lastInnerHeight = window.innerHeight;
  }

  background(0);
  changeWorksSlow(dt);
  drawIcons(dt);
}

Work findWork(float x, float y) {
  for (int i=0; i < aWorks.size(); i++) {
    Work w = aWorks.get(i);
    if (w.isLoaded && w.x==x && w.y==y)
      return w;
  }
  return null;
}

void locateMouse() {
  float xf = floor(mouseX/dx);
  float yf = floor(mouseY/dy);
  float xr = (mouseX/dx)-xf; // remainder part
  float yr = (mouseY/dy)-yf;
  // check within bounds of icon
  if (xr >= BRDx && xr <= (1.0-BRDx) && yr >= BRDy && yr <= (1.0-BRDy) ) {
    selx = (int) xf;
    sely = (int) yf;
    isSelected = true;
  }
  else {
    isSelected = false;
  }
  //println("xf="+xf+" yf="+yf+" xr="+xr+" yr="+yr+" isSel="+isSelected+" x="+x+" y="+y);
}

void mouseClicked() {
  locateMouse();
  Work w = findWork(selx, sely);
  //println("found w="+w.id+" isSel="+isSelected);
  if (w!=null && isSelected && w.isClickable) {
    //println("click ("+x+","+y+"): " + w.id );
    if (w.isExe && !w.isDownloading() ) {
      w.downloadIt();
      loadUrl(DOWNLOAD_DIR + "/" + w.exeFile , false);
    }
    else if (!w.isExe) {
      loadUrl(w.url,true);
    }
  }
}

void loadUrl(String url, boolean isOnlineWork) {
   window.open(url, "_self");
  //println("Loading "+url); // for Java mode testing
}



