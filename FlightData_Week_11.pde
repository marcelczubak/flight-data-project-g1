Table table;
ArrayList<FlightEntry> allFlights = new ArrayList<>();
PFont displayFont;
FlightStatsPieChart pieChart;
boolean showEntryScreen = true;
boolean showPieChart = false;
boolean showTable = false;
boolean showBarChart = false; 
boolean showFilteredBarChart = false; 
boolean showFilteredPieChart = false;  // Week 12 Benny
int startIndex = 0; 
int amountToDisplay = 30;

Button barChartButton; 
Button pieChartButton; 
Button tableButton;
Button backButton;
Button barChartFilteredButton;
Button pieChartFilteredButton;  // Week 12 Benny

TextBox typeOrigin;

FlightEntry currentFlightEntity; 
String originCodeToFind; 
ArrayList<Integer> indexesToFetch = new ArrayList<>();

void setup() {
  size(1200, 800);
  background(255); 
  displayFont = createFont("Arial", 12, true); 

  pieChartButton = new Button("Show Pie Chart", 400, 600, 200, 50);
  pieChartFilteredButton = new Button("Filtered Pie Chart", 400, 660, 200, 50);  // Week 12 Benny
  tableButton = new Button("Show Table", 650, 600, 200, 50);
  backButton = new Button("Back",1000, 50, 100, 40);  
  barChartButton = new Button ("Show Bar Chart", 900, 600, 200, 50); 
  barChartFilteredButton = new Button("Filtered Bar Chart", 900, 660, 200, 50);

  // Week 11 MARCEL
  typeOrigin = new TextBox(250, 50, 700, 375);

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
    String scheduledDepartureTime = row.getString("CRS_DEP_TIME"); //new benny week 12
    String arrivalTime = row.getString("ARR_TIME");
    String scheduledArrivalTime = row.getString("CRS_ARR_TIME");
    Boolean cancelled = false;
    String cancelledString = row.getString("CANCELLED");
    float distance = row.getFloat("DISTANCE"); 
    
    if (cancelledString.charAt(0) == '1') {
      cancelled = true;
    }
    
   allFlights.add(new FlightEntry(airline, flightNumber, originCode, originName, destinationCode, destinationName, 
                               departureTime, scheduledDepartureTime /*new week 12 benny*/, arrivalTime, scheduledArrivalTime, cancelled, distance));
  }
  
   pieChart = new FlightStatsPieChart(600, 400, 500);
   pieChart.countFlights(allFlights);
   drawBarChart();
  
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
    barChartFilteredButton.display();
    pieChartFilteredButton.display();  // Week 12 Benny

    
    // ALL SCREENS HERE ATM ... need to be moved to separate classes
    
  } else if (showPieChart) {
    pieChart.drawPieChart();
    backButton.display();  
  } else if (showTable) {
    displayTable();
    backButton.display(); 
  } else if (showBarChart) {
    drawBarChart();
    backButton.display();
  } else if (showFilteredBarChart) {
    drawFilteredBarChart();
    backButton.display();
  } else if (showFilteredPieChart) {    // Week 12 Benny
    drawFilteredPieChart();  
    backButton.display();
  }
    
    // Week 11 NEW marcel
    textSize(18);
  if (showTable) {
  text("Enter Origin Code:", 790, 360);
  typeOrigin.display();
  }

    
    if (indexesToFetch.isEmpty() && showTable) {
       fill(255, 0, 0);
      text("Error: There were no flights found departing from " + typeOrigin.text.toUpperCase(), 100, 375);
    }
    


}

void mousePressed() {
  typeOrigin.handleClick(mouseX, mouseY);

  if (showEntryScreen && pieChartButton.isPressed() ) {
      showEntryScreen = false;
      showPieChart = true;
      showTable = false;
      showBarChart = false;
      showFilteredBarChart = false;
  } else if (tableButton.isPressed()) {
      showEntryScreen = false;
      showPieChart = false;
      showTable = true;
      showBarChart = false;
      filterFlights();
  } else if (barChartButton.isPressed()) {
      showEntryScreen = false;
      showPieChart = false;
      showTable = false;
      showBarChart = true;
  } else if (barChartFilteredButton.isPressed()) {
      showEntryScreen = false;
      showPieChart = false;
      showTable = false;
      showBarChart = false;
      showFilteredBarChart = true;
  } else if ((showPieChart || showTable || showBarChart || showFilteredBarChart || showFilteredPieChart) && backButton.isPressed()) {
      showEntryScreen = true;
      showPieChart = false;
      showTable = false;
      showBarChart = false;
      showFilteredBarChart = false;
      showFilteredPieChart = false;  // Week 12 Benny
  } else if (pieChartFilteredButton.isPressed()) {    // Week 12 Benny
    showEntryScreen = false;
    showPieChart = false;
    showTable = false;
    showBarChart = false;
    showFilteredBarChart = false;
    showFilteredPieChart = true;
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


FlightEntry flight;
int flightIndex;

void displayTable() {
  int spacer = 20;
   textAlign(LEFT); 

  int endIndex = min(startIndex + amountToDisplay, indexesToFetch.size());
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
  text ("press UP to see next " + amountToDisplay, 800, 50);
  text ("press DOWN to see previous " + amountToDisplay, 800, 70);
}


// NOTE: I replaced allFlights with indexesToFetch in two instances below for display purposes!! Maybe implement a displaySize variable depending on filterlist used

void keyPressed() {
  
  // Week 11 NEW MARCEL
  typeOrigin.handleKey(key);
  
  if (key == '\n') {
    filterFlights();
  }
  
  if (keyCode == UP) {
    startIndex += amountToDisplay;
  } if (startIndex >= indexesToFetch.size()) {
      startIndex = 0; 
  } else if (keyCode == DOWN) {
    startIndex -= amountToDisplay;
    if (startIndex < 0) startIndex = max(0, indexesToFetch.size() - amountToDisplay);  
  }
  
  // New scroll for MainBarChart Benny
  if (key == 'a' || key == 'A') 
  {
    scrollOffset = max(0, scrollOffset - 1);
  }   
    else if (key == 'd' || key == 'D') 
  {
    scrollOffset = min(totalBars - barsPerPage, scrollOffset + 1);
  }


}


// Week 11 NEW MARCEL
void filterFlights() {
  indexesToFetch.clear();
  String input = typeOrigin.text.trim().toUpperCase();

  if (input.isEmpty()) {
    for (int i = 0; i < allFlights.size(); i++) {
      indexesToFetch.add(i);
    }
  } else {
    for (int i = 0; i < allFlights.size(); i++) {
      if (allFlights.get(i).originCode.equals(input)) {
        indexesToFetch.add(i);
      } 
    }
  }
}
