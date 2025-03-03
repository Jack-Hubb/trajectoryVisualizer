class TowerPart extends Polygon {
  PVector position = new PVector();
  float health = 100;

  TowerPart(float x, float y, float w, float h) {
    position.x = x;
    position.y = y;
    addPoint(position.x, position.y);
    addPoint(position.x + w, position.y);
    addPoint(position.x + w, position.y + h);
    addPoint(position.x, position.y + h);
    addPoint(position.x, position.y);
    recalc();
  }
}
