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
  float anchorX, anchorY;

  boolean inAir = true;
  boolean lookingForCatapult = true;
  boolean inCatapult;
  boolean isHolding = false;
  boolean showTrajectoryLine = true;  // false by default
  boolean allowedToBeHeld = true;
  boolean isFired = false;
  boolean normallyBounces;


  PVector velocity = new PVector();
  PVector projVelocity = new PVector();
  PVector initV = new PVector();
  PVector mouseLocation = new PVector(mouseX, mouseY);
  color fillColor;

  PVector[] trajectoryPoints;

  Projectile(float x, float y, String name ) {

    this.x = x;
    this.y = y;

    //velocity.x = 200;

    if (name == "RUBBER") {
      drag = 100;
      friction = 30;
      bouncyness = 800;
      bouncynessFalloff = 50;
      normallyBounces = true;
      addPoint(-20, -30);
      addPoint(20, -30);
      addPoint(40, -10);
      addPoint(20, 20);
      addPoint(-20, 30);
      addPoint(-40, 0);
      recalc();
      setColor(#050505);
    } else if (name == "METAL") {
      drag = 200;
      friction = 5;
      bouncyness = 100;
      bouncynessFalloff = 50;
      addPoint(-50, -20);
      addPoint(50, -20);
      addPoint(70, 40);
      addPoint(0, 70);
      addPoint(-70, 40);
      recalc();
      setColor(#313131);
    } else if (name == "WOOD") {
      drag = 150;
      friction = 250;
      bouncyness = 200;
      bouncynessFalloff = 50;
      normallyBounces = false;
      addPoint(-50, -30);
      addPoint(50, -40);
      addPoint(60, 20);
      addPoint(40, 50);
      addPoint(-30, 40);
      addPoint(-40, 10);
      recalc();
      setColor(#763007);
    } else if (name == "PAPER") {
      drag = 300;
      friction = 50;
      bouncyness = 50;
      bouncynessFalloff = 0;
      normallyBounces = false;
      addPoint(-40, -20);
      addPoint(40, -20);
      addPoint(30, 30);
      addPoint(-50, 30);
      recalc();
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

    println(inAir);

    mouseLocation.x = mouseX;
    mouseLocation.y = mouseY;
    anchorX = 270;
    anchorY = height - 330;

    if (getColliding()) {
      inAir = false;
    } else if (!getColliding()) {
      inAir = true;
    }



    if (y >= height-180) {
      velocity.y = -bouncyness;
      bounceAmount--;
      Bounce();
      if (-bouncyness >= -10)y = height - 180;
      inAir = false;
    } else {
      inAir = true;
    }



    if (inCatapult) {

      distance = sqrt(sq(anchorY - y)+sq(anchorX - x));
      launchScale = 5;
      initX = x;
      initY = y;
      projVelocity.x = cos(launchAngle) *  distance * launchScale;
      projVelocity.y = sin(launchAngle) *  distance * launchScale;
      projVelocity.x -= drag*.5;

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
        launchScale = 5;


        velocity.x = cos(launchAngle) *  distance * launchScale;
        velocity.y = sin(launchAngle) *  distance * launchScale;
        projVelocity = velocity.copy();
        projVelocity.x -= drag*.5;

        inCatapult = false;
        isHolding = false;
        allowedToBeHeld = false;
        isFired = true;

        initX = x;
        initY = y;

        updateTrajectory(initX, initY, projVelocity, 5);
        inAir = true;
         println("i happened");
      }
    } else {
      // When not in the catapult, apply gravity and regular physics

      if (inAir == true) {
        velocity.y += gravity * dt;
        velocity.x -= drag * dt;
        //change
        if (velocity.x <= 0) velocity.x = 0;
        x += velocity.x * dt;
        y += velocity.y * dt;
      } else if (inAir != true ) {
        velocity.y += gravity * dt;
        velocity.x -= friction * dt;
         if (velocity.x <= 0) velocity.x = 0;
        x += velocity.x * dt;
        y += velocity.y * dt;
        println("i happened");
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
      inAir = false;
    } else {
      inAir = true;
    }




    if (pBounceAmount > bounceAmount) bouncyness -= bouncynessFalloff;
    if (bouncyness <= 0) {
      bouncyness = 0;
    }
    setPosition( new PVector(x, y));
    fill(fillColor);
  }

  void draw() {
    textSize(15);
    if (isFired) {
      drawTrajectory(trajectoryPoints);
      fill(0);
      text("X Velocity: " + round(velocity.x) + " M/s", x, y - 100);
      text("Y Velocity: " + round(projVelocity.y * -1) + " M/s", x, y - 80);
    } else if (inCatapult && isHolding) {
      drawTrajectory(trajectoryPoints);
      fill(0);
      strokeWeight(6);
      line(x, y, anchorX, anchorY);
      strokeWeight(1);
      text("X Velocity: " + round(projVelocity.x) + " M/s", x, y - 100);
      text("Y Velocity: " + round(projVelocity.y * -1) + " M/s", x, y - 80);
      text("Launch Angle: " + (round(degrees(atan2(x -anchorX, y - anchorY))) * -1)  + " Degrees", x, y - 60);
    }
    super.draw();
  }

  void Bounce() {
    if (normallyBounces) {
      initX = x;
      initY = y;
      initV = velocity.copy();
      updateTrajectory(initX, initY, initV, 5);
    } else {

      initX = 9999999;
      initY = 9999999;
      initV = velocity.copy();
      updateTrajectory(initX, initY, initV, 5);
    }
  }
  void calcAngleToCat() {
    float catX = 270;
    float catY = height - 330;
    launchAngle = atan2(y - catY, x - catX ) + PI;
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
    noStroke();
    super.draw();
    stroke(1);

    fill(0);
    rect(position.x + 62, position.y, 15, 99999);
  }
}
// need to make velocity x and y influinced by drag and weight

//bounce bugs are its only up and down and object continues to go down

// need to change collision to fit project
