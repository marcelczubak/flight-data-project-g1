void drawBarChart() {
  int[] bins = {0, 500, 1000, 2000, 3000, Integer.MAX_VALUE};
  String[] categories = {"0-500 Mi", "500-1000 Mi", "1000-2000 Mi", "2000-3000 Mi", "3000+ Mi"};
  int[] flightCounts = new int[categories.length];

  for (FlightEntry flight : allFlights) {
    float dist = flight.distance;
    for (int i = 0; i < bins.length - 1; i++) {
      if (dist >= bins[i] && dist < bins[i + 1]) {
        flightCounts[i]++;
        break;
      }
    }
  }

  int maxFlights = max(flightCounts);
  int barWidth = width / (categories.length * 2);
  int margin = barWidth / 2;

  for (int i = 0; i < flightCounts.length; i++) {
    float barHeight = map(flightCounts[i], 0, maxFlights, 0, height - 50);
    fill(100, 150, 255);
    rect(i * (barWidth * 2) + margin, height - barHeight - 30, barWidth, barHeight);

    fill(0);
    textAlign(CENTER);
    text(categories[i], i * (barWidth * 2) + margin + barWidth / 2, height - 10);
    text(flightCounts[i], i * (barWidth * 2) + margin + barWidth / 2, height - barHeight - 40);
  }

  fill(0);
  textSize(14);
  textAlign(CENTER);
  text("Flight Count by Distance Category", width / 2, 20);
}

void drawFilteredBarChart() {  // NEW
  int[] bins = {0, 500, 1000, 2000, 3000, Integer.MAX_VALUE};
  String[] categories = {"0-500 Mi", "500-1000 Mi", "1000-2000 Mi", "2000-3000 Mi", "3000+ Mi"};
  int[] flightCounts = new int[categories.length];

  int endIndex = min(startIndex + 65, indexesToFetch.size());
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
    fill(100, 200, 100);  // Use different color to distinguish
    rect(i * (barWidth * 2) + margin, height - barHeight - 30, barWidth, barHeight);

    fill(0);
    textAlign(CENTER);
    text(categories[i], i * (barWidth * 2) + margin + barWidth / 2, height - 10);
    text(flightCounts[i], i * (barWidth * 2) + margin + barWidth / 2, height - barHeight - 40);
  }

  fill(0);
  textSize(14);
  textAlign(CENTER);
  text("Filtered Flight Count (Only Displayed 65)", width / 2, 20);
  text("Flights from " + (startIndex + 1 ) + " to " + (endIndex + 1) + " displayed", 200, 50);
}
