class TextBox {
  
  int boxWidth, boxHeight, x, y;
  String text = "";
  boolean selected = false;
  
  TextBox(int boxWidth, int boxHeight, int x, int y) {
    this.boxWidth = boxWidth;
    this.boxHeight = boxHeight;
    this.x = x;
    this.y = y;
  }
  
  void display() {
    stroke(0);
    fill(255);
    rect(x, y, boxWidth, boxHeight);
  
    fill(0);
    textSize(16);
    textAlign(LEFT, CENTER);
  
    String displayText = text.toUpperCase();
    float padding = 20;
    float maxTextWidth = boxWidth - 2 * padding;
    
    while (textWidth(displayText) > maxTextWidth && displayText.length() > 0) {
      displayText = displayText.substring(1); 
    }
  
    text(displayText, x + padding, y + boxHeight / 2);
  }
  
  void handleClick(float mousePosX, float mousePosY) {
    if (mousePosX > x && mousePosX < x + boxWidth && mousePosY > y && mousePosY < y + boxHeight) {
       selected = true;
    } else {
      selected = false;
    }
  }
  
  void handleKey(char key) {
  if (selected) {
    if (key == BACKSPACE && text.length() > 0) {
      text = text.substring(0, text.length() - 1);
    } else if (key == ENTER || key == RETURN) {
      filterFlights(); 
    } 
    else if (key >= 32 && key <= 126) { 
      text += key;
    }
  }
}

}
