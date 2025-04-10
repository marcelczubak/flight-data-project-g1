// BC

int scrollOffset = 0;
int barsPerPage = 6;
int totalBars = 10;
float[] animatedHeights = new float[10]; // for bar animation

void drawBarChart() {
  int[] distanceBins = new int[10];
  String[] labels = {
    "0–250 Mi", "250–500 Mi", "500–750 Mi", "750–1000 Mi", 
    "1000–1500 Mi", "1500–2000 Mi", "2000–2500 Mi", "2500–3000 Mi", 
    "3000–3500 Mi", "3500+ Mi"
  };

  for (FlightEntry flight : allFlights) {
    float distance = flight.distance;

    if (distance < 250) distanceBins[0]++;
    else if (distance < 500) distanceBins[1]++;
    else if (distance < 750) distanceBins[2]++;
    else if (distance < 1000) distanceBins[3]++;
    else if (distance < 1500) distanceBins[4]++;
    else if (distance < 2000) distanceBins[5]++;
    else if (distance < 2500) distanceBins[6]++;
    else if (distance < 3000) distanceBins[7]++;
    else if (distance < 3500) distanceBins[8]++;
    else distanceBins[9]++;
  }

  int maxFlights = max(distanceBins);
  int barWidth = width / (barsPerPage * 2);
  int margin = barWidth / 2;

  int startBar = scrollOffset;
  int endBar = min(scrollOffset + barsPerPage, distanceBins.length);

  for (int i = startBar; i < endBar; i++) {
    int localIndex = i - scrollOffset;
    float targetHeight = map(distanceBins[i], 0, maxFlights, 0, height - 100);
    animatedHeights[i] = lerp(animatedHeights[i], targetHeight, 0.1);
    float barHeight = animatedHeights[i];

    float x = localIndex * (barWidth * 2) + margin;

    fill(100, 150, 255);
    rect(x, height - barHeight - 30, barWidth, barHeight);

    fill(0);
    textAlign(CENTER);
    textSize(12);
    text(labels[i], x + barWidth / 2, height - 10);
    text(distanceBins[i], x + barWidth / 2, height - barHeight - 40);
    
    // Tooltip: shows a small box with the number of flights and distance range
    // Calculate bar boundaries
    float xLeft = x;
    float xRight = x + barWidth;
    float yTop = height - barHeight - 30;
    float yBottom = height - 30;

    // Check if mouse is over this bar
    if (mouseX >= xLeft && mouseX <= xRight && mouseY >= yTop && mouseY <= yBottom) {
    // Tooltip background
    fill(255, 250);
    stroke(0);
    rect(mouseX + 10, mouseY - 25, 120, 40, 5);

    // Tooltip text
    fill(0);
    textAlign(LEFT);
    textSize(12);
    text(labels[i], mouseX + 15, mouseY - 10);
    text(distanceBins[i] + " flights", mouseX + 15, mouseY + 5);
    }
  }
  fill(0);
  textSize(14);
  textAlign(CENTER);
  text("Flight Count by Distance Category (Press UP/DOWN to scroll)", width / 2, 20);
}

// FilteredBarChart
void drawFilteredBarChart() {
  int[] bins = {0, 250, 500, 750, 1000, 1500, 2000, 2500, 3000, 3500, Integer.MAX_VALUE};
  String[] categories = {
    "0–250 Mi", "250–500 Mi", "500–750 Mi", "750–1000 Mi",
    "1000–1500 Mi", "1500–2000 Mi", "2000–2500 Mi", "2500–3000 Mi",
    "3000–3500 Mi", "3500+ Mi"
  };
  int[] flightCounts = new int[10];

  int endIndex = min(startIndex + amountToDisplay, indexesToFetch.size());
  for (int i = startIndex; i < endIndex; i++) {
    int flightIndex = indexesToFetch.get(i);
    float dist = allFlights.get(flightIndex).distance;
    for (int j = 0; j < bins.length - 1; j++) {
      if (dist >= bins[j] && dist < bins[j + 1]) {
        flightCounts[j]++;
        break;
      }
    }
  }

  int maxFlights = max(flightCounts);
  int barWidth = width / (categories.length * 2);
  int margin = barWidth / 2;

  for (int i = 0; i < flightCounts.length; i++) {
    float barHeight = map(flightCounts[i], 0, maxFlights, 0, height - 50);
    float x = i * (barWidth * 2) + margin;

    fill(100, 200, 100);  // Filter chart color
    rect(x, height - barHeight - 30, barWidth, barHeight);

    fill(0);
    textAlign(CENTER);
    text(categories[i], x + barWidth / 2, height - 10);
    text(flightCounts[i], x + barWidth / 2, height - barHeight - 40);

    //Tooltip (Same as mainBarChart)
    float xLeft = x;
    float xRight = x + barWidth;
    float yTop = height - barHeight - 30;
    float yBottom = height - 30;

    if (mouseX >= xLeft && mouseX <= xRight && mouseY >= yTop && mouseY <= yBottom) {
      fill(255, 240);
      stroke(0);
      rect(mouseX + 10, mouseY - 25, 120, 40, 5);

      fill(0);
      textAlign(LEFT);
      textSize(12);
      text(categories[i], mouseX + 15, mouseY - 10);
      text(flightCounts[i] + " flights", mouseX + 15, mouseY + 5);
    }
  }

  fill(0);
  textSize(14);
  textAlign(CENTER);
  text("Filtered Flight Count by Distance Category (Press UP/DOWN to scroll)", width / 2, 20);
  text("Flights from " + (startIndex + 1) + " to " + endIndex + " displayed", width / 2, 50);
}
