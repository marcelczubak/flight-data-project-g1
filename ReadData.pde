Table table;
ArrayList<flight> allFlights;
PFont stdFont;

void setup() {
  size(800, 800);
  background(255); // White background
  stdFont = createFont("Arial", 20, true); // Load font

  allFlights = new ArrayList<>();
  
  table = loadTable("flights100k(1).csv", "header");
  println(table.getRowCount());
  
  for (TableRow row : table.rows()) {
    String airline = row.getString("MKT_CARRIER");
    int flightNumber = row.getInt("MKT_CARRIER_FL_NUM");
    String airportCode = row.getString("ORIGIN");
    String airportCity = row.getString("ORIGIN_CITY_NAME");
    
    flight current = new flight(airline, flightNumber, airportCode, airportCity);
    allFlights.add(current);
  }
}

void draw() {
  background(255); 
  textFont(stdFont);
  fill(0); 
  
  int y = 50; 
  for (int i = 0; i < min(allFlights.size(), 20); i++) { // Display up to 10 flights
    flight f = allFlights.get(i);
    text(f.airline + " " + f.flightNumber, 50, y);
    y += 30; 
  }
}
