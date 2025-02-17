class SceneTitle {
  void update() {
    
    
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
  void update() {
  }
}

class SceneWin {
  void update() {
  }
}
