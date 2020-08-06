import 'package:data_visualization_app/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

/// Class implementing a widget which shows the users progress on a specific goal.
/// The goal is being defined by [goalNumber] and the current progress is given by
/// [currentNumber]. The [goalTitle] can be set and a [goalType] shall be provided
/// where type == 0: distance goal, type == 1 duration goal.
/// The [activityType] defines the activity the goal is dedicated to, where
/// activityType == 0 : running, activityType == 1 : cycling
/// activityType == 2 : others
class GoalWidget extends StatelessWidget {
  final double goalNumber;
  final double currentNumber;
  final String goalTitle;
  final int goalType;
  final int activityType;

  GoalWidget(
      this.goalNumber, this.currentNumber, this.goalTitle, this.goalType, this.activityType);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 4.0,
      child: Container(
        padding: EdgeInsets.all(8),
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  goalTitle,
                  style:
                      GoogleFonts.montserrat(color: Colors.white, fontSize: 12),
                ),
                goalType == 0
                    ? Text(
                        currentNumber.toInt().toString() +
                            "/" +
                            goalNumber.toInt().toString() +
                            " km",
                        style: GoogleFonts.montserrat(
                            color: Colors.white, fontSize: 12),
                      )
                    : Text(
                        currentNumber.toInt().toString() +
                            "/" +
                            goalNumber.toInt().toString() +
                            " h",
                        style: GoogleFonts.montserrat(
                            color: Colors.white, fontSize: 12),
                      )
              ],
            ),
            Container(
              padding: EdgeInsets.all(8.0),
            ),
            LinearPercentIndicator(
              lineHeight: 14.0,
              percent: (currentNumber / goalNumber) > 1
                ? 1.0 : (currentNumber / goalNumber),
              center: Text(
                (currentNumber / goalNumber) > 1
                    ? "100%"
                    : ((currentNumber / goalNumber)*100).toStringAsPrecision(2) + "%",
                style: new TextStyle(fontSize: 12.0),
              ),
              trailing: _getActivityIcon(),
              linearStrokeCap: LinearStrokeCap.roundAll,
              backgroundColor: ThemeColors.darkBlue,
              progressColor: _getActivityColor(),
            ),
          ],
        ),
      ),
    );
  }

  /// Method to retrieve the activity type icon
  _getActivityIcon(){
    switch(activityType){
      case 0: return Icon(
        Icons.directions_run,
        color: ThemeColors.lightBlue,
      );
      case 1: return Icon(
        Icons.directions_bike,
        color: ThemeColors.orange,
      );
      case 2: return Icon(
        Icons.filter_hdr,
        color: ThemeColors.yellowGreenish,
      );
      default: return Icon(
        Icons.directions_run,
        color: ThemeColors.lightBlue,
      );
    }
  }

  /// Method to retrieve the activity type color
  _getActivityColor(){
    switch(activityType){
      case 0: return ThemeColors.lightBlue;
      case 1: return ThemeColors.orange;
      case 2: return ThemeColors.yellowGreenish;
      default: return ThemeColors.lightBlue;
    }
  }
}
