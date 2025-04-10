//SP

class Time {
    public int hours;
    public int minutes;

    Time(String times) {
        if (times == null || times.length() < 4) {  
            this.hours = 0;
            this.minutes = 0;
        } else {
            this.hours = convertStringToHours(times);
            this.minutes = convertStringToMinutes(times);
        }
    }

    private int convertStringToHours(String times) {
        return Integer.parseInt(times.substring(0, 2));
    }

    private int convertStringToMinutes(String times) {
        return Integer.parseInt(times.substring(2, 4));
    }

    public int toMinutes() {
        return hours * 60 + minutes;
    }

    public int getDelayInMinutes(Time expectedTime) {
        return this.toMinutes() - expectedTime.toMinutes();
    }
}
