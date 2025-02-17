
class AABB {
  private boolean colliding = false;

  private float xmin, xmax, ymin, ymax;

  //resets colliding boolean
  public void resetColliding() {
    colliding = false;
  }

  public void recalc(PVector[] points) {
    for ( int i = 0; i < points.length; i++) {
      PVector p = points[i];
      if (i == 0 || p.x < xmin) xmin = p.x;
      if (i == 0 || p.x > xmax) xmax = p.x;
      if (i == 0 || p.y < ymin) ymin = p.y;
      if (i == 0 || p.y > ymax) ymax = p.y;
    }
  }

  public boolean checkCollision(AABB aabb) {
    if (xmax < aabb.xmin)return false;
    if (xmin > aabb.xmax)return false;
    if (ymax < aabb.ymin)return false;
    if (ymin > aabb.ymax)return false;
    colliding = true;
    aabb.colliding = true;
    return true;
  }
}

class Polygon {
  private boolean colliding = false;
  private boolean doneChecking = false;
  private boolean dirty = true;

  private ArrayList<PVector> points = new ArrayList<PVector>();
  private PVector[] pointsTransformed;
  private PVector[] normals;

  AABB aabb = new AABB();

  private float rotation = 0;
  private float scale = 1;
  private PVector position = new PVector(width/2, height/2);

  public float getScale() {
    return scale;
  }
  public float getRotation() {
    return rotation;
  }
  public PVector getPosition() {
    return position.copy();
  }

  public void setScale(float s) {
    scale = s;
    dirty = true;
  }
  public void setRotation(float r) {
    rotation = r;
    dirty = true;
  }
  public void setPosition(PVector p) {
    position = p.copy();
    dirty = true;
  }

  void update() {
    doneChecking = false;
    colliding = false;
    aabb.resetColliding();

    if (dirty) recalc();
  }

  void recalc() {

    dirty = false;

    //transform matrix
    PMatrix2D matrix = new PMatrix2D();
    matrix.translate(position.x, position.y);
    matrix.rotate(rotation);
    matrix.scale(scale);

    //calc transforms
    pointsTransformed = new PVector[points.size()];
    for (int i = 0; i < points.size(); i++) {
      PVector p = new PVector();
      matrix.mult(points.get(i), p);
      pointsTransformed[i] = p;
    }

    // calc normals
    normals = new PVector[pointsTransformed.length];
    for (int i =0; i < pointsTransformed.length; i++) {
      int j = i + 1;
      if (i >= pointsTransformed.length - 1) j = 0;
      PVector n = new PVector(pointsTransformed[i].y - pointsTransformed[j].y, pointsTransformed[j].x - pointsTransformed[i].x);
      normals[i] = n;
    }

    aabb.recalc(pointsTransformed);
  }

  void draw() {
    fill(255);

    beginShape();
    for (int i = 0; i < pointsTransformed.length; i++) {
      vertex(pointsTransformed[i].x,pointsTransformed[i].y);
    }
    endShape();

    // might need for debug
    // aabb.draw();
  }


  void addPoint(PVector p) {
    addPoint(p.x, p.y);
  }

  void addPoint(float x, float y) {
    points.add(new PVector(x, y));
  }

  void checkCollisions(ArrayList<Polygon> shapes) {
    for ( Polygon p : shapes) {
      if (p == this) continue;
      if (p.doneChecking == true) continue;
      if (checkCollision(p)) {
        colliding = true;
        p.colliding = true;
      }
    }
    doneChecking = true;
  }

  MinMax projectAlongAxis(PVector axis) {
    MinMax mm = new MinMax();
    int i = 0;
    for (PVector tp : pointsTransformed) {
      float d = tp.dot(axis);
      if (i == 0) {
        mm.min = d;
        mm.max = d;
      } else {
        if (d < mm.min) mm.min = d;
        if (d > mm.max) mm.max = d;
      }
      i++;
    }
    return mm;
  }



  boolean checkCollision(Polygon poly) {
    if (aabb.checkCollision(poly.aabb)) {

      ArrayList<PVector> axes = new ArrayList<>();

      for (PVector normal : normals) {
        axes.add(normal.copy().normalize());
      }
      for (PVector normal : poly.normals) {
        axes.add(normal.copy().normalize());
      }

      //check for seperation using min max
      for (PVector axis : axes) {
        MinMax mm1 = projectAlongAxis(axis);
        MinMax mm2 = poly.projectAlongAxis(axis);
        //check gap
        if (mm1.max < mm2.min || mm2.max < mm1.min) {
          //no collision
          return false;
        }
      }
      return true;
    }
    return false;
  }
}



class MinMax {
  float min = 0;
  float max = 0;
}
