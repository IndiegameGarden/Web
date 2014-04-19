
class Work {

  float x, y; // grid placement

  String id;
  String name;
  String url;
  int year;
  String title;
  boolean isExe = false;
  boolean isClickable = true;
  String exeFile;
  int kbSize = 0;

  String iconFile;
  PImage icon, iconPart;
  boolean isLoaded= false;

  float circleAnim = 0.0;
  float circleAnimEnd = 0.0;

  public Work(String id, int year, String title) {
    this.id = id;
    this.year = year;
    this.name = id;
    this.url = id;
    this.iconFile = ICON_DIR + "/" + id + ".png";
    if (title==null)
      this.title = id;
    else
      this.title = title;
    loadIcon(iconFile);
  }

  public boolean isDownloading() {
    return circleAnimEnd > 0.0;
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

