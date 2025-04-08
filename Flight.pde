class FlightEntry {  
    String airline;
    String flightNumber;
    String originCode;
    String originName;
    String destinationCode;
    String destinationName;
    Time departureTime;
    Time scheduledDepartureTime; 
    Time arrivalTime;    
    Time scheduledArrivalTime;
    Boolean cancelled;
    float distance; 
   
    FlightEntry(String airline, String flightNumber, String originCode, String originName, String destinationCode, String destinationName,
                String departureTime, String scheduledDepartureTime, String arrivalTime, String scheduledArrivalTime, Boolean cancelled, float distance) {  
        this.airline = airline;
        this.flightNumber = flightNumber;
        this.originCode = originCode;
        this.originName = originName;
        this.destinationCode = destinationCode;
        this.destinationName = destinationName;
        this.departureTime = new Time(departureTime);
        this.scheduledDepartureTime = new Time(scheduledDepartureTime); 
        this.arrivalTime = new Time(arrivalTime);
        this.scheduledArrivalTime = new Time(scheduledArrivalTime);
        this.cancelled = cancelled;
        this.distance = distance;   
      }  

    String getFormattedTime(Time time) {
        return String.format("%02d:%02d", time.hours, time.minutes);
    }
}
