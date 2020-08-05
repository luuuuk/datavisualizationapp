import 'package:data_visualization_app/models/recorded_activity.dart';
import 'package:data_visualization_app/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OverviewWidget extends StatelessWidget{
  final List<RecordedActivity> activities;
  final int overviewCode;

  OverviewWidget(this.activities, this.overviewCode);

  @override
  Widget build(BuildContext context) {

    /// Hours, Minutes, Seconds, Distance
    List<int> cyclingTime = [0, 0, 0, 0];
    List<int> runningTime = [0, 0, 0, 0];
    List<int> climbingTime = [0, 0, 0];
    bool expressionToEvaluate;

    for (RecordedActivity activity in activities) {
      List stringDateSplitted = activity.date.split(".");
      DateTime dateTime = DateTime(int.parse(stringDateSplitted[2]),
          int.parse(stringDateSplitted[1]), int.parse(stringDateSplitted[0]));

      switch (overviewCode) {
        case 0:
          {
            expressionToEvaluate = (dateTime
                .compareTo(DateTime.now().subtract(Duration(days: 7))) >
                0);
          }
          break;
        case 1:
          {
            expressionToEvaluate = (dateTime.month == DateTime.now().month);
          }
          break;
        case 2:
          {
            expressionToEvaluate = (dateTime.year == DateTime.now().year);
          }
          break;
        default:
          expressionToEvaluate =
          (dateTime.compareTo(DateTime.now().subtract(Duration(days: 7))) >
              0);
      }

      /// If older than a week, do not include
      if (expressionToEvaluate) {
        List stringDurationSplitted = activity.duration.split(":");
        int durationInHours = int.parse(stringDurationSplitted[0]);
        int durationInMinutes = int.parse(stringDurationSplitted[1]);

        /// Add up duration and distance per activity type
        switch (activity.activityType) {
          case "Running":
            {
              runningTime[0] += durationInHours;
              runningTime[1] += durationInMinutes;
              runningTime[2] += activity.distance;
              runningTime[3]++;
            }
            break;
          case "Cycling":
            {
              cyclingTime[0] += durationInHours;
              cyclingTime[1] += durationInMinutes;
              cyclingTime[2] += activity.distance;
              cyclingTime[3]++;
            }
            break;
          case "Climbing":
            {
              climbingTime[0] += durationInHours;
              climbingTime[1] += durationInMinutes;
              climbingTime[2]++;
            }
        }
      }
    }

    /// Calculate sum of time
    int fullRunningHoursToAdd = runningTime[1] ~/ 60;
    int fullCyclingHoursToAdd = cyclingTime[1] ~/ 60;
    int fullClimbingHoursToAdd = climbingTime[1] ~/ 60;
    runningTime[0] += fullRunningHoursToAdd;
    runningTime[1] -= fullRunningHoursToAdd * 60;
    cyclingTime[0] += fullCyclingHoursToAdd;
    cyclingTime[1] -= fullCyclingHoursToAdd * 60;
    climbingTime[0] += fullClimbingHoursToAdd;
    climbingTime[1] -= fullClimbingHoursToAdd * 60;

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              children: <Widget>[
                Icon(
                  Icons.directions_run,
                  color: ThemeColors.lightBlue,
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    runningTime[0].toString() +
                        " h : " +
                        runningTime[1].toString() +
                        " m",
                    style: GoogleFonts.montserrat(
                        color: Colors.white, fontSize: 14),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
                  child: Text(
                    runningTime[2].toString() +
                        " km",
                    style: GoogleFonts.montserrat(
                        color: Colors.white, fontSize: 14),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
                  child: Text(
                    runningTime[3] == 0 ? "- km/run" : (runningTime[2] / runningTime[3]).toStringAsPrecision(2) +
                        " km/run",
                    style: GoogleFonts.montserrat(
                        color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Icon(
                  Icons.directions_bike,
                  color: ThemeColors.orange,
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    cyclingTime[0].toString() +
                        " h : " +
                        cyclingTime[1].toString() +
                        " m",
                    style: GoogleFonts.montserrat(
                        color: Colors.white, fontSize: 14),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
                  child: Text(
                    cyclingTime[2].toString() +
                        " km",
                    style: GoogleFonts.montserrat(
                        color: Colors.white, fontSize: 14),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
                  child: Text(
                    cyclingTime[3] == 0 ? "- km/ride" : (cyclingTime[2] / cyclingTime[3]).toStringAsPrecision(2) +
                        " km/ride",
                    style: GoogleFonts.montserrat(
                        color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Icon(
                  Icons.filter_hdr,
                  color: ThemeColors.yellowGreenish,
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    climbingTime[0].toString() +
                        " h : " +
                        climbingTime[1].toString() +
                        " m",
                    style: GoogleFonts.montserrat(
                        color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

}