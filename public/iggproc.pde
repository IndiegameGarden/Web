/* @pjs font='m39.ttf' */

void addWorks() {
  yr(2014);
  icon("2014");
  work("dance", "Dance!");
  work("arginino", null);
  work("VII", null);
  yr(2013);
  icon("2013");
  work("quest14", "Quest for the Pixel Princess XIV");
  //exeJpg ("wreckz", "Glorious Wreckz Garden", "GloriousWreckzGarden.exe", 6249);
  yr(2012);
  icon("2012");
  //exe ("igg", "Indiegame Garden", "Indiegame Garden 7.exe", 5513);
  work("quest", "Quest for the Pixel Princess");
  icon("2002");
  work("grid-location", "Grid Location");
  work("crashed-application", "crashed application");
  work("curved", "Curved");
  work("ultrasonic-reflections", "ultrasonic reflections");
}

float lastInnerWidth, lastInnerHeight;
boolean isSelected = false;
float selx, sely; // mouse cursor pos of selected work
float dx=128; // grid
float dy=128;
float mbitPerSec = 5;
float tChange = 0;
int dxim=126; // image sz
int dyim=126;
String DOWNLOAD_DIR = "games";
String ICON_DIR = "images";
int MAX_COLS = 6;
float BRDx = ((dx-dxim)/2)/dx;
float BRDy = ((dy-dyim)/2)/dy;
int curYear = 0;
int prevMillis = 0;
ArrayList<Work> aWorks = new ArrayList<Work>();
int selWork = 0;

// helper method 'set new year'
void yr(int yr) {
  curYear = yr;
}

// helper method 'icon'
void icon(String id) {
  Work w = new Work(id, curYear, id, "png");
  w.isClickable = false;
  //w.hasNewline = true;
  aWorks.add(w);
}

// helper methods 'online work'
void workAdd(String id, String title, String iconType) {
  Work w = new Work(id, curYear, title, iconType);
  aWorks.add(w);
}
void work(String id, String title) {
  workAdd( id,  title,  "png");
}
void workJpg(String id, String title) {
  workAdd( id,  title,  "jpg");
}

// helper methods 'exe work'
void exeAdd(String id, String title, String exeFile, int kbSize, String iconType) {
  Work w = new Work(id, curYear, title, iconType);
  w.isExe = true;
  w.exeFile = exeFile;
  w.kbSize = kbSize;
  aWorks.add(w);
}
void exe(String id, String title, String exeFile, int kbSize) {
   exeAdd( id,  title,  exeFile,  kbSize, "png");
}
void exeJpg(String id, String title, String exeFile, int kbSize) {
   exeAdd(id,  title,  exeFile,  kbSize, "jpg");
}

void setup() {
  smooth();
  background(255);
  addWorks();
  lastInnerWidth = window.innerWidth;
  lastInnerHeight = window.innerHeight;
  MAX_COLS = floor(window.innerWidth * 0.9/dx);
  MAX_ROWS = ceil(aWorks.size() / MAX_COLS );
  size(MAX_COLS * dx, MAX_ROWS * dy + (dy-dyim));
  PFont font;
  font = loadFont("m39.ttf");
  textFont(font,10);
  textAlign(LEFT);
}

void drawPixelFxBars(float dt, int Niter) {
  for ( int i=0 ; i < Niter; i++ ) {
    int x = (int) random(0, width);
    int y = (int) random(0, height);
    int w = (int) random(-30, 30);
    color c1 = get(x, y);
    //color c2 = get(x+1, y);
    float dif = 0; //abs(brightness(c1)-brightness(c2));
    if (dif >= 0 ) {
      float x0;
      float dx0= 1.0/((float)abs(w));
      int j=0;
      color c;
      for (x0=0; x0 <= 1; x0+=dx0) {
        c=lerpColor(#FFFFFF, c1, x0);
        set(x+j, y, c);
        if (w>=0)
          j++;
        else
          j--;
      }
    }
  }
}

void drawDiffusion(float dt) {
  int x = mouseX;
  int y = mouseY;
  x+=random(-68, 68);
  y+=random(-68, 68);
  for (int i=0; i < 100; i++) {
    int rx = (int) round(	(-2, 2));
    int ry = (int) round(random(-2, 2));
    // direction random , color fades. lerp to interpolate.
    color c1 = get(x, y);
    color c2 = get(x+rx, y+ry);
    set(x+rx, y+ry, lerpColor(c1, c2, 0.5));
    x+=random(-4,3);
    y+=random(-3,4);
  }
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
    if ( w.hasNewline && n > 0 ) {
      x=0;
      y++;
    }
    if ( !w.isClickable && x >= MAX_COLS-1 ) {
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
  if (w!= null && w.isClickable) {
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

void changeWorks(float dt) {
  float ox=selx, oy=sely;
  locateMouse();
  Work w = findWork(selx, sely);
  if (selx!=ox || sely!=oy) {
    if (w!=null) w.changeIt();
  }
  tChange += dt;
  if (tChange > ((randomGaussian()/2) + 3.0) ) {
  	tChange = 0;
  	w = aWorks.get(selWork);
  	if (w.isClickable)
  		w.changeIt();
  	selWork++;
  	if (selWork >= aWorks.size())
  		selWork = 0;
  }
}

void draw() {
  // time keeping
  float dt = ((float)(millis() - prevMillis))/1000;
  prevMillis = millis();

  // auto-resizing behaviour for browser
  if (lastInnerWidth != window.innerWidth || lastInnerHeight != window.innerHeight) {
    MAX_COLS = floor(window.innerWidth * 0.9/dx);
    MAX_ROWS = ceil(aWorks.size() / MAX_COLS );
    size(MAX_COLS * dx, MAX_ROWS * dy + (dy-dyim));
    background(0);
    lastInnerWidth = window.innerWidth;
    lastInnerHeight = window.innerHeight;
  }

  background(255);
  changeWorks(dt);
  drawIcons(dt);
  //drawPixelFxBars(dt, 30);
  //drawDiffusion(dt);
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


class Work {

  float x, y; // grid placement

  String id;
  String name;
  String url;
  int year;
  String title;
  boolean isExe = false;
  boolean isClickable = true;
  boolean hasNewline = false;
  String exeFile;
  int kbSize = 0;

  String iconFile;
  PImage icon, iconPart;
  boolean isLoaded= false;

  float circleAnim = 0.0;
  float circleAnimEnd = 0.0;

  public Work(String id, int year, String titlePar, String iconType) {
    this.id = id;
    this.year = year;
    this.name = id;
    this.url = id;
    this.iconFile = ICON_DIR + "/" + id + "." + iconType;
    if (titlePar==null)
      this.title = id;
    else
      this.title = titlePar;
    loadIcon(iconFile);
  }

  public boolean isDownloading() {
    return circleAnimEnd > 0.0;
  }

  public float mbSize() {
    return round(kbSize/102.4) / 10.0;
  }

  public void drawIt(float dt) {
    if (isLoaded) {
      float bx = (dx-dxim)/2;
      float by = (dy-dyim)/2;
      image(iconPart, x*dx+bx, y*dy+by);

      if (circleAnimEnd > 0.0) {
        fill(255, 255, 255, 210);
        noStroke();
        rect(x*dx, y*dy, dx, dy);
        strokeCap(ROUND);
        noFill();
        //strokeWeight(12);
        //stroke(5,5,5,220);
        //arc(x*dx+dxim/2,y*dy+dyim/2, ((float)dxim)/1.6, ((float)dyim)/1.6, 0, TWO_PI * circleAnim/circleAnimEnd );
        strokeWeight(14);
        stroke(250, 80, 70, 190);
        arc(x*dx+dx/2, y*dy+dy/2, ((float)dxim)/1.5, ((float)dyim)/1.5, 0, TWO_PI * circleAnim/circleAnimEnd );
        circleAnim += dt;
        if (circleAnim >= circleAnimEnd) {
          circleAnimEnd = 0.0;
        }
      }
    }
    else {
      // test now if icon loaded!
      if (icon.width > 0) {
        isLoaded = true;
        grabRandomIconPart(dxim, dyim);
      }
    }
  }

  public void changeIt() {
    grabRandomIconPart(dxim, dyim);
  }

  public void downloadIt() {
    if (circleAnimEnd==0) {
      circleAnim = 0.0;
      circleAnimEnd = (8*kbSize/1024)/(mbitPerSec);
    }
  }

  void grabRandomIconPart(int w, int h) {
    int x0 = icon.width - w;
    int y0 = icon.height - h;
    if (x0>=0 || y0>=0)
      iconPart = icon.get((int)round(random(0, x0+1)), (int)round(random(0, y0+1)), w, h);
    else
      iconPart = icon;
  }

  void loadIcon(String fn) {
    //println("loading "+fn);
    icon = loadImage(fn);
  }

  public String toString() {
    return id;
  }
}


