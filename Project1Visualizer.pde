SceneTitle sceneTitle;
ScenePlay scenePlay;
SceneHowTo sceneHowTo;
SceneWin sceneWin;

float dt = 0;
float prevTime = 0;
final float gravity = 1000;



void setup() {
  size(1280, 720);
  switchToTitle();
}


void draw() {
  background(0);
  calcDeltaTime();


  if (scenePlay != null) {
    scenePlay.draw();
  } else if (sceneWin != null) {
    sceneWin.update();
  } else if (sceneHowTo != null) {
    sceneHowTo.update();
   if (sceneHowTo != null) sceneHowTo.draw();
  } else if (sceneTitle != null) {
    sceneTitle.update();
    if (sceneTitle != null) sceneTitle.draw();
  }
}



void calcDeltaTime() {
  float currTime = millis();
  dt = (currTime - prevTime) / 1000.0;
  prevTime = currTime;
}

void keyPressed() {
  Keyboard.handleKeyDown(keyCode);
}

void keyReleased() {
  Keyboard.handleKeyUp(keyCode);
}

void mousePressed() {
  if (mouseButton == LEFT) Mouse.handleKeyDown(Mouse.LEFT);
}

void mouseReleased() {
  if (mouseButton == LEFT) Mouse.handleKeyUp(Mouse.LEFT);
}
public void switchToTitle() {
  sceneTitle = new SceneTitle();
  scenePlay = null;
  sceneWin = null;
  sceneHowTo = null;
}
public void switchToPlay() {
  scenePlay = new ScenePlay();
  sceneTitle = null;
  sceneWin = null;
  sceneHowTo = null;
}
public void switchToHowTo() {
  sceneHowTo = new SceneHowTo();
  sceneTitle = null;
  scenePlay = null;
  sceneWin = null;
}
public void switchToWin() {
  sceneWin = new SceneWin();
  sceneHowTo = null;
  scenePlay = null;
  sceneTitle = null;
}
