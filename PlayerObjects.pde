class Projectile extends Polygon {
  float x, y;
  float drag = 2;
  float bounceAmount = 10, pBounceAmount;
  float weight;
  float friction;
  // CHANGE ACCORDINGLY
  float bouncyness = 100;
  float bouncynessFalloff;
  
  boolean lookingForCatapult = true;
  boolean inCatapult;
  boolean isHolding = false;
  boolean showTrajectoryLine = true;  // false by default
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
    
    velocity.x = 200;

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

    if (inCatapult) {
      x = 100;
      y = height - 200;
      allowedToBeHeld = false;
    } else if (!inCatapult) {
      velocity.y += gravity  * dt;
    }

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

  void draw() {
    super.draw();
    if (showTrajectoryLine) {
      drawTrajectory(x, y, velocity, 5);
    }
  }
}

void drawTrajectory(float initX, float initY, PVector initVel, float dur) {
  stroke(0);
  noFill();
  //start line
  beginShape();
  //time loop through duration of line drawn this case 5 seconds
  for (float elapsedTime = 0; elapsedTime <= dur; elapsedTime += dt) {
    float x = initX + initVel.x * elapsedTime;  // x using horizontal formula
    float y = initY + initVel.y * elapsedTime + 0.5 * gravity * sq(elapsedTime) ; // y through vertical formula however the /2 in formula gave weird bugs so its been removed
    vertex(x, y);
  }
  endShape();
}


class SlingShot extends Polygon {
  PVector position = new PVector();
  SlingShot(float x, float y) {
    position.x = x;
    position.y = y;

    addPoint(10, 10);
    addPoint(10, 20);
    addPoint(20, 20);
    addPoint(20, 10);
    addPoint(10, 10);
    setScale(8);
    recalc();

    setPosition(new PVector(x-50, y-100));
  }

  void update() {
    super.update();
  }

  void draw() {
    super.draw();
  }
}
// need to make velocity x and y influinced by drag and weight

//bounce bugs are its only up and down and object continues to go down

// need to change collision to fit project
