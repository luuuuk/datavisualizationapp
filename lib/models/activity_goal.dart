/// Class modeling a goal. The goal is being defined by [goalNumber].
/// The [goalTitle] can be set and a [goalType] shall be provided
/// where type == 0: distance goal, type == 1 duration goal.
/// The [activityType] defines the activity the goal is dedicated to, where
/// activityType == 0 : running, 1 : cycling, 2 : climbing, 3 : hiking
/// The [timeFrame] defines the span of the goal, where 0: week, 1: month, 2: year
class ActivityGoal {
  final int id;
  final int goalNumber;
  final String goalTitle;
  final int goalType;
  final int activityType;
  final int timeFrame;

  ActivityGoal(
      this.id, this.goalNumber, this.goalTitle, this.goalType, this.activityType, this.timeFrame);

  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    map['id'] = id;
    map['number'] = goalNumber;
    map['title'] = goalTitle;
    map['type'] = goalType;
    map['activity'] = activityType;
    map['span'] = timeFrame;

    return map;
  }

  String toString() {
    return "ActivityGoal: \n\tID: " + id.toString() + "\n\tGoal: " + goalNumber.toString() + "\n\tTitle: " +
        goalTitle + "\n\tType: " + goalType.toString() + "\n\tActivity type: " +
        activityType.toString() + "\n\tTime Frame: " + timeFrame.toString();
  }
}
