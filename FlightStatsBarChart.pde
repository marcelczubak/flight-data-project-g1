//NEW JUST ADDED BENNY

void drawBarChart() {
  int[] bins = {0, 500, 1000, 2000, 3000, Integer.MAX_VALUE};
  String[] categories = {"0-500", "500-1000", "1000-2000", "2000-3000", "3000+"};
  int[] flightCounts = new int[categories.length];

  //Count flights per category
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
