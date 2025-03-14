Table table;
ArrayList<FlightEntry> allFlights;
PFont displayFont;

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
    String arrivalTime = row.getString("ARR_TIME");
    
    if (departureTime.length() >= 4) {
      departureTime = departureTime.substring(0,2) + ":" + departureTime.substring(2,4);
    } else {
      departureTime = "XX:XX";
    }
    if (arrivalTime.length() == 4) {
      arrivalTime = arrivalTime.substring(0,2) + ":" + arrivalTime.substring(2,4);
    } else {
      arrivalTime = "XX:XX";
    }
    
    Boolean cancelled = false;
    String cancelledString = row.getString("CANCELLED");
    if (cancelledString.charAt(0) == '1') {
      cancelled = true;
    }
    
    allFlights.add(new FlightEntry(airline, flightNumber, originCode, originName, destinationCode, destinationName, departureTime, arrivalTime, cancelled));
  }
}

void draw() {
  background(255); 
  textFont(displayFont);
  
  int spacer = 20;
  for (int i = 0; i < min(allFlights.size(), 65); i++) { 
    
    FlightEntry flight = allFlights.get(i);
    
    if (flight.cancelled) {
      fill(255, 0, 0);
    } else {
      fill(0);
    }
    text(i+1, 20, spacer);
    text(flight.airline + " " + 
    flight.flightNumber +"         "+ 
    flight.departureTime + " " +
    flight.originCode + " " + 
    flight.originName + "  >>>>>   " + 
    flight.destinationCode + " " + 
    flight.destinationName + " " +
    flight.arrivalTime + " " +
    (flight.cancelled ? "Cancelled" : "")
    ,70, spacer);
    
    spacer += 12; 
  }
}
