Table table;
ArrayList<FlightEntry> allFlights = new ArrayList<>();
PFont displayFont;
FlightStatsPieChart pieChart;
boolean showEntryScreen = true;
boolean showPieChart = false;
boolean showTable = false;
boolean showBarChart = false; 
boolean showFilteredBarChart = false; 
boolean showFilteredPieChart = false;  
int startIndex = 0; 
int amountToDisplay = 30;
int margin = 90;

PImage pieIcon;
PImage filteredPieIcon;
PImage barIcon;
PImage filteredBarIcon;
PImage tableIcon;

Button barChartButton; 
Button pieChartButton; 
Button tableButton;
Button backButton;
Button barChartFilteredButton;
Button pieChartFilteredButton; 

TextBox typeOrigin;

FlightEntry currentFlightEntity; 
String originCodeToFind; 
ArrayList<Integer> indexesToFetch = new ArrayList<>();

void setup() {
  
  tableIcon = loadImage("departures.png");
  tableIcon.resize(50, 50);
  pieIcon = loadImage("expired.png");
  pieIcon.resize(60, 60);
  filteredPieIcon = loadImage("pie-graph.png");
  filteredPieIcon.resize(60, 60);
  barIcon = loadImage("airplane.png");
  barIcon.resize(55, 55);
  filteredBarIcon = loadImage("bar-graph.png");
  filteredBarIcon.resize(55, 55);
 
  size(1200, 775); 
  displayFont = createFont("Arial-Bold", 12, true); 
  
  int buttonWidth = 250;
  
  tableButton = new Button("Show Table", (width-buttonWidth*2)/2 , 360, buttonWidth*2, 70, width/2 + 45, 395, tableIcon, width/2 - 45, 395, color(212, 239, 223));
  pieChartButton = new Button("Flights by Punctuality", (width-buttonWidth)/2 - 125, 450, buttonWidth-10, buttonWidth/2,(width-buttonWidth)/2, 475, pieIcon, (width-buttonWidth)/2, 530, color(252, 243, 207));
  pieChartFilteredButton = new Button("Filtered", (width-buttonWidth)/2 + 134, 450, buttonWidth-10, buttonWidth/2, (width-buttonWidth)/2 + 252, 475, filteredPieIcon, (width+buttonWidth)/2, 525, color(252, 243, 207));
  barChartButton = new Button ("Flights by Distance", (width-buttonWidth)/2 - 125, 590, buttonWidth-10, buttonWidth/2,(width-buttonWidth)/2, 615, barIcon, (width-buttonWidth)/2 -5, 665+5, color(212, 230, 241));
  barChartFilteredButton = new Button("Filtered", (width-buttonWidth)/2 + 134, 590, buttonWidth-10, buttonWidth/2, (width-buttonWidth)/2 + 252, 615, filteredBarIcon, (width+buttonWidth)/2, 665, color(212, 230, 241));
 
  backButton = new Button("Back", 1000, 50, 100, 40, 1050, 70, color(215));  
  typeOrigin = new TextBox(250, 50, 900, 400);

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
    String scheduledDepartureTime = row.getString("CRS_DEP_TIME"); 
    String arrivalTime = row.getString("ARR_TIME");
    String scheduledArrivalTime = row.getString("CRS_ARR_TIME");
    Boolean cancelled = false;
    String cancelledString = row.getString("CANCELLED");
    float distance = row.getFloat("DISTANCE"); 
    
    if (cancelledString.charAt(0) == '1') {
      cancelled = true;
    }
    
   allFlights.add(new FlightEntry(airline, flightNumber, originCode, originName, destinationCode, destinationName, 
                               departureTime, scheduledDepartureTime, arrivalTime, scheduledArrivalTime, cancelled, distance));
  }
   pieChart = new FlightStatsPieChart(600, 400, 500);
   pieChart.countFlights(allFlights);
   drawBarChart();
}

void draw() {
  background(245); 
  textFont(displayFont);
  
  if (showEntryScreen) {
    fill(0);
    textSize(34);
    textAlign(CENTER);
    text("Welcome to the Flight Data Dashboard!", width/2, height/4 + 30);
    
    pieChartButton.display();
    tableButton.display();
    barChartButton.display();
    barChartFilteredButton.display();
    pieChartFilteredButton.display();  
    
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
  } else if (showFilteredPieChart) {    
    drawFilteredPieChart();  
    backButton.display();
  }
    
    textSize(18);
    if (showTable) {
      text("Enter Origin Code:", 1020, 380);
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
      showFilteredPieChart = false;  
  } else if (pieChartFilteredButton.isPressed()) {   
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
  int spacer = 35;
  textAlign(LEFT); 

  int endIndex = min(startIndex + amountToDisplay, indexesToFetch.size());
  
  fill(60);  
  textAlign(CENTER);
  textSize(18);
   
  text("#", 30, spacer);
  text("Flight", margin+13, spacer);
  text("Departure", margin+138, spacer);
  text("Arrival", margin+355, spacer);
  text("Status", margin+482, spacer);
  
  spacer += 25;
  
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
  
        if (arrivalDelay <= 0) {
          flightColor = color(0, 255, 0);
          flightStatus = "On Schedule";               
        } else {
          flightColor = color(255, 165, 0); 
          flightStatus = "Late";
        }
      }
     
     fill(30);  
     textSize(15);
     textAlign(CENTER);
     text(i + 1, 30, spacer);
     textSize(15);
     
     text(flight.airline, margin, spacer);
     text(flight.flightNumber, margin+30, spacer);
     text(flight.getFormattedTime(flight.departureTime), margin+110, spacer);
     text(flight.originCode, margin+170, spacer);
     text(" >>>>> ", margin+250, spacer);
     text(flight.destinationCode, margin+330, spacer);
     text(flight.getFormattedTime(flight.arrivalTime), margin+375, spacer);
     fill(flightColor);
     text(flightStatus, margin+480, spacer);
     
     spacer += 24;
  }
  
  fill(120);
  text ("Press UP/DOWN to scroll", 1050, 750);
}

void keyPressed() {
  
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
  
  if (keyCode == DOWN) {
    scrollOffset = max(0, scrollOffset - 1);
  } else if (keyCode == UP) {
    scrollOffset = min(totalBars - barsPerPage, scrollOffset + 1);
  }
}

void filterFlights() {
  indexesToFetch.clear();
  String input = typeOrigin.text.trim().toUpperCase();

  if (input.isEmpty()) {
    for (int i = 0; i < allFlights.size(); i++) {
      indexesToFetch.add(i);
    }
  } else {
    for (int i = 0; i < allFlights.size(); i++) {
      if (allFlights.get(i).originCode.startsWith(input)) {
        indexesToFetch.add(i);
      }
    }
  }
}
