class Projectile extends Polygon {
  float x, y;
  float drag = 2;
  float bounceAmount = 10, pBounceAmount;
  float weight;
  float friction;
  // CHANGE ACCORDINGLY
  float bouncyness = 100;
  float bouncynessFalloff;
  boolean inCatapult;
  boolean isHolding = false;
  boolean allowedToBeHeld = true;
  PVector velocity = new PVector();
  color fillColor;

  Projectile(float x, float y, String name ) {
    addPoint(-30, 30);
    addPoint(30, 30);
    addPoint(0, -30);
    addPoint(-30, 30);
    recalc();
    this.x = x;
    this.y = y;
    if (name == "RUBBER") {
      drag = 15;
      weight = .2;
      friction = 100;
      bouncyness = 800;
      bouncynessFalloff = 50;
      fillColor = #050505;
    } else if (name == "METAL") {
      drag = 15;
      weight = 50;
      friction = 100;
      bouncyness = 800;
      bouncynessFalloff = 50;
      fillColor = #313131;
    } else if (name == "WOOD") {
      drag = 35;
      weight = 25;
      friction = 100;
      bouncyness = 200;
      bouncynessFalloff = 100;
      fillColor = #763007;
    } else if (name == "PAPER") {
      drag = 100;
      weight = 1;
      friction = 60;
      bouncyness = 0;
      bouncynessFalloff = 0;
      fillColor = #AFA29A;
    }
  }

  void update() {
    super.update();
    pBounceAmount = bounceAmount;
    velocity.y += gravity  * dt;

    x += velocity.x * dt;
    y += velocity.y * dt;
    if (allowedToBeHeld) {
      if (Mouse.onDown(Mouse.LEFT)) {
        if (checkCollisionPoint(new PVector(mouseX, mouseY))) isHolding = true;
      } else if (!Mouse.onDown(Mouse.LEFT)) isHolding = false;
    }

    if (isHolding) {
      x = mouseX;
      y = mouseY;
    }

    if (y >= height-180) {
      velocity.y = -bouncyness;
      bounceAmount--;
      if (-bouncyness >= -10)y = height - 180;
    }




    if (pBounceAmount > bounceAmount) bouncyness -= bouncynessFalloff;
    if (bouncyness <= 0) {
      bouncyness = 0;
    }
    setPosition( new PVector(x, y));
    fill(fillColor);
  }
}
// need to make velocity x and y influinced by drag and weight

//bounce bugs are its only up and down and object continues to go down

// need to change collision to fit project
