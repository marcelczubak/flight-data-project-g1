Table table;
ArrayList<FlightEntry> allFlights;
PFont displayFont;
FlightStatsPieChart pieChart;

void setup() {
  size(1200, 800);
  background(255); 
  displayFont = createFont("Arial", 12, true); 

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
  
  pieChart = new FlightStatsPieChart(900, 400, 300);
  pieChart.countFlights(allFlights);
}

void draw() {
  background(255); 
  textFont(displayFont);
  int spacer = 20;
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
  pieChart.drawPieChart();
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


