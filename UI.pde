class Button extends AABB {
  // clickable button

  PVector position = new PVector();
  float w, h;
  boolean isHovered;
  boolean activated;
  
  Button(float X, float Y, float W, float H) {

    position.x = X;
    position.y = Y;
    w = W;
    h = H;
    xmin = X-w/2;
    xmax = X + W/2;
    ymin = Y-h/2;
    ymax = Y + H/2;
    
  }

  void update() {

    if (checkCollisionMouse()) {
      isHovered = true;
    } else isHovered =false;
    println();
    
    
    if(isHovered && Mouse.onDown(Mouse.LEFT)) activated = true;
    
  }

  void draw() {
if(isHovered){fill(#818181);}else fill(#AAAAAA);
    

    rect(position.x-w/2, position.y-h/2, w, h);
  }
}
