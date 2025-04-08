class Button {
  String label;
  int x, y, w, h;
  int textPosX, textPosY;
  int iconPosX, iconPosY;
  PImage icon;
  color buttonColor;

  Button(String label, int x, int y, int w, int h, int textPosX, int textPosY, color buttonColor) {
    this.label = label;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.textPosX = textPosX;
    this.textPosY = textPosY;
    this.buttonColor = buttonColor;
  }
  
  Button(String label, int x, int y, int w, int h, int textPosX, int textPosY, PImage icon, int iconPosX, int iconPosY, color buttonColor) {
    this.label = label;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.textPosX = textPosX;
    this.textPosY = textPosY;
    this.icon = icon;
    this.iconPosX = iconPosX;
    this.iconPosY = iconPosY;
    this.buttonColor = buttonColor;
  }

  void display() {
    fill(buttonColor);
    rect(x, y, w, h);
    fill(0);
    stroke(50);
    strokeWeight(1.25);
    textSize(16);
    textAlign(CENTER, CENTER);
    text(label, textPosX, textPosY);
    if (icon != null) {
      imageMode(CENTER);
      image(icon, iconPosX, iconPosY);
    }
  }
  
  boolean isPressed() {
    return mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;
  }
}
