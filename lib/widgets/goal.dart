import 'package:data_visualization_app/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

/// Class implementing a widget which shows the users progress on a specific goal.
/// The goal is being defined by [goalNumber] and the current progress is given by
/// [currentNumber]. The [goalTitle] can be set and a [goalType] shall be provided
/// where type == 0: distance goal, type == 1 duration goal.
/// The [activityType] defines the activity the goal is dedicated to, where
/// activityType == 0 : running, activityType == 1 : cycling
/// activityType == 2 : others
/// [timeFrame] gives the duration of the goal where 0: week, 1: month, 2: year
class GoalWidget extends StatelessWidget {
  final double goalNumber;
  final double currentNumber;
  final String goalTitle;
  final int goalType;
  final int activityType;
  final int timeFrame;

  GoalWidget(this.goalNumber, this.currentNumber, this.goalTitle, this.goalType,
      this.activityType, this.timeFrame);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 4,
      height: 210,
      decoration: BoxDecoration(
        color: ThemeColors.mediumBlue,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  RotatedBox(
                    quarterTurns: 3,
                    child: Text(
                      _getGoalTitle(0),
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                      textAlign: TextAlign.justify,
                      overflow: TextOverflow.fade,
                      maxLines: 3,
                    ),
                  ),
                  RotatedBox(
                    quarterTurns: 3,
                    child: Text(
                      _getGoalTitle(1),
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                      textAlign: TextAlign.justify,
                      overflow: TextOverflow.fade,
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 16),
            child: CircularPercentIndicator(
              lineWidth: 4,
              radius: 82.0,
              percent: (currentNumber / goalNumber) > 1
                  ? 1.0
                  : (currentNumber / goalNumber),
              center: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    (currentNumber / goalNumber) > 1
                        ? "100%"
                        : ((currentNumber / goalNumber) * 100)
                                .toStringAsPrecision(2) +
                            "%",
                    style: new TextStyle(fontSize: 12.0, color: Colors.white),
                  ),
                  goalType == 0
                      ? Text(
                          currentNumber.toInt().toString() +
                              "/" +
                              goalNumber.toInt().toString() +
                              " km",
                          style: GoogleFonts.montserrat(
                              color: Colors.white, fontSize: 8),
                        )
                      : Text(
                          currentNumber.toInt().toString() +
                              "/" +
                              goalNumber.toInt().toString() +
                              " h",
                          style: GoogleFonts.montserrat(
                              color: Colors.white, fontSize: 8),
                        )
                ],
              ),
              backgroundColor: Colors.white,
              progressColor: _getActivityColor(),
            ),
          ),
        ],
      ),
    );
  }

  /// Method to retrieve the activity type icon
  _getActivityIcon() {
    switch (activityType) {
      case 0:
        return Icon(
          Icons.directions_run,
          color: ThemeColors.lightBlue,
        );
      case 1:
        return Icon(
          Icons.directions_bike,
          color: ThemeColors.orange,
        );
      case 2:
        return Icon(
          Icons.filter_hdr,
          color: ThemeColors.yellowGreenish,
        );
      case 3:
        return Icon(
          Icons.directions_walk,
          color: ThemeColors.blueGreenisShade1,
        );
      default:
        return Icon(
          Icons.directions_run,
          color: ThemeColors.lightBlue,
        );
    }
  }

  /// Method to retrieve the activity type color
  _getActivityColor() {
    switch (activityType) {
      case 0:
        return ThemeColors.lightBlue;
      case 1:
        return ThemeColors.orange;
      case 2:
        return ThemeColors.yellowGreenish;
      case 3:
        return ThemeColors.blueGreenisShade1;
      default:
        return ThemeColors.lightBlue;
    }
  }

  /// Method to get the goal title
  /// part 0:
  _getGoalTitle(int part) {
    String goal = "";

    if (part == 0) {
      switch (timeFrame) {
        case 0:
          goal += "Weekly";
          break;
        case 1:
          goal += "Monthly";
          break;
        case 2:
          goal += "Annual";
          break;
        default:
          goal += "Weekly";
      }
    } else {
      switch (activityType) {
        case 0:
          goal += "Running ";
          break;
        case 1:
          goal += "Cycling ";
          break;
        case 2:
          goal += "Climbing ";
          break;
        case 3:
          goal += "Hiking ";
          break;
        default:
          goal += "Running ";
      }

      goal += "Goal";
    }

    return goal;
  }
}
