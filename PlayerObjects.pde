class Projectile extends Polygon {
  float x, y;
  float drag = 2;
  float bounceAmount, pBounceAmount;
  float weight;
  float friction;
  // CHANGE ACCORDINGLY
  float bouncyness = 1200;

  PVector velocity = new PVector();

  Projectile() {
    addPoint(-10, 10);
    addPoint(10, 10);
    addPoint(0, -10);
    addPoint(-10, 10);
    recalc();
    x = width/2;
    y = height/2;
  }

  void update() {
    super.update();
    pBounceAmount = bounceAmount;
    velocity.y += gravity * dt;

    x += velocity.x * dt;
    y += velocity.y * dt;

    setPosition( new PVector(x, y));

    if (y>= height-50) {

      velocity.y = -bouncyness;
      bounceAmount--;
    }
    if (pBounceAmount > bounceAmount) bouncyness -= 200;
    if (bouncyness <= 0) bouncyness = 0;
  }
}
// need to make velocity x and y influinced by drag and weight 

//bounce bugs are its only up and down and object continues to go down

// need to change collision to fit project
