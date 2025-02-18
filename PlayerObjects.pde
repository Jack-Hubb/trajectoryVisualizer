class Projectile extends Polygon {
  float x, y;
  float drag = 2;
  float bounceAmount = 10, pBounceAmount;
  float weight;
  float friction;
  // CHANGE ACCORDINGLY
  float bouncyness = 800;
  float bouncynessFalloff;
  boolean inCatapult;

  PVector velocity = new PVector();

  Projectile(String name ) {
    addPoint(-10, 10);
    addPoint(10, 10);
    addPoint(0, -10);
    addPoint(-10, 10);
    recalc();
    x = width/2;
    y = height/2;
    if (name == "RUBBER") {
      drag = 2;
      weight = 5;
      friction = 100;
      bouncyness = 800;
      bouncynessFalloff = 50;
    }
  }

  void update() {
    super.update();
    pBounceAmount = bounceAmount;
    velocity.y += gravity * dt;

    x += velocity.x * dt;
    y += velocity.y * dt;



    if (y >= height-150) {

      velocity.y = -bouncyness;
      bounceAmount--;
    } else if ( y > height - 150) {
      y = height - 150;
      velocity.y = 0;
    }
    if (pBounceAmount > bounceAmount) bouncyness -= bouncynessFalloff;
    if (bouncyness <= 0) {
      bouncyness = 0;
    }
    setPosition( new PVector(x, y));
  }
}
// need to make velocity x and y influinced by drag and weight

//bounce bugs are its only up and down and object continues to go down

// need to change collision to fit project
