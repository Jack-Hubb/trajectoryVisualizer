class SceneTitle {

  Button playButton = new Button(width/2, height/2-95, 250, 80);
  Button howToButton = new Button(width/2, height/2, 250, 80);
  Button quitButton = new Button(width/2, height/2+95, 250, 80);
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




class ScenePlay {

  Button rubberSpawn = new Button(100, height-110, 100, 50);
  Button paperSpawn = new Button(205, height-110, 100, 50);
  Button metalSpawn = new Button(100, height-50, 100, 50);
  Button woodSpawn = new Button(205, height-50, 100, 50);


  Projectile projectile = new Projectile("RUBBER");

  void setup() {
    size(1280, 720);
    background(#FFFFFF);
    //generate tower materials
  }

  void update() {
    rubberSpawn.update();
    paperSpawn.update();
    metalSpawn.update();
    woodSpawn.update();

//projectile spawning
if(rubberSpawn.activated){
//spawn corisponding projectile
println("rubber");
} else if(paperSpawn.activated){
//spawn corisponding projectile
println("paper");
} else if(metalSpawn.activated){
//spawn corisponding projectile
println("metal");
} else if(woodSpawn.activated){
//spawn corisponding projectile
println("wood");
}


    if (projectile != null) {
      projectile.update();
      //if (projectile.bounceAmount <= 0) projectile = null;
    }

    // buttons for spawning projectiles
  }
  void draw() {


    background(#FFFFFF);
    update();

    fill(40);
    rect(-50, height - 150, width+50, 500);
    if (projectile != null)projectile.draw();

    rubberSpawn.draw();
    metalSpawn.draw();
    woodSpawn.draw();
    paperSpawn.draw();
    fill(0);
    text("Rubber", 100, height-110);
    text("Metal", 100, height-50);
    text("Wood", 205, height-50);
    text("Paper", 205, height-110);
  }
}








class SceneHowTo {

  Button toMenuButton = new Button(200, height-75, 250, 80);
  Button playButton = new Button(width-200, height-75, 250, 80);

  SceneHowTo() {
  }
  void update() {
    playButton.update();
    toMenuButton.update();
    if (playButton.activated)switchToPlay();
    if (toMenuButton.activated)switchToTitle();
  }
  void draw() {
    background(20);

    fill(40);
    rect(-50, height - 150, width+50, 500);
    playButton.draw();
    toMenuButton.draw();


    fill(0);
    textSize(45);
    textAlign(CENTER, CENTER);
    text("Play", width - 200, height-80);
    text("Back", 200, height-80);
  }
}

class SceneWin {
  void update() {
  }
}
