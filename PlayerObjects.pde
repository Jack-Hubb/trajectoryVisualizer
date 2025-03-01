class Projectile extends Polygon {
  float x, y;
  float drag = 2;
  float bounceAmount = 10, pBounceAmount;
  float weight;
  float friction;
  float initX, initY;
  final float tDur = 3;
  // CHANGE ACCORDINGLY in the constructor
  float bouncyness;
  float bouncynessFalloff;
  float launchAngle;
  float distance;
  float launchScale;

  boolean inAir = true;
  boolean lookingForCatapult = true;
  boolean inCatapult;
  boolean isHolding = false;
  boolean showTrajectoryLine = true;  // false by default
  boolean allowedToBeHeld = true;
  boolean isFired = false;


  PVector velocity = new PVector();
  PVector projVelocity = new PVector();
  PVector initV = new PVector();
  PVector mouseLocation = new PVector(mouseX, mouseY);
  color fillColor;

  PVector[] trajectoryPoints;

  Projectile(float x, float y, String name ) {
    addPoint(-30, 30);
    addPoint(30, 30);
    addPoint(0, -30);
    addPoint(-30, 30);
    recalc();
    this.x = x;
    this.y = y;

    //velocity.x = 200;

    if (name == "RUBBER") {
      drag = 15;
      friction = 30;
      bouncyness = 800;
      bouncynessFalloff = 50;
      setColor(#050505);
    } else if (name == "METAL") {
      drag = 15;
      friction = 5;
      bouncyness = 100;
      bouncynessFalloff = 50;
      setColor(#313131);
    } else if (name == "WOOD") {
      drag = 35;
      friction = 28;
      bouncyness = 200;
      bouncynessFalloff = 100;
      setColor(#763007);
    } else if (name == "PAPER") {
      drag = 100;
      friction = 20;
      bouncyness = 50;
      bouncynessFalloff = 0;
      setColor(#AFA29A);
    }

    int tPoints = int(tDur / dt) + 1;
    trajectoryPoints = new PVector[tPoints];
    for (int i = 0; i < tPoints; i++) {
      trajectoryPoints[i] = new PVector();
    }
  }

  void update() {
    super.update();
    pBounceAmount = bounceAmount;
    calcAngleToCat();
    println(launchAngle);


    mouseLocation.x = mouseX;
    mouseLocation.y = mouseY;
    float anchorX = 270;
    float anchorY = height - 330;

    if (inCatapult) {
      distance = sqrt(sq(anchorY - y)+sq(anchorX - x));
launchScale = 4;
      initX = x;
      initY = y;
      projVelocity.x = cos(launchAngle) *  distance * launchScale;
      projVelocity.y = sin(launchAngle) *  distance * launchScale;
      updateTrajectory(initX, initY, projVelocity, 5);
      if (mousePressed && checkCollisionPoint(mouseLocation)) {
        isHolding = true;
        allowedToBeHeld = true;
      }

      if (isHolding) {
        x = mouseX;
        y = mouseY;
      } else {

        x = anchorX;
        y = anchorY;
      }


      if (!mousePressed && isHolding) {

        distance = sqrt(sq(anchorY - y)+sq(anchorX - x));
        launchScale = 4;


        velocity.x = cos(launchAngle) *  distance * launchScale;
        velocity.y = sin(launchAngle) *  distance * launchScale;


        inCatapult = false;
        isHolding = false;
        allowedToBeHeld = false;
        isFired = true;

        initX = x;
        initY = y;
        initV = velocity.copy();

        updateTrajectory(initX, initY, initV, 5);
        inAir = true;
      }
    } else {
      // When not in the catapult, apply gravity and regular physics

      if (inAir) {
        velocity.y += gravity * dt;
        velocity.x -= drag * dt;
        //change
        if (velocity.x <= 0) velocity.x = 0;
        x += velocity.x * dt;
        y += velocity.y * dt;
      } else {
        velocity.y += gravity * dt;
        x += velocity.x - friction * dt;
        y += velocity.y * dt;
      }
    }




    if (allowedToBeHeld) {
      if (Mouse.onDown(Mouse.LEFT)) {
        if (checkCollisionPoint(mouseLocation)) isHolding = true;
      } else if (!Mouse.onDown(Mouse.LEFT)) isHolding = false;
    }

    if (isHolding) {
      x = mouseX;
      y = mouseY;
    } else {
    }

    if (y >= height-180) {
      velocity.y = -bouncyness;
      bounceAmount--;
      Bounce();
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

    if (isFired) {
      drawTrajectory(trajectoryPoints);
    } else if (inCatapult) {
      drawTrajectory(trajectoryPoints);
    }
    super.draw();
  }

  void Bounce() {
    initX = x;
    initY = y;
    initV = velocity.copy();
    updateTrajectory(initX, initY, initV, 5);
  }

  void calcAngleToCat() {
    float catX = 270;
    float catY = height - 330;
    launchAngle = atan2(mouseY - catY, mouseX - catX ) + PI;
  }



  void updateTrajectory(float initX, float initY, PVector initVel, float dur) {
    int nPoints = trajectoryPoints.length;
    for (int i = 0; i < nPoints; i++) {
      float elapsedTime = i * dt;
      float x = initX + initVel.x * elapsedTime;
      float y = initY + initVel.y * elapsedTime + 0.5 * gravity * sq(elapsedTime);

      trajectoryPoints[i].x = x;
      trajectoryPoints[i].y = y;
    }
  }

  void drawTrajectory(PVector[] trajectoryPoints) {
    stroke(0);
    strokeWeight(1);
    noFill();

    beginShape();
    for (PVector p : trajectoryPoints) {
      vertex(p.x, p.y);
    }
    endShape();
  }


  //pshape
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
    setColor(255);
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
