class TowerPart extends Polygon {
  PVector position = new PVector();
  float health = 100;

  TowerPart(float x, float y, float w, float h) {
    position.x = x;
    position.y = y;
    addPoint(-30, 60);
    addPoint(30, 60);
    addPoint(30, -60);
    addPoint(-30, -60);
    //addPoint(30, 60);
    recalc();
    setPosition(position);
  }

  void update() {
    super.update();
  }

  void draw() {
    setColor(0);
    super.draw();
  }
}
