class FlightEntry {
  
  //static int numberOfFlights = 0;
  String airline;
  String flightNumber;
  String originCode;
  String originName;
  String destinationCode;
  String destinationName;
  String departureTime;
  String departureTimeFormatted;
  String scheduledDepartureTime; // not used at all yet
  String arrivalTime;
  String arrivalTimeFormatted;
  String scheduledArrivalTime;
  Boolean cancelled;
  
  
  FlightEntry(String airline, String flightNumber, String originCode, String originName, String destinationCode, String destinationName, 
  String departureTime, String departureTimeFormatted, String arrivalTime, String arrivalTimeFormatted, String scheduledArrivalTime, Boolean cancelled) {
    //numberOfFlights++;
    this.airline = airline;
    this.flightNumber = flightNumber;
    this.originCode = originCode;
    this.originName = originName;
    this.destinationCode = destinationCode;
    this.destinationName = destinationName;
    this.departureTime = departureTime;
    this.departureTimeFormatted = departureTimeFormatted;
    this.arrivalTime = arrivalTime;
    this.arrivalTimeFormatted = arrivalTimeFormatted;
    this.scheduledArrivalTime = scheduledArrivalTime;
    this.cancelled = cancelled;
    //this.delay = delay;
 
  }  
} 
