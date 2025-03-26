class FlightStatsPieChart {
  int onTime, late, early, cancelled;
  int x, y, diameter;

  FlightStatsPieChart(int x, int y, int diameter) {
    this.x = x;
    this.y = y;
    this.diameter = diameter;
    this.onTime = 0;
    this.late = 0;
    this.early = 0;
    this.cancelled = 0;
  }

void countFlights(ArrayList<FlightEntry> flights) {
    for (FlightEntry flight : flights) { 
        if (flight.cancelled) {
            cancelled++;
            continue;
        }

        
        if (flight.arrivalTime != null && flight.departureTime != null) { 
            int arrTime = flight.arrivalTime.toMinutes(); 
            int crsArrTime = flight.scheduledArrivalTime.toMinutes(); 
            
            println("CRS " + crsArrTime);
            println("ARR " + arrTime);
            
            int arrivalDelay = arrTime - crsArrTime; // if negative then early
            
            if (arrivalDelay < -10) {
                early++;
            } else if (abs(arrivalDelay) < 10) {
                onTime++;
            } else {
                late++;
            }

            // Debugging: 
            println("ARR_TIME: " + arrTime + ", CRS_ARR_TIME: " + crsArrTime + ", Delay: " + arrivalDelay);
        }
    }
}


  void drawPieChart() {
    int total = onTime + late + early + cancelled;
    if (total == 0) return; 

    float lastAngle = 0;
    float[] angles = {
      map(onTime, 0, total, 0, TWO_PI),
      map(late, 0, total, 0, TWO_PI),
      map(early, 0, total, 0, TWO_PI),
      map(cancelled, 0, total, 0, TWO_PI)
    };

    color[] colors = {color(0, 255, 0), color(255, 165, 0), color(0, 0, 255), color(255, 0, 0)};
    
    for (int i = 0; i < angles.length; i++) {
      fill(colors[i]);
      arc(x, y, diameter, diameter, lastAngle, lastAngle + angles[i]);
      lastAngle += angles[i];
    }
    
    fill(0);
    textAlign(LEFT);
    text("(Green) On Time: " + onTime, x + diameter / 2 + 20, y - 40);
    text("(Orange) Late: " + late, x + diameter / 2 + 20, y - 20);
    text(" (Blue) Early: " + early, x + diameter / 2 + 20, y);
    text("(Red) Cancelled: " + cancelled, x + diameter / 2 + 20, y + 20);
  }
}
