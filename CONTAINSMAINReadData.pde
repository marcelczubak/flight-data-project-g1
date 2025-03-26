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
Button backButton; // new

void setup() {
  size(1200, 800);
  background(255); 
  displayFont = createFont("Arial", 12, true); 

  pieChartButton = new Button("Show Pie Chart", 400, 600, 200, 50);
  tableButton = new Button("Show Table", 650, 600, 200, 50);
  backButton = new Button("Back",width-120, height-60, 100, 40);  // back button for navigation

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
    String arrivalTime = row.getString("ARR_TIME");
    String scheduledArrivalTime = row.getString("CRS_ARR_TIME");
    
   
    Boolean cancelled = false;
    String cancelledString = row.getString("CANCELLED");
    if (cancelledString.charAt(0) == '1') {
      cancelled = true;
    }
    
   allFlights.add(new FlightEntry(airline, flightNumber, originCode, originName, destinationCode, destinationName, 
                               departureTime, arrivalTime, scheduledArrivalTime, cancelled));
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
    // Show pie chart
    pieChart.drawPieChart();
    backButton.display();  // Display back button on pie chart screen
  } else if (showTable) {
    // Show table
    displayTable();
    backButton.display();  // Display back button on table screen
  }
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
  } else if (showPieChart || showTable) {
    // If back button is pressed, return to entry screen
    if (backButton.isPressed()) {
      showEntryScreen = true;
      showPieChart = false;
      showTable = false;
    }
  }
}


int convertTimeToMinutes(String timeStr) 
{
  if (timeStr.length() == 4) {
    int hours = Integer.parseInt(timeStr.substring(0, 2));
    int minutes = Integer.parseInt(timeStr.substring(2, 4));
    int total = hours * 60 + minutes;
    return total;
  }
  return 0;
}

void displayTable() 
{
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
      int arrTime = flight.arrivalTime.toMinutes();
      int crsArrTime = flight.scheduledArrivalTime.toMinutes();
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
   text(flight.airline + " " + flight.flightNumber + " " + 
     flight.getFormattedTime(flight.departureTime) + " " + flight.originCode +
     " >>>>> " + flight.destinationCode + " " + 
     flight.getFormattedTime(flight.arrivalTime) + " " + flightStatus, 200, spacer);
    spacer += 12;
  }
  fill(0);
  text ("press d to see next 65", 800, 50);
  text ("press a to see previous 65", 800, 70);

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
