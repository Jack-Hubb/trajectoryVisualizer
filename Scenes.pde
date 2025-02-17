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
  Projectile projectile = new Projectile();

  void setup() {
    size(1280, 720);
    background(#FFFFFF);
  }

  void update() {

    projectile.update();
  }

  void draw() {
    background(#FFFFFF);
    update();

    projectile.draw();
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
