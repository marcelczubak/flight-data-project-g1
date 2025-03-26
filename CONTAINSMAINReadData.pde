Table table;
ArrayList<FlightEntry> allFlights;
PFont displayFont;
FlightStatsPieChart pieChart;
boolean showEntryScreen = true;// new
boolean showPieChart = false;// new
boolean showTable = false;// new
int startIndex = 0; // new

Button pieChartButton; // new
Button tableButton; // new

void setup() {
  size(1200, 800);
  background(255); 
  displayFont = createFont("Arial", 12, true); 

  pieChartButton = new Button("Show Pie Chart", 400, 600, 200, 50); //new
  tableButton = new Button("Show Table", 650, 600, 200, 50);// new

  allFlights = new ArrayList<>();
  table = loadTable("flights100k(1).csv", "header");
  println("Entries loaded: ", table.getRowCount());
  
  for (TableRow row : table.rows()) {
    String airline = row.getString("MKT_CARRIER");
    String flightNumber = row.getString("MKT_CARRIER_FL_NUM");
    if (flightNumber.length() == 1) {
      flightNumber = flightNumber + "      ";
    } else if (flightNumber.length() == 2) {
      flightNumber = flightNumber + "    ";
    } else if (flightNumber.length() == 3) {
      flightNumber = flightNumber + "  ";
    }
    
    String originCode = row.getString("ORIGIN");
    String originName = row.getString("ORIGIN_CITY_NAME");
    String destinationCode = row.getString("DEST");
    String destinationName = row.getString("DEST_CITY_NAME");
    String departureTime = row.getString("DEP_TIME");
    String departureTimeFormatted = row.getString("DEP_TIME");
    String arrivalTime = row.getString("ARR_TIME");
    String arrivalTimeFormatted = row.getString("DEP_TIME");
    String scheduledArrivalTime = row.getString("CRS_ARR_TIME");
    
    if (departureTimeFormatted.length() >= 4) {
      departureTimeFormatted = departureTimeFormatted.substring(0,2) + ":" + departureTimeFormatted.substring(2,4);
    } else {
      departureTimeFormatted = "XX:XX";
    }
    if (arrivalTimeFormatted.length() == 4) {
      arrivalTimeFormatted = arrivalTimeFormatted.substring(0,2) + ":" + arrivalTimeFormatted.substring(2,4);
    } else {
      arrivalTimeFormatted = "XX:XX";
    }
    
    Boolean cancelled = false;
    String cancelledString = row.getString("CANCELLED");
    if (cancelledString.charAt(0) == '1') {
      cancelled = true;
    }
    
    allFlights.add(new FlightEntry(airline, flightNumber, originCode, originName, destinationCode, destinationName, departureTime, departureTimeFormatted, arrivalTime, arrivalTimeFormatted, scheduledArrivalTime, cancelled));
    
  }
  
  pieChart = new FlightStatsPieChart(600, 400, 500);
  pieChart.countFlights(allFlights);
}

void draw() {
  background(255); 
  textFont(displayFont);
  
    if (showEntryScreen) {
    fill(0);
    textSize(24);
    text("Welcome to the Flight Data Dashboard", 400, 200);

    pieChartButton.display();
    tableButton.display();
  } else if (showPieChart) {
    // Display the pie chart screen
    pieChart.drawPieChart();
  } else if (showTable) {
    // Display the table screen
    displayTable();
  }
  /*int spacer = 20;
  for (int i = 0; i < min(allFlights.size(), 65); i++) {
    FlightEntry flight = allFlights.get(i); 
    // NEXT STEP IN RENDERING DATA - TAKING QUERY AND ACTING ACCORDINGLY - FOR EXAMPLE if (flight.originCode.equals("ATL")) { 
    fill(flight.cancelled ? color(255, 0, 0) : color(0));
    text(i+1, 20, spacer);
    text(flight.airline + " " + flight.flightNumber + " " + flight.departureTimeFormatted + " " + flight.originCode +
         " >>>>> " + flight.destinationCode + " " + flight.arrivalTimeFormatted + " " + (flight.cancelled ? "Cancelled" : ""), 
         70, spacer);
    spacer += 12;
    
  }
  pieChart.drawPieChart();*/
}

void mousePressed() {
  if (showEntryScreen) {
    if (pieChartButton.isPressed()) {
      showEntryScreen = false;
      showPieChart = true;
      showTable = false;
    } else if (tableButton.isPressed()) {
      showEntryScreen = false;
      showPieChart = false;
      showTable = true;
    }
  }
}

int convertTimeToMinutes(String timeStr) {
  if (timeStr.length() == 4) {
    int hours = Integer.parseInt(timeStr.substring(0, 2));
    int minutes = Integer.parseInt(timeStr.substring(2, 4));
    int total = hours * 60 + minutes;
    return total;
  }
  return 0;
}

void displayTable() {
  int spacer = 20;
   textAlign(LEFT); 

  int endIndex = min(startIndex + 65, allFlights.size());
  for (int i = startIndex; i < endIndex; i++) {
    FlightEntry flight = allFlights.get(i);
     color flightColor = color(0);
     String flightStatus = "ERROR: Flight Status Unknown";
    
    if (flight.cancelled) {
      flightColor = color(255, 0, 0);
      flightStatus = "Cancelled";
    } else {
      int arrTime = convertTimeToMinutes(flight.arrivalTime);
      int crsArrTime = convertTimeToMinutes(flight.scheduledArrivalTime);
      int arrivalDelay = arrTime - crsArrTime; 

      if (arrivalDelay < 0) {
        flightColor = color(0, 0, 255);
        flightStatus = "Early";
      } else if (arrivalDelay == 0) {
        flightColor = color(0, 255, 0);  
        flightStatus = "On Time";
      } else {
        flightColor = color(255, 165, 0); 
      flightStatus = "Late";
      }
    }

    fill(flightColor);  
    
    text(i + 1, 10, spacer);
    text(flight.airline + " " + flight.flightNumber + " " + flight.departureTimeFormatted + " " + flight.originCode +
         " >>>>> " + flight.destinationCode + " " + flight.arrivalTimeFormatted + " " + flightStatus,
         200, spacer);
    spacer += 12;
  }
  fill(0);
  text ("press d to see next 65", 800, 50);
  text ("press a to see next 65", 800, 70);

}

void keyPressed() {
  if (key == 'd' || key == 'D') {
    // Move to next set of rows (increment by 65)
    startIndex += 65;
    if (startIndex >= allFlights.size()) startIndex = 0;  // Reset if we go beyond the data size
  } else if (key == 'a' || key == 'A') {
    // Move to previous set of rows (decrement by 65)
    startIndex -= 65;
    if (startIndex < 0) startIndex = max(0, allFlights.size() - 65);  // Ensure we don't go below 0
  }
}
