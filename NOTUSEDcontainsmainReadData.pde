Table table;
ArrayList<FlightEntry> allFlights = new ArrayList<>();
PFont displayFont;
FlightStatsPieChart pieChart;
boolean showEntryScreen = true;
boolean showPieChart = false;
boolean showTable = false;
boolean showBarChart = false; 
boolean showFilteredBarChart = false;  // NEW
int startIndex = 0; 

Button barChartButton; 
Button pieChartButton; 
Button tableButton;
Button backButton;
Button barChartFilteredButton;  // NEW

FlightEntry currentFlightEntity; 
String originCodeToFind; 
ArrayList<Integer> indexesToFetch = new ArrayList<>();

void setup() {
  size(1200, 800);
  background(255); 
  displayFont = createFont("Arial", 12, true); 

  pieChartButton = new Button("Show Pie Chart", 400, 600, 200, 50);
  tableButton = new Button("Show Table", 650, 600, 200, 50);
  backButton = new Button("Back",1000, 50, 100, 40);  // back button for navigation
  barChartButton = new Button ("Show Bar Chart", 900, 600, 200, 50); // NEW BENNY
  barChartFilteredButton = new Button("Filtered Bar Chart", 900, 660, 200, 50);  // NEW

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
    float distance = row.getFloat("DISTANCE");  //NEW JUST ADDED BENNY
    
    if (cancelledString.charAt(0) == '1') {
      cancelled = true;
    }
    
   allFlights.add(new FlightEntry(airline, flightNumber, originCode, originName, destinationCode, destinationName, 
                               departureTime, arrivalTime, scheduledArrivalTime, cancelled, distance));
  }
  
   pieChart = new FlightStatsPieChart(600, 400, 500);
   pieChart.countFlights(allFlights);
   drawBarChart();
  
  // MARCEL WEEK 10 HERE ----------------------------------- Filter by origin code ... 
  originCodeToFind = "LAX";   // hardcoded here...
  
  for (int i = 0; i < allFlights.size(); i++) {
    currentFlightEntity = allFlights.get(i);
    
    if (currentFlightEntity.originCode.equals(originCodeToFind)) {
      indexesToFetch.add(i);
    }
  }
  // ------------------------------------------------------
  
  
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
    barChartButton.display();
    barChartFilteredButton.display(); // NEW
  } else if (showPieChart) {
    pieChart.drawPieChart();
    backButton.display();  
  } else if (showTable) {
    displayTable();
    backButton.display(); 
  } else if (showBarChart) {  //NEW JUST ADDED BENNY
    drawBarChart();
    backButton.display();
  } else if (showFilteredBarChart) {  // NEW
  drawFilteredBarChart();           // NEW
  backButton.display();             // NEW
}
}


void mousePressed() {
  if (showEntryScreen && pieChartButton.isPressed() ) {
      showEntryScreen = false;
      showPieChart = true;
      showTable = false;
      showBarChart = false;
      showFilteredBarChart = false;  // NEW

    } else if (tableButton.isPressed()) {
      showEntryScreen = false;
      showPieChart = false;
      showTable = true;
      showBarChart = false;
    } else if (barChartButton.isPressed()) {  //NEW JUST ADDED BENNY
      showEntryScreen = false;
      showPieChart = false;
      showTable = false;
      showBarChart = true;
    } else if (barChartFilteredButton.isPressed()) {  // NEW
      showEntryScreen = false;
      showPieChart = false;
      showTable = false;
      showBarChart = false;
      showFilteredBarChart = true;  // NEW
    }else if ((showPieChart || showTable || showBarChart || showFilteredBarChart) && backButton.isPressed()) {
      showEntryScreen = true;
      showPieChart = false;
      showTable = false;
      showBarChart = false;
      showFilteredBarChart = false;  // NEW

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
/**
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
      int arrTime = flight.arrivalTime.toMinutes();
      int crsArrTime = flight.scheduledArrivalTime.toMinutes();
      int arrivalDelay = arrTime - crsArrTime; 

      if (arrivalDelay < 0) {
        flightColor = color(0, 0, 255);
        flightStatus = "Early";               // early counts as on time right?
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
**/



// MARCEL WEEK 10  ... duplicated and edited displayTable() method above
FlightEntry flight;
int flightIndex;

void displayTable() {
  int spacer = 20;
   textAlign(LEFT); 

  int endIndex = min(startIndex + 65, indexesToFetch.size());
  for (int i = startIndex; i < endIndex; i++) {
    
       flightIndex = indexesToFetch.get(i);
       flight = allFlights.get(flightIndex);
       
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
          flightStatus = "Early";               // early counts as on time right?
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


// --------------------------------------------------------------------
// NOTE: I replaced allFlights with indexesToFetch in two instances below for display purposes!! Maybe implement a displaySize variable depending on filterlist used

void keyPressed() {
  if (key == 'd' || key == 'D') {
    // Move to next set of rows (increment by 65)
    startIndex += 65;
    if (startIndex >= indexesToFetch.size()) startIndex = 0;  // Reset if we go beyond the data size
  } else if (key == 'a' || key == 'A') {
    // Move to previous set of rows (decrement by 65)
    startIndex -= 65;
    if (startIndex < 0) startIndex = max(0, indexesToFetch.size() - 65);  // Ensure we don't go below 0
  }
}
