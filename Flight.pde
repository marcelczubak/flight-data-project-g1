class FlightEntry {
  
  //static int numberOfFlights = 0;
  String airline;
  String flightNumber;
  String originCode;
  String originName;
  String destinationCode;
  String destinationName;
  String departureTime;
  String arrivalTime;
  Boolean cancelled;
  
  
  
  FlightEntry(String airline, String flightNumber, String originCode, String originName, String destinationCode, String destinationName, String departureTime, String arrivalTime, Boolean cancelled) {
    //numberOfFlights++;
    this.airline = airline;
    this.flightNumber = flightNumber;
    this.originCode = originCode;
    this.originName = originName;
    this.destinationCode = destinationCode;
    this.destinationName = destinationName;
    this.departureTime = departureTime;
    this.arrivalTime = arrivalTime;
    this.cancelled = cancelled;
  }
  
  
} 
