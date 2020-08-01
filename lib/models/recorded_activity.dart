class RecordedActivity{
  String activityType;
  String date;
  String duration;
  int distance;

  RecordedActivity(this.activityType, this.date, this.duration, this.distance);

  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    map['type'] = activityType;
    map['date'] = date;
    map['duration'] = duration;
    map['distance'] = distance;

    return map;
  }

  String toString(){
    return "Recorded Activity: \n\tType: " + activityType.toString() + "\n\tDate: " + date + "\n\tDuration: " + duration + "\n\tDistance: " + distance.toString() + " km";
  }

}