/**
 * A single work (art or game etc) shown on the webpage
 */
class Work {

  float x, y; // grid placement

  String id;
  String name;
  String url;
  String title;
  boolean isExe = false;
  boolean isClickable = true;
  boolean hasNewline = false;
  boolean isDownloadin = false;
  String exeFile;
  int kbSize = 0;

  String iconFile;
  PImage icon, iconPart;
  boolean isLoaded= false;

  float circleAnim = 0.0;
  float circleAnimEnd = 5.0;
  float rot = 0.0;

  static PImage circMask;

  // drop-in replacement for pcircMask(m) syntax - to work around bug in js version of mask
  void alternateMask(Pimage p, Pimage m) {
    m.loadPixels();
    p.loadPixels();
    for (int j=p.width*p.height-1; j >= 0; j--) {
      p.pixels[j] = p.pixels[j] & 0x00FFFFFF |    ((m.pixels[j] & 0x000000FF) << 24);
    }
    p.updatePixels();
  }

  public Work(String id, String titlePar, String iconType) {
    this.id = id;
    this.name = id;
    this.url = id;
    this.iconFile = ICON_DIR + "/" + id + "." + iconType;
    if (titlePar==null)
      this.title = id;
    else
      this.title = titlePar;
    if (circMask == null) {
      circMask = createGraphics(dxim,dyim);
      circMask.beginDraw();
      circMask.background(0);
      circMask.fill(255);
      circMask.stroke(255);
      circMask.ellipse(dxim/2,dyim/2,dxim,dyim);
      circMask.endDraw();
    }
    loadIcon(iconFile);
  }

  public boolean isDownloading() {
    return isDownloadin && circleAnimEnd > 0.0;
  }

  public float mbSize() {
    return round(kbSize/102.4) / 10.0;
  }

  public float rotateBy(float r) {
    rot += r;
  }

  public void drawIt(float dt) {
    if (isLoaded) {
      float bx = (dx-dxim)/2;
      float by = (dy-dyim)/2;
      pushMatrix();
      translate((x*dx+bx)+dxim/2, (y*dy+by)+dyim/2);
      rotate(rot);
      image(iconPart, -dxim/2,-dyim/2); //x*dx+bx, y*dy+by);
      popMatrix();

      if (isDownloadin && (circleAnimEnd > 0.0)) {
        //fill(255, 255, 255, 210);
        //noStroke();
        //rect(x*dx, y*dy, dx, dy);
        strokeCap(ROUND);
        noFill();
        strokeWeight(14);
        stroke(250, 80, 70, 190);
        arc(x*dx+dx/2, y*dy+dy/2, ((float)dxim)/1.5, ((float)dyim)/1.5, 0, TWO_PI * circleAnim/circleAnimEnd );
        circleAnim += dt;
        if (circleAnim >= circleAnimEnd) {
          circleAnimEnd = 0.0;
        }
      }
    }
    else
    {
      // test now if icon loaded!
      if (icon.width > 0) {
        isLoaded = true;
        grabRandomIconPart(dxim, dyim);
      }else{
        fill(255, 255, 255, 210);
        noStroke();
        strokeCap(ROUND);
        strokeWeight(14);
        stroke(250, 80, 70, 190);
        ellipse(x*dx+dx/2, y*dy+dy/2, circleAnim/circleAnimEnd*((float)dxim)/1.5, circleAnim/circleAnimEnd*((float)dyim)/1.5);
        //arc(x*dx+dx/2, y*dy+dy/2, ((float)dxim)/1.5, ((float)dyim)/1.5, 0, TWO_PI * circleAnim/circleAnimEnd );
        circleAnim += dt;
      }
    }
  }

  public void changeIt() {
    grabRandomIconPart(dxim, dyim);
  }

  public void downloadIt() {
    if (!isDownloadin) {
      circleAnim = 0.0;
      circleAnimEnd = (8*kbSize/1024)/(mbitPerSec);
      isDownloadin = true;
    }
  }

  void grabRandomIconPart(int w, int h) {
    int x0 = icon.width - w;
    int y0 = icon.height - h;
    if (x0>=0 || y0>=0)
      iconPart = icon.get((int)round(random(0, x0+1)), (int)round(random(0, y0+1)), w, h);
    else
      iconPart = icon;
    // apply mask to iconpart
    alternateMask(iconPart,circMask);
    //circMaskcircMask(iconPart);
    //iconPart = circMask;
  }

  void loadIcon(String fn) {
    //println("loading "+fn);
    icon = loadImage(fn);
  }

  public String toString() {
    return id;
  }
}

