/// Class modeling a goal. The goal is being defined by [goalNumber].
/// The [goalTitle] can be set and a [goalType] shall be provided
/// where type == 0: distance goal, type == 1 duration goal.
/// The [activityType] defines the activity the goal is dedicated to, where
/// activityType == 0 : running, activityType == 1 : cycling
/// activityType == 2 : others
class ActivityGoal {
  final int id;
  final int goalNumber;
  final String goalTitle;
  final int goalType;
  final int activityType;

  ActivityGoal(
      this.id, this.goalNumber, this.goalTitle, this.goalType, this.activityType);

  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    map['id'] = id;
    map['number'] = goalNumber;
    map['title'] = goalTitle;
    map['type'] = goalType;
    map['activity'] = activityType;

    return map;
  }

  String toString() {
    return "ActivityGoal: \n\tGoal: " + goalNumber.toString() + "\n\Title: " +
        goalTitle + "\n\tType: " + goalType.toString() + "\n\tActivity type: " +
        activityType.toString();
  }
}
