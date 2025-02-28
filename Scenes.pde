
class ScenePlay {

  Button rubberSpawn = new Button(100, height-110, 100, 50, 3);
  Button paperSpawn = new Button(205, height-110, 100, 50, 3);
  Button metalSpawn = new Button(100, height-50, 100, 50, 3);
  Button woodSpawn = new Button(205, height-50, 100, 50, 3);
  boolean buttonClickable;
  float buttonCD;
  SlingShot slingShot;
  ArrayList<Projectile> projectiles = new ArrayList();


  ScenePlay() {
    size(1280, 720);
    background(#FFFFFF);
    //generate tower materials
    slingShot = new SlingShot(200, height-350);
  }

  void update() {
    rubberSpawn.update();
    paperSpawn.update();
    metalSpawn.update();
    woodSpawn.update();

    println(projectiles.size());
    for (int i = 0; i < projectiles.size(); i++) {
      Projectile p = projectiles.get(i);
      p.update();

      if (p.x > width+50) {
        projectiles.remove(p);
      } else if (p.x < -50) {
        projectiles.remove(p);
      } else if (p.y > height+50) {
        projectiles.remove(p);
      } else if (p.x < -50) {
        projectiles.remove(p);
      }
    }


    if (slingShot != null)slingShot.update();
    buttonCD -= dt;

    if (buttonCD >= 0) {
      buttonClickable = false;
    } else {
      buttonClickable = true;
    }
    // buttons for spawning projectiles
    if (buttonClickable) {
      //projectile spawning
      if (rubberSpawn.activated) {
        //spawn corisponding projectile
        Projectile p = new Projectile(100, height-300, "RUBBER");
        projectiles.add(p);
        buttonCD = 3;
        println("rubber");
      } else if (paperSpawn.activated) {
        //spawn corisponding projectile
        Projectile p = new Projectile(100, height-300, "PAPER");
        projectiles.add(p);
        buttonCD = 3;
        println("paper");
      } else if (metalSpawn.activated) {
        //spawn corisponding projectile
        Projectile p = new Projectile(100, height-300, "METAL");
        projectiles.add(p);
        buttonCD = 3;
        println("metal");
      } else if (woodSpawn.activated) {
        //spawn corisponding projectile
        Projectile p = new Projectile(100, height-300, "WOOD");
        projectiles.add(p);
        buttonCD = 3;
        println("wood");
      }
    }


    for (int i = 0; i < projectiles.size(); i++) {
      Projectile p = projectiles.get(i);


      if (p.checkCollision(slingShot) && !p.isFired) {
        p.inCatapult = true;
      }
      p.lookingForCatapult = false;
    }
  }
  void draw() {


    background(#FFFFFF);
    update();

    if (slingShot != null)slingShot.draw();

    for (int i = 0; i < projectiles.size(); i++) {
      Projectile p = projectiles.get(i);
      p.draw();
    }

    fill(40);
    rect(-50, height - 150, width+50, 500);
    //if (projectile != null)projectile.draw();


    rubberSpawn.draw();
    metalSpawn.draw();
    woodSpawn.draw();
    paperSpawn.draw();

    fill(0);
    textSize(25);
    text("Rubber", 100, height-110);
    text("Metal", 100, height-50);
    text("Wood", 205, height-50);
    text("Paper", 205, height-110);
  }
}





class SceneTitle {

  Button playButton = new Button(width/2, height/2-95, 250, 80, 3);
  Button howToButton = new Button(width/2, height/2, 250, 80, 3);
  Button quitButton = new Button(width/2, height/2+95, 250, 80, 3);


  SceneTitle() {
  }
  void update() {
    playButton.update();
    howToButton.update();
    quitButton.update();
    if (playButton.activated)switchToPlay();
    if (howToButton.activated)switchToHowTo();
    if (quitButton.activated)exit();
  }
  void draw() {
    background(30);

    playButton.draw();
    howToButton.draw();
    quitButton.draw();
    fill(255);
    textSize(45);
    textAlign(CENTER, CENTER);
    text("Tragectory Visualizer", width/2, height/2 - 230);
    textSize(40);
    fill(0);
    text("play!", width/2, height/2-100);
    text("How To Play!", width/2, height/2-5);
    text("Quit!", width/2, height/2+90);
    textSize(25);
  }
}






class SceneHowTo {

  Button toMenuButton = new Button(200, height-75, 250, 80, 3);
  Button playButton = new Button(width-200, height-75, 250, 80, 3);
  Button prevSlide = new Button(200, height - 175, 250, 80, .5);
  Button nextSlide = new Button(width - 200, height - 175, 250, 80, .5);

  int slide = 0;

  SceneHowTo() {
  }
  void update() {
    playButton.update();
    toMenuButton.update();
    prevSlide.update();
    nextSlide.update();
    if (playButton.activated)switchToPlay();
    if (toMenuButton.activated)switchToTitle();
    if (prevSlide.activated && !prevSlide.prevActivated) slide--;
    if (nextSlide.activated && !nextSlide.prevActivated) slide++;
    println(slide);
  }
  void draw() {
    background(20);

    fill(40);
    rect(-50, height - 250, width+50, 500);
    playButton.draw();
    toMenuButton.draw();
    prevSlide.draw();
    nextSlide.draw();

    fill(0);
    textSize(45);
    textAlign(CENTER, CENTER);
    text("Play", width - 200, height-80);
    text("Back", 200, height-80);
    text("Next", width - 200, height-180);
    text("Previous", 200, height-180);

    textSize(40);


    switch(slide) {
      // trajectory
    case 0:
      textSize(50);
      fill(255);
      text("Trajectory", width/2, 50);
      textSize(35);
      text("trajectory can be calculated using this equation.", width/2, 150);
      text("X = Initial Horizontal Position + Projected Horizontal Velocity * (Elapsed Time)", width/2, 200);
      text("Y = Initial Vertical Position + Projected Vertical Velocity * (Elapsed Time)", width/2, 250);
      text("+ GRAVITY * (Elapsed Time ^ 2) / 2", width/2, 300);
      ellipse(255, 150, 15, 15);
      ellipse(242, 200, 15, 15);
      ellipse(15, 250, 15, 15);
      ellipse(15, 300, 15, 15);
      break;
      // applied trajectory to sim
    case 1:
      textSize(50);
      fill(255);
      text("Trajectory", width/2, 50);
      textSize(35);
      String text = "In this program when you drop an object into the slingshot trajectory is calculated by taking the potential velocity from you pulling the slingshot back and the initial location from wherever you let go then projects points across five seconds.";
      text(text, 25, 50, width-50, height-250);
      break;
    case 2:
      String text2 = "Physics materials can add variables such as friction, air drag, and how much an object bounces";
      text(text2, 25, 50, width-50, height-250);
      break;

      // how to play
    case 3:
      textSize(50);
      fill(255);
      text("How to Play!", width/2, 50);
      textSize(40);
      text("Press one of the four buttons in the bottom right to spawn a projectile.", width/2, 150);
      text("Drag and drop the projectile into the slingshot.", width/2, 250);
      textSize(39);
      text("Drag the projectile to the left and launch the projectile to destroy the tower!", width/2, 350);
      ellipse(45, 150, 15, 15);
      ellipse(242, 250, 15, 15);
      ellipse(15, 350, 15, 15);
      break;
    }
  }
}

class SceneWin {
  void update() {
  }
}
