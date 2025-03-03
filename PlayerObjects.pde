class Projectile extends Polygon {
  float x, y;
  float drag = 2;
  float bounceAmount = 10, pBounceAmount;
  float weight;
  float friction;
  float initX, initY;
  float bouncyness;
  float bouncynessFalloff;
  float launchAngle;
  float distance;
  float launchScale;
  float anchorX, anchorY;
  float mouseAngle;
  final float tDur = 3;

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
  PVector[] trajectoryPoints;

  color fillColor;
  String name;


  Projectile(float x, float y, String name ) {

    this.x = x;
    this.y = y;

    //velocity.x = 200;
    // assign physics settings based off type
    if (name == "RUBBER") {
      drag = 100;
      friction = 30;
      bouncyness = 800;
      bouncynessFalloff = 50;
      normallyBounces = true;
      this.name = name;
      addPoint(-20, -30);
      addPoint(20, -30);
      addPoint(40, -10);
      addPoint(20, 20);
      addPoint(-20, 30);
      addPoint(-40, 0);
      recalc();
      setColor(#050505);
    } else if (name == "METAL") {
      drag = 300;
      friction = 5;
      bouncyness = 250;
      bouncynessFalloff = 50;
      normallyBounces = false;
      this.name = name;
      addPoint(-30, -20);
      addPoint(30, -20);
      addPoint(50, 20);
      addPoint(0, 50);
      addPoint(-50, 20);
      recalc();
      setColor(#313131);
    } else if (name == "WOOD") {
      drag = 150;
      friction = 300;
      bouncyness = 400;
      bouncynessFalloff = 50;
      normallyBounces = false;
      this.name = name;
      addPoint(-50, -30);
      addPoint(50, -40);
      addPoint(60, 20);
      addPoint(40, 50);
      addPoint(-30, 40);
      addPoint(-40, 10);
      recalc();
      setColor(#763007);
    } else if (name == "PAPER") {
      drag = 600;
      friction = 200;
      bouncyness = 150;
      bouncynessFalloff = 50;
      normallyBounces = false;
      this.name = name;
      addPoint(-40, -20);
      addPoint(40, -20);
      addPoint(30, 30);
      addPoint(-50, 30);
      recalc();
      setColor(#AFA29A);
    }
    //preloads array to avoid memory leak points set and reset with update traj
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



    mouseLocation.x = mouseX;
    mouseLocation.y = mouseY;
    anchorX = 270;
    anchorY = height - 330;

    //checks if in the air or not
    if (getColliding()) {
      inAir = false;
    } else if (!getColliding()) {
      inAir = true;
    }


    // bounces if it hits the floor
    if (y >= height-180) {
      velocity.y = -bouncyness;
      bounceAmount--;
      BounceProj();
      if (-bouncyness >= -10)y = height - 180;
      inAir = false;
    } else {
      inAir = true;
    }

    if (x > width) {
      velocity.x = -bouncyness;
      BounceProj();
    } else if (x < 0) {
      velocity.x = bouncyness;
      BounceProj();
    }

    // object is in the catapult
    if (inCatapult) {

      distance = sqrt(sq(anchorY - y)+sq(anchorX - x));
      launchScale = 7;
      initX = x;
      initY = y;
      projVelocity.x = cos(launchAngle) *  distance * launchScale;
      projVelocity.y = sin(launchAngle) *  distance * launchScale;
      projVelocity.x -= drag * dt;

      updateTrajectory(initX, initY, projVelocity, 5);
      if (Mouse.isDown(Mouse.LEFT) && checkCollisionPoint(mouseLocation)) {
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

      // has let go (object launches)
      if (!Mouse.isDown(Mouse.LEFT) && isHolding) {

        distance = sqrt(sq(anchorY - y)+sq(anchorX - x));
        launchScale = 7;


        velocity.x = cos(launchAngle) *  distance * launchScale;
        velocity.y = sin(launchAngle) *  distance * launchScale;
        projVelocity = velocity.copy();
        projVelocity.x -= drag*dt;

        inCatapult = false;
        isHolding = false;
        allowedToBeHeld = false;
        isFired = true;

        initX = x;
        initY = y;

        updateTrajectory(initX, initY, projVelocity, 5);
        inAir = true;
      }
    } else {
      //  not in the catapult apply gravity and regular physics

      if (inAir == true) {
        velocity.y += gravity * dt;

        //change
        if (velocity.x > 0) {
          velocity.x = max(0, velocity.x - drag * dt);
        } else if (velocity.x < 0) {
          velocity.x = min(0, velocity.x + drag * dt);
        }
        x += velocity.x * dt;
        y += velocity.y * dt;
      } else if (inAir != true ) {
        velocity.y += gravity * dt;

        if (velocity.x > 0) {
          velocity.x = max(0, velocity.x - friction * dt);
        } else if (velocity.x < 0) {
          velocity.x = min(0, velocity.x + friction * dt);
        }
        x += velocity.x * dt;
        y += velocity.y * dt;
      }
    }



    // sets holding if clicked on
    if (allowedToBeHeld) {
      if (Mouse.isDown(Mouse.LEFT)) {
        if (checkCollisionPoint(mouseLocation)) isHolding = true;
      } else if (!Mouse.isDown(Mouse.LEFT)) isHolding = false;
    }
    // when outside of the slingshot holding
    if (isHolding) {
      x = mouseX;
      y = mouseY;
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
    fill(0);
    text(name, x, y - 40);
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

  void BounceProj() {
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

  void calcAngleToMouse() {
    float dx = mouseX - x;
    float dy = mouseY - y;
    mouseAngle = atan2(dy, dx);
  }


  // calc trajectory line
  void updateTrajectory(float initX, float initY, PVector initVel, float dur) {
    int nPoints = trajectoryPoints.length;
    for (int i = 0; i < nPoints; i++) {
      float elapsedTime = i * dt;
      float x = initX + initVel.x * elapsedTime - .5 * drag * sq(elapsedTime);
      float y = initY + initVel.y * elapsedTime + 0.5 * gravity * sq(elapsedTime);

      trajectoryPoints[i].x = x;
      trajectoryPoints[i].y = y;
    }
  }
  // draw the shape of the trajectory line
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
