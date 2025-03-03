
class ScenePlay {

  Button rubberSpawn = new Button(100, height-110, 100, 50, 3);
  Button paperSpawn = new Button(205, height-110, 100, 50, 3);
  Button metalSpawn = new Button(100, height-50, 100, 50, 3);
  Button woodSpawn = new Button(205, height-50, 100, 50, 3);
  Button mainMenu = new Button(width - 120, height - 80, 150, 80, 3);
  Button clearScreen = new Button(width - 300, height - 80, 150, 80, 3);
  float buttonCD;
  SlingShot slingShot;
  ArrayList<Projectile> projectiles = new ArrayList();
  ArrayList<TowerPart> tParts = new ArrayList();

  ScenePlay() {
    size(1280, 720);
    background(#FFFFFF);
    //generate tower materials
    slingShot = new SlingShot(200, height-350);

    generateTower();

    TowerPart j = new TowerPart(width/2, height /2, 50, 100);
    tParts.add(j);
  }

  void update() {
    rubberSpawn.update();
    paperSpawn.update();
    metalSpawn.update();
    woodSpawn.update();
    mainMenu.update();
    clearScreen.update();

    for (int i = 0; i < projectiles.size(); i++) {
      Projectile p = projectiles.get(i);
      p.update();

      if (p.x > width+50 || p.x < -50) {
        projectiles.remove(i);
      }
    }


    if (slingShot != null)slingShot.update();
    buttonCD -= dt;

    // buttons for spawning projectiles

    //projectile spawning
    if (rubberSpawn.activated && !rubberSpawn.prevActivated) {
      //spawn corisponding projectile
      Projectile p = new Projectile(100, height-300, "RUBBER");
      projectiles.add(p);
      buttonCD = 1.5;
    } else if (paperSpawn.activated && !paperSpawn.prevActivated) {
      //spawn corisponding projectile
      Projectile p = new Projectile(100, height-300, "PAPER");
      projectiles.add(p);
      buttonCD = 1.5;
    } else if (metalSpawn.activated && !metalSpawn.prevActivated) {
      //spawn corisponding projectile
      Projectile p = new Projectile(100, height-300, "METAL");
      projectiles.add(p);
      buttonCD = 1.5;
    } else if (woodSpawn.activated && !woodSpawn.prevActivated) {
      //spawn corisponding projectile
      Projectile p = new Projectile(100, height-300, "WOOD");
      projectiles.add(p);
      buttonCD = 1.5;
    } else if (mainMenu.activated) {
      switchToTitle();
    } else if (clearScreen.activated && !clearScreen.prevActivated) {
      projectiles.clear();
    }



    for (int i = 0; i < projectiles.size(); i++) {
      Projectile p = projectiles.get(i);


      if (p.checkCollision(slingShot) && !p.isFired) {
        p.inCatapult = true;
      }

      p.lookingForCatapult = false;
    }

    for (int i = 0; i < tParts.size(); i++) {
      TowerPart tp = tParts.get(i);
      tp.update();
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
    for (int i = 0; i < tParts.size(); i++) {
      TowerPart tp = tParts.get(i);
      tp.draw();
    }

    fill(40);
    rect(-50, height - 150, width+50, 500);



    rubberSpawn.draw();
    metalSpawn.draw();
    woodSpawn.draw();
    paperSpawn.draw();
    mainMenu.draw();
    clearScreen.draw();

    fill(0);
    textSize(25);
    text("Rubber", 100, height-110);
    text("Metal", 100, height-50);
    text("Wood", 205, height-50);
    text("Paper", 205, height-110);
    text("Clear Objects", width - 300, height - 80);
    textSize(30);
    text("Main Menu", width - 120, height - 80);

    ellipse(270, 390, 5, 5);
    fill(30);
    rect(251, height - 365, 38, 90);

    //for(TowerPart part : tParts){

    //  rect(part.position.x, part.position.y, 50,100);
    //}
  }




  void generateTower() {
    int cols = 3;  // Number of columns
    int rows = 4;  // Number of rows
    float partWidth = 50;
    float partHeight = 100;
    float startX = width - 200;  // Tower start position
    float startY = height - 250;

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        float x = startX + col * partWidth;
        float y = startY - row * partHeight;
        tParts.add(new TowerPart(x, y, partWidth, partHeight));
      }
    }
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

  PImage traj;
  PImage[] gif = new PImage[114];
  int gifIndex = 0;
  int gifCounter = 0;

  Button toMenuButton = new Button(200, height-75, 250, 80, 3);
  Button playButton = new Button(width-200, height-75, 250, 80, 3);
  Button prevSlide = new Button(200, height - 175, 250, 80, .5);
  Button nextSlide = new Button(width - 200, height - 175, 250, 80, .5);

  int slide = 0;

  SceneHowTo() {
    traj = loadImage("trajExample.png");

    for (int i = 0; i < gif.length; i++) {

      if (i < 9) {
        gif[i] = loadImage("mats00" + (i+1) +".png");
      } else if (i >= 9 && i < 99) {
        gif[i] = loadImage("mats0" + (i+1) +".png");
      } else if ( i >= 99) {
        gif[i] = loadImage("mats" + (i+1) +".png");
      }
    }
  }

  void update() {
    playButton.update();
    toMenuButton.update();
    prevSlide.update();
    nextSlide.update();
    if (playButton.activated)switchToPlay();
    if (toMenuButton.activated)switchToTitle();
    if (prevSlide.activated ) slide--;
    if (nextSlide.activated && !nextSlide.prevActivated) slide++;
    println();

    if (slide > 3) slide = 0;
    if (slide < 0) slide = 3;


    gifCounter++;
    if (gifCounter > 1) {
      gifIndex++;
      if (gifIndex >= gif.length) gifIndex = 0;
      gifCounter = 0;
    }
    println(gifIndex);
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

      break;
      // applied trajectory to sim
    case 1:
      textSize(50);
      fill(255);
      text("Trajectory", width/2, 50);
      textSize(35);
      String text = "In this program when you drop an object into the slingshot trajectory is calculated by taking the potential velocity from you pulling the slingshot back and the launch angle from the object your launching and the slingshot.";
      text(text, 25, 50, width-50, height-550);
      image(traj, 100, 215);
      break;
    case 2:
      textSize(50);
      fill(255);
      text("Physics Materials", width/2, 50);
      textSize(40);
      String text2 = "Physics materials can add variables such as friction, air drag, and how much an object bounces in the example below wood has high friction wheras metal has very little friction and slides further";
      text(text2, 25, 50, width-50, height-400);
      image(gif[gifIndex], width/3, 305);
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

      break;
    }
  }
}

class SceneWin {
  void update() {
  }
}
