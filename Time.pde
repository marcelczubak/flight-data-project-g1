 class Time {
    public int hours;
    public int minutes;

    Time(String times) {
        this.hours = convertStringToHours(times);
        this.minutes = convertStringToMinutes(times);
    }

    private int convertStringToHours(String times) {
        return Integer.parseInt(times.substring(0, 2));
    }

    private int convertStringToMinutes(String times) {
        return Integer.parseInt(times.substring(2, 4));
    }

    public int getDelayInMinutes(Time expectedTime) {
        int diffInHours = this.hours - expectedTime.hours;
        int diffInMinutes = this.minutes - expectedTime.minutes;
        return diffInHours * 60 + diffInMinutes; 
    }
}
