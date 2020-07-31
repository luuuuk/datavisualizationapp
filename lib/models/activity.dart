enum ActivityType{
  running,
  cycling,
  climbing
}

class Activity{
  ActivityType activityType;
  DateTime date;
  Duration duration;
  int distance;

  Activity(this.activityType, this.date, this.duration, this.distance);
}