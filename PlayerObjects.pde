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

  Projectile(String name ) {
    addPoint(-30, 30);
    addPoint(30, 30);
    addPoint(0, -30);
    addPoint(-30, 30);
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
      if(-bouncyness >= -10)y = height - 180;
      
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
