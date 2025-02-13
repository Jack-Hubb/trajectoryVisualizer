SceneTitle sceneTitle;
ScenePlay scenePlay;
SceneHowTo sceneHowTo;
SceneWin sceneWin;

float dt = 0;
float prevTime = 0;




void setup() {
  size(1280, 720);
  switchToPlay();
}


void draw() {
  background(0);
  calcDeltaTime();


  if (sceneTitle != null) {
    sceneTitle.update();
  } else if (scenePlay != null) {
    scenePlay.update();
  } else if (sceneWin != null) {
    sceneWin.update();
  } else if (sceneHowTo != null) {
    //may change to draw since its displaying only a message
    sceneHowTo.update();
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

void switchToTitle() {
  sceneTitle = new SceneTitle();
  scenePlay = null;
  sceneWin = null;
  sceneHowTo = null;
}
void switchToPlay() {
  scenePlay = new ScenePlay();
  sceneTitle = null;
  sceneWin = null;
  sceneHowTo = null;
}
void switchToHowTo() {
  sceneHowTo = new SceneHowTo();
  scenePlay = null;
  sceneTitle = null;
  sceneWin = null;
}
void switchToWin() {
  sceneWin = new SceneWin();
  sceneHowTo = null;
  scenePlay = null;
  sceneTitle = null;
}
