import 'package:charts_flutter/flutter.dart' as charts;
import 'package:data_visualization_app/models/activity_goal.dart';
import 'dart:ui';

import 'package:data_visualization_app/models/recorded_activity.dart';
import 'package:data_visualization_app/services/database_manager.dart';
import 'package:data_visualization_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SortingDataService {

  /// Method to get series only containing the total activity distance
  List<charts.Series<ActivitiesData, String>> getYearlyActivitiesDistance(
      List<RecordedActivity> recAct) {
    int runningDistance = 0;
    int cyclingDistance = 0;
    int hikingDistance = 0;

    for (RecordedActivity activity in recAct) {

      List splittedDate = activity.date.split(".");

      if(int.parse(splittedDate[2]) == DateTime.now().year) {
        switch (activity.activityType) {
          case "Running":
            runningDistance += activity.distance;
            break;
          case "Cycling":
            cyclingDistance += activity.distance;
            break;
          case "Hiking":
            hikingDistance += activity.distance;
            break;
          case "Climbing":
            break;
        }
      }
    }

    var data = [
      new ActivitiesData('Running', runningDistance, ThemeColors.lightBlue),
      new ActivitiesData('Cycling', cyclingDistance, ThemeColors.orange),
      new ActivitiesData('Hiking', hikingDistance, ThemeColors.blueGreenisShade1),
    ];

    var series = [
      new charts.Series(
        id: 'Total Activity Distance',
        domainFn: (ActivitiesData clickData, _) => clickData.naming,
        measureFn: (ActivitiesData clickData, _) => clickData.number,
        colorFn: (ActivitiesData clickData, _) => clickData.color,
        data: data,
        labelAccessorFn: (ActivitiesData clickData, _) => clickData.number.toString() + " km",
      ),
    ];

    return series;
  }

  /// Method to get series only containing the total activity distance
  List<charts.Series<ActivitiesData, String>> getYearlyActivitiesTime(
      List<RecordedActivity> recAct) {
    int runningTime = 0;
    int cyclingTime = 0;
    int climbingTime = 0;
    int hikingTime = 0;

    for (RecordedActivity activity in recAct) {

      List splittedDate = activity.date.split(".");

      if(int.parse(splittedDate[2]) == DateTime.now().year){
        List stringDurationSplitted = activity.duration.split(":");
        int durationInMin = int.parse(stringDurationSplitted[0]) * 60 + int.parse(stringDurationSplitted[1]);

        switch (activity.activityType) {
          case "Running":
            runningTime += durationInMin;
            break;
          case "Cycling":
            cyclingTime += durationInMin;
            break;
          case "Climbing":
            climbingTime += durationInMin;
            break;
          case "Hiking":
            hikingTime += durationInMin;
            break;
        }
      }
    }

    var data = [
      new ActivitiesData('Running', runningTime, ThemeColors.lightBlue),
      new ActivitiesData('Cycling', cyclingTime, ThemeColors.orange),
      new ActivitiesData('Climbing', climbingTime, ThemeColors.yellowGreenish),
      new ActivitiesData('Hiking', climbingTime, ThemeColors.blueGreenisShade1),
    ];


    var series = [
      new charts.Series(
        id: 'Total Activity Distance',
        domainFn: (ActivitiesData clickData, _) => clickData.naming,
        measureFn: (ActivitiesData clickData, _) => clickData.number,
        colorFn: (ActivitiesData clickData, _) => clickData.color,
        data: data,
        labelAccessorFn: (ActivitiesData clickData, _) => (clickData.number ~/ 60).toString() + " h : " + (clickData.number - (clickData.number ~/ 60)*60).toString() + " m",
      ),
    ];

    return series;
  }

  /// Method to get series containing only activities from the past week
  List<charts.Series<ActivitiesDataDateTime, DateTime>> getWeeklyActivity(
      List<RecordedActivity> recAct) {
    List<charts.Series<ActivitiesDataDateTime, DateTime>> series =
        new List<charts.Series<ActivitiesDataDateTime, DateTime>>();
    List<ActivitiesDataDateTime> runningActivitiesTime =
        new List<ActivitiesDataDateTime>();
    List<ActivitiesDataDateTime> cyclingActivitiesTime =
        new List<ActivitiesDataDateTime>();
    List<ActivitiesDataDateTime> climbingActivitiesTime =
        new List<ActivitiesDataDateTime>();
    List<ActivitiesDataDateTime> hikingActivitiesTime =
        new List<ActivitiesDataDateTime>();

    List<double> runningTimePerDay = [0, 0, 0, 0, 0, 0, 0, 0];
    List<double> cyclingTimePerDay = [0, 0, 0, 0, 0, 0, 0, 0];
    List<double> climbingTimePerDay = [0, 0, 0, 0, 0, 0, 0, 0];
    List<double> hikingTimePerDay = [0, 0, 0, 0, 0, 0, 0, 0];

    /// Go through all activties from today-weekday-1 to today
    /// (weekday starts at 1)
    for (int i = 0; i < (DateTime.now().weekday); i++) {
      /// Check if activities match the date
      for (RecordedActivity activity in recAct) {
        List stringDateSplitted = activity.date.split(".");
        DateTime dateTime = DateTime(int.parse(stringDateSplitted[2]),
            int.parse(stringDateSplitted[1]), int.parse(stringDateSplitted[0]));

        /// Check if the activity happened on the given date
        if (dateTime.compareTo(DateTime(DateTime.now().year,
                    DateTime.now().month, DateTime.now().day)
                .subtract(Duration(days: i))) ==
            0) {
          List stringDurationSplitted = activity.duration.split(":");
          double durationInMin =
              int.parse(stringDurationSplitted[0]).toDouble() +
                  int.parse(stringDurationSplitted[1]) / 60;

          switch (activity.activityType) {
            case "Running":
              runningTimePerDay[i] += durationInMin;
              break;
            case "Cycling":
              cyclingTimePerDay[i] += durationInMin;
              break;
            case "Climbing":
              climbingTimePerDay[i] += durationInMin;
              break;
            case "Hiking":
              hikingTimePerDay[i] += durationInMin;
              break;
          }
        }
      }
    }

    for (int i = 0; i < (DateTime.now().weekday); i++) {
      runningActivitiesTime.insert(0, ActivitiesDataDateTime(
          DateTime(
                  DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .subtract(Duration(days: i)),
          runningTimePerDay[i],
          ThemeColors.blueGreenis));
      cyclingActivitiesTime.insert(0, ActivitiesDataDateTime(
          DateTime(
                  DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .subtract(Duration(days: i)),
          cyclingTimePerDay[i],
          ThemeColors.orange));
      climbingActivitiesTime.insert(0, ActivitiesDataDateTime(
          DateTime(
                  DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .subtract(Duration(days: i)),
          climbingTimePerDay[i],
          ThemeColors.yellowGreenish));
      hikingActivitiesTime.insert(0, ActivitiesDataDateTime(
          DateTime(
                  DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .subtract(Duration(days: i)),
          hikingTimePerDay[i],
          ThemeColors.blueGreenisShade1));
    }

    /// Fill in the rest of the week until day 7 (sunday)
    int daysToAdd = 0;

    while(runningActivitiesTime.length != 7 && cyclingActivitiesTime.length != 7 && climbingActivitiesTime.length != 7 && hikingActivitiesTime.length != 7){

      runningActivitiesTime.add(ActivitiesDataDateTime(
          DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .add(Duration(days: daysToAdd+1)),
          runningTimePerDay[DateTime.now().weekday + daysToAdd],
          ThemeColors.blueGreenis));
      cyclingActivitiesTime.add(ActivitiesDataDateTime(
          DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .add(Duration(days: daysToAdd+1)),
          cyclingTimePerDay[DateTime.now().weekday + daysToAdd],
          ThemeColors.orange));
      climbingActivitiesTime.add(ActivitiesDataDateTime(
          DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .add(Duration(days: daysToAdd+1)),
          climbingTimePerDay[DateTime.now().weekday + daysToAdd],
          ThemeColors.yellowGreenish));
      hikingActivitiesTime.add(ActivitiesDataDateTime(
          DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .add(Duration(days: daysToAdd+1)),
          hikingTimePerDay[DateTime.now().weekday + daysToAdd],
          ThemeColors.blueGreenisShade1));

      daysToAdd++;
    }

    if (runningActivitiesTime.isNotEmpty) {
      series.add(charts.Series<ActivitiesDataDateTime, DateTime>(
        id: 'Running',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (ActivitiesDataDateTime sales, _) => sales.dateTime,
        measureFn: (ActivitiesDataDateTime sales, _) => sales.number,
        data: runningActivitiesTime,
      ));
    }
    if (cyclingActivitiesTime.isNotEmpty) {
      series.add(
        charts.Series<ActivitiesDataDateTime, DateTime>(
          id: 'Cycling',
          colorFn: (ActivitiesDataDateTime sales, __) => sales.color,
          domainFn: (ActivitiesDataDateTime sales, _) => sales.dateTime,
          measureFn: (ActivitiesDataDateTime sales, _) => sales.number,
          data: cyclingActivitiesTime,
        ),
      );
    }
    if (climbingActivitiesTime.isNotEmpty) {
      series.add(
        charts.Series<ActivitiesDataDateTime, DateTime>(
          id: 'Climbing',
          colorFn: (ActivitiesDataDateTime sales, __) => sales.color,
          domainFn: (ActivitiesDataDateTime sales, _) => sales.dateTime,
          measureFn: (ActivitiesDataDateTime sales, _) => sales.number,
          data: climbingActivitiesTime,
        ),
      );
    }
    if (hikingActivitiesTime.isNotEmpty) {
      series.add(
        charts.Series<ActivitiesDataDateTime, DateTime>(
          id: 'Climbing',
          colorFn: (ActivitiesDataDateTime sales, __) => sales.color,
          domainFn: (ActivitiesDataDateTime sales, _) => sales.dateTime,
          measureFn: (ActivitiesDataDateTime sales, _) => sales.number,
          data: hikingActivitiesTime,
        ),
      );
    }

    return series;
  }

  /// Method to get series containing only activity times from the past 12 weeks
  List<charts.Series<ActivitiesDataDateTime, DateTime>> getActivityTimePast12Weeks(
      List<RecordedActivity> recAct) {
    List<charts.Series<ActivitiesDataDateTime, DateTime>> series =
    new List<charts.Series<ActivitiesDataDateTime, DateTime>>();
    List<ActivitiesDataDateTime> runningActivitiesTime =
    new List<ActivitiesDataDateTime>();
    List<ActivitiesDataDateTime> cyclingActivitiesTime =
    new List<ActivitiesDataDateTime>();
    List<ActivitiesDataDateTime> climbingActivitiesTime =
    new List<ActivitiesDataDateTime>();

    List<double> runningTimePerWeek = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    List<double> cyclingTimePerWeek = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    List<double> climbingTimePerWeek = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

    /// Go through all activties from weeks T-11 to now()
    for (int i = 0; i < 11; i++) {
      /// Check if activities match the date
      for (RecordedActivity activity in recAct) {
        List stringDateSplitted = activity.date.split(".");
        DateTime dateTime = DateTime(int.parse(stringDateSplitted[2]),
            int.parse(stringDateSplitted[1]), int.parse(stringDateSplitted[0]));

        /// Check if activity happened this week
        if(i < DateTime.now().weekday && dateTime.compareTo(DateTime(DateTime.now().year,
            DateTime.now().month, DateTime.now().day).subtract(Duration(days: i))) == 0){

          /// Add duration to current week
          List stringDurationSplitted = activity.duration.split(":");
          double durationInMin =
              int.parse(stringDurationSplitted[0]).toDouble() +
                  int.parse(stringDurationSplitted[1]) / 60;

          switch (activity.activityType) {
            case "Running":
              runningTimePerWeek[0] += durationInMin;
              break;
            case "Cycling":
              cyclingTimePerWeek[0] += durationInMin;
              break;
            case "Climbing":
              climbingTimePerWeek[0] += durationInMin;
          }
        }

        /// Check if the activity happened on the given date
        if (dateTime.compareTo(DateTime(DateTime.now().year,
            DateTime.now().month, DateTime.now().day)
            .subtract(Duration(days: 7*i + DateTime.now().weekday))) <=
            0 && dateTime.compareTo(DateTime(DateTime.now().year,
            DateTime.now().month, DateTime.now().day)
            .subtract(Duration(days: 7*(i+1) + DateTime.now().weekday))) >=
            0) {
          List stringDurationSplitted = activity.duration.split(":");
          double durationInMin =
              int.parse(stringDurationSplitted[0]).toDouble() +
                  int.parse(stringDurationSplitted[1]) / 60;

          switch (activity.activityType) {
            case "Running":
              runningTimePerWeek[i+1] += durationInMin;
              break;
            case "Cycling":
              cyclingTimePerWeek[i+1] += durationInMin;
              break;
            case "Climbing":
              climbingTimePerWeek[i+1] += durationInMin;
          }
        }
      }
    }

    for (int i = 0; i < 12; i++) {
      runningActivitiesTime.add(ActivitiesDataDateTime(
          DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .subtract(Duration(days: 7*i + DateTime.now().weekday) ),
          runningTimePerWeek[i],
          ThemeColors.lightBlue));
      cyclingActivitiesTime.add(ActivitiesDataDateTime(
          DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .subtract(Duration(days: 7*i + DateTime.now().weekday)),
          cyclingTimePerWeek[i],
          ThemeColors.orange));
      climbingActivitiesTime.add(ActivitiesDataDateTime(
          DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .subtract(Duration(days: 7*i + DateTime.now().weekday)),
          climbingTimePerWeek[i],
          ThemeColors.yellowGreenish));
    }

    if (runningActivitiesTime.isNotEmpty) {
      series.add(charts.Series<ActivitiesDataDateTime, DateTime>(
        id: 'Running',
        colorFn: (ActivitiesDataDateTime sales, __) => sales.color,
        domainFn: (ActivitiesDataDateTime sales, _) => sales.dateTime,
        measureFn: (ActivitiesDataDateTime sales, _) => sales.number,
        data: runningActivitiesTime,
      ));
    }
    if (cyclingActivitiesTime.isNotEmpty) {
      series.add(
        charts.Series<ActivitiesDataDateTime, DateTime>(
          id: 'Cycling',
          colorFn: (ActivitiesDataDateTime sales, __) => sales.color,
          domainFn: (ActivitiesDataDateTime sales, _) => sales.dateTime,
          measureFn: (ActivitiesDataDateTime sales, _) => sales.number,
          data: cyclingActivitiesTime,
        ),
      );
    }
    if (climbingActivitiesTime.isNotEmpty) {
      series.add(
        charts.Series<ActivitiesDataDateTime, DateTime>(
          id: 'Climbing',
          colorFn: (ActivitiesDataDateTime sales, __) => sales.color,
          domainFn: (ActivitiesDataDateTime sales, _) => sales.dateTime,
          measureFn: (ActivitiesDataDateTime sales, _) => sales.number,
          data: climbingActivitiesTime,
        ),
      );
    }

    return series;
  }

  /// Method to get series containing only activity distances from the past 12 weeks
  List<charts.Series<ActivitiesDataDateTime, DateTime>> getActivityDistancePast12Weeks(
      List<RecordedActivity> recAct) {
    List<charts.Series<ActivitiesDataDateTime, DateTime>> series =
    new List<charts.Series<ActivitiesDataDateTime, DateTime>>();
    List<ActivitiesDataDateTime> runningActivitiesDistance =
    new List<ActivitiesDataDateTime>();
    List<ActivitiesDataDateTime> cyclingActivitiesDistance =
    new List<ActivitiesDataDateTime>();

    List<double> runningDistancePerWeek = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    List<double> cyclingDistancePerWeek = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

    /// Go through all activties from weeks T-11 to now()
    for (int i = 0; i < 11; i++) {
      /// Check if activities match the date
      for (RecordedActivity activity in recAct) {
        List stringDateSplitted = activity.date.split(".");
        DateTime dateTime = DateTime(int.parse(stringDateSplitted[2]),
            int.parse(stringDateSplitted[1]), int.parse(stringDateSplitted[0]));

        /// Check if activity happened this week
        if(i < DateTime.now().weekday && dateTime.compareTo(DateTime(DateTime.now().year,
            DateTime.now().month, DateTime.now().day).subtract(Duration(days: i))) == 0){

          /// Add distance to current week
          int distanceKm = activity.distance;

          switch (activity.activityType) {
            case "Running":
              runningDistancePerWeek[0] += distanceKm;
              break;
            case "Cycling":
              cyclingDistancePerWeek[0] += distanceKm;
              break;
          }
        }


        /// Check if the activity happened on the given date
        if (dateTime.compareTo(DateTime(DateTime.now().year,
            DateTime.now().month, DateTime.now().day)
            .subtract(Duration(days: 7*i + DateTime.now().weekday))) <=
            0 && dateTime.compareTo(DateTime(DateTime.now().year,
            DateTime.now().month, DateTime.now().day)
            .subtract(Duration(days: 7*(i+1) + DateTime.now().weekday))) >=
            0) {
          int distanceKm = activity.distance;

          switch (activity.activityType) {
            case "Running":
              runningDistancePerWeek[i+1] += distanceKm;
              break;
            case "Cycling":
              cyclingDistancePerWeek[i+1] += distanceKm;
              break;
          }
        }
      }
    }

    for (int i = 0; i < 12; i++) {
      runningActivitiesDistance.add(ActivitiesDataDateTime(
          DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .subtract(Duration(days: 7*i + DateTime.now().weekday)),
          runningDistancePerWeek[i],
          ThemeColors.lightBlue));
      cyclingActivitiesDistance.add(ActivitiesDataDateTime(
          DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .subtract(Duration(days: 7*i + DateTime.now().weekday)),
          cyclingDistancePerWeek[i],
          ThemeColors.orange));
    }

    if (runningActivitiesDistance.isNotEmpty) {
      series.add(charts.Series<ActivitiesDataDateTime, DateTime>(
        id: 'Running',
        colorFn: (ActivitiesDataDateTime sales, __) => sales.color,
        domainFn: (ActivitiesDataDateTime sales, _) => sales.dateTime,
        measureFn: (ActivitiesDataDateTime sales, _) => sales.number,
        data: runningActivitiesDistance,
      ));
    }
    if (cyclingActivitiesDistance.isNotEmpty) {
      series.add(
        charts.Series<ActivitiesDataDateTime, DateTime>(
          id: 'Cycling',
          colorFn: (ActivitiesDataDateTime sales, __) => sales.color,
          domainFn: (ActivitiesDataDateTime sales, _) => sales.dateTime,
          measureFn: (ActivitiesDataDateTime sales, _) => sales.number,
          data: cyclingActivitiesDistance,
        ),
      );
    }

    return series;
  }

  /// Method to get series only containing the total activity distance
  /// type 0: Running, type 1: Cycling
  List<charts.Series<ActivitiesPrecisionData, String>> getAverageSpeedData(
      List<RecordedActivity> recAct, int noOfActivities, int type, bool inverseColors) {

    List<charts.Series<ActivitiesPrecisionData, String>> series =
    new List<charts.Series<ActivitiesPrecisionData, String>>();
    List<ActivitiesPrecisionData> averageSpeeds =
    new List<ActivitiesPrecisionData>();
    List<ActivitiesPrecisionData> targetSpeeds =new List<ActivitiesPrecisionData>();

    /// Sort activities
    recAct.sort((a,b) {
      List<String> splittedDateA = a.date.split(".");
      List<String> splittedDateB = b.date.split(".");
      DateTime dateA = DateTime(int.parse(splittedDateA[2]),int.parse(splittedDateA[1]),int.parse(splittedDateA[0]));
      DateTime dateB = DateTime(int.parse(splittedDateB[2]),int.parse(splittedDateB[1]),int.parse(splittedDateB[0]));
      return -dateA.compareTo(dateB);
    });

    int noOfIncludedActivities = 0;
    String lookingForType = type == 0 ? "Running" : "Cycling";

    /// Iterate through all activities
    for(RecordedActivity activity in recAct){

      /// Include only the wanted number of activities and the right activity type
      if(noOfIncludedActivities < noOfActivities && activity.activityType == lookingForType){

        List splittedDuration = activity.duration.split(":");
        List splittedDate = activity.date.split(".");

        double averageSpeed = activity.distance.toDouble() / (double.parse(splittedDuration[0]) + double.parse(splittedDuration[1]) / 60);

        averageSpeeds.insert(0, ActivitiesPrecisionData(
            splittedDate[0] + "." + splittedDate[1],
            averageSpeed,
            type == 0 ? ThemeColors.lightBlue : ThemeColors.orange));

        /// Add data for target lines
        targetSpeeds.add(ActivitiesPrecisionData(
          splittedDate[0] + "." + splittedDate[1],
          type == 0 ? 10 : 30,
            inverseColors
                ? ThemeColors.darkBlue
                : Colors.white));

        noOfIncludedActivities++;

      }
    }

    if (averageSpeeds.isNotEmpty) {
      series.add(charts.Series<ActivitiesPrecisionData, String>(
        id: type == 0 ? 'Running' : 'Cycling',
        colorFn: (ActivitiesPrecisionData sales, __) => sales.color,
        domainFn: (ActivitiesPrecisionData sales, _) => sales.title,
        measureFn: (ActivitiesPrecisionData sales, _) => sales.number,
        data: averageSpeeds,
      ));
      series.add(charts.Series<ActivitiesPrecisionData, String>(
        id: type == 0 ? 'Running' : 'Cycling',
        colorFn: (ActivitiesPrecisionData sales, __) => sales.color,
        domainFn: (ActivitiesPrecisionData sales, _) => sales.title,
        measureFn: (ActivitiesPrecisionData sales, _) => sales.number,
        data: targetSpeeds,
      )..setAttribute(charts.rendererIdKey, 'customTargetLine'),);
    }

    return series;

  }

  List<List<int>> getOverviewData(List<RecordedActivity> activities, int overviewCode) {

    /// Hours, Minutes, Seconds, Distance
    List<int> cyclingTime = [0, 0, 0, 0];
    List<int> runningTime = [0, 0, 0, 0];
    List<int> climbingTime = [0, 0, 0];
    List<int> hikingTime = [0, 0, 0, 0];
    List<List<int>> returnList = new List();
    bool expressionToEvaluate;

    for (RecordedActivity activity in activities) {
      List stringDateSplitted = activity.date.split(".");
      DateTime dateTime = DateTime(int.parse(stringDateSplitted[2]),
          int.parse(stringDateSplitted[1]), int.parse(stringDateSplitted[0]));

      switch (overviewCode) {
        case 0:
          {
            expressionToEvaluate = (dateTime
                .compareTo(DateTime.now().subtract(Duration(days: DateTime
                .now()
                .weekday))) >
                0);
          }
          break;
        case 1:
          {
            expressionToEvaluate = (dateTime.month == DateTime
                .now()
                .month);
          }
          break;
        case 2:
          {
            expressionToEvaluate = (dateTime.year == DateTime
                .now()
                .year);
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
            break;
          case "Hiking":
            {
              hikingTime[0] += durationInHours;
              hikingTime[1] += durationInMinutes;
              hikingTime[2] += activity.distance;
              hikingTime[3]++;
            }
            break;
          default: {
            runningTime[0] += durationInHours;
            runningTime[1] += durationInMinutes;
            runningTime[2] += activity.distance;
            runningTime[3]++;
          }
        }
      }
    }

    /// Calculate sum of time
    int fullRunningHoursToAdd = runningTime[1] ~/ 60;
    int fullCyclingHoursToAdd = cyclingTime[1] ~/ 60;
    int fullClimbingHoursToAdd = climbingTime[1] ~/ 60;
    int fullHikingHoursToAdd = hikingTime[1] ~/ 60;
    runningTime[0] += fullRunningHoursToAdd;
    runningTime[1] -= fullRunningHoursToAdd * 60;
    cyclingTime[0] += fullCyclingHoursToAdd;
    cyclingTime[1] -= fullCyclingHoursToAdd * 60;
    climbingTime[0] += fullClimbingHoursToAdd;
    climbingTime[1] -= fullClimbingHoursToAdd * 60;
    hikingTime[0] += fullHikingHoursToAdd;
    hikingTime[1] -= fullHikingHoursToAdd * 60;

    returnList.add(runningTime);
    returnList.add(cyclingTime);
    returnList.add(climbingTime);
    returnList.add(hikingTime);

    return returnList;
  }

  Future<double> getCurrentGoalProgress(ActivityGoal goal) async {
    DatabaseManager dbManager = new DatabaseManager();
    List<RecordedActivity> activities = await dbManager.getActivities();

    List data =
    SortingDataService().getOverviewData(activities, goal.timeFrame);

    double goalProgress = 0.0;

    /// 0: distance, 1: duration
    switch (goal.goalType) {
      case 0:
        {
          goalProgress = data[goal.activityType][2].toDouble();
        }
        break;
      case 1:
        {
          goalProgress =
              (data[goal.activityType][0] + data[goal.activityType][1] / 60).toDouble();
        }
        break;
      default:
        {
          goalProgress = data[goal.activityType][2].toDouble();
        }
        break;
    }

    return goalProgress;
  }

}

class ActivitiesData {
  final String naming;
  final int number;
  final charts.Color color;

  ActivitiesData(this.naming, this.number, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class ActivitiesDataDateTime {
  final DateTime dateTime;
  final double number;
  final charts.Color color;

  ActivitiesDataDateTime(this.dateTime, this.number, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class ActivitiesPrecisionData {
  String title;
  final double number;
  final charts.Color color;

  ActivitiesPrecisionData(this.title, this.number, Color color)
      : this.color = new charts.Color(
      r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
