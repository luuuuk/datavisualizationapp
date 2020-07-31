class RecordedActivity{
  String activityType;
  String date;
  String duration;
  int distance;

  RecordedActivity(this.activityType, this.date, this.duration, this.distance);

  String toString(){
    return "Recorded Activity: \n\tType: " + activityType.toString() + "\n\tDate: " + date + "\n\tDuration: " + duration + "\n\tDistance: " + distance.toString() + " km";
  }

}