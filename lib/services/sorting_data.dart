import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:ui';

import 'package:data_visualization_app/models/recorded_activity.dart';
import 'package:data_visualization_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SortingDataService {

  /// Method to get series only containing the total activity distance
  List<charts.Series<ActivitiesData, String>> getYearlyActivitiesDistance(
      List<RecordedActivity> recAct) {
    int runningDistance = 0;
    int cyclingDistance = 0;

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
          case "Climbing":
            break;
        }
      }
    }

    var data = [
      new ActivitiesData('Running', runningDistance, ThemeColors.lightBlue),
      new ActivitiesData('Cycling', cyclingDistance, ThemeColors.orange),
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
            cyclingTime += durationInMin;
            break;
        }
      }
    }

    var data = [
      new ActivitiesData('Running', runningTime, ThemeColors.lightBlue),
      new ActivitiesData('Cycling', cyclingTime, ThemeColors.orange),
      new ActivitiesData('Climbing', climbingTime, ThemeColors.yellowGreenish),
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

    List<double> runningTimePerDay = [0, 0, 0, 0, 0, 0, 0, 0];
    List<double> cyclingTimePerDay = [0, 0, 0, 0, 0, 0, 0, 0];
    List<double> climbingTimePerDay = [0, 0, 0, 0, 0, 0, 0, 0];

    /// Go through all activties from day T-7 to now()
    for (int i = 0; i < 8; i++) {
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
          }
        }
      }
    }

    for (int i = 0; i < 8; i++) {
      runningActivitiesTime.add(ActivitiesDataDateTime(
          DateTime(
                  DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .subtract(Duration(days: i)),
          runningTimePerDay[i],
          ThemeColors.blueGreenis));
      cyclingActivitiesTime.add(ActivitiesDataDateTime(
          DateTime(
                  DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .subtract(Duration(days: i)),
          cyclingTimePerDay[i],
          ThemeColors.orange));
      climbingActivitiesTime.add(ActivitiesDataDateTime(
          DateTime(
                  DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .subtract(Duration(days: i)),
          climbingTimePerDay[i],
          ThemeColors.yellowGreenish));
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

    return series;
  }

  /// Method to get series containing only activities from the past week
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

        /// Check if the activity happened on the given date
        if (dateTime.compareTo(DateTime(DateTime.now().year,
            DateTime.now().month, DateTime.now().day)
            .subtract(Duration(days: 7*i))) <=
            0 && dateTime.compareTo(DateTime(DateTime.now().year,
            DateTime.now().month, DateTime.now().day)
            .subtract(Duration(days: 7*(i+1)))) >=
            0) {
          List stringDurationSplitted = activity.duration.split(":");
          double durationInMin =
              int.parse(stringDurationSplitted[0]).toDouble() +
                  int.parse(stringDurationSplitted[1]) / 60;

          switch (activity.activityType) {
            case "Running":
              runningTimePerWeek[i] += durationInMin;
              break;
            case "Cycling":
              cyclingTimePerWeek[i] += durationInMin;
              break;
            case "Climbing":
              climbingTimePerWeek[i] += durationInMin;
          }
        }
      }
    }

    for (int i = 0; i < 11; i++) {
      runningActivitiesTime.add(ActivitiesDataDateTime(
          DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .subtract(Duration(days: 7*i)),
          runningTimePerWeek[i],
          ThemeColors.lightBlue));
      cyclingActivitiesTime.add(ActivitiesDataDateTime(
          DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .subtract(Duration(days: 7*i)),
          cyclingTimePerWeek[i],
          ThemeColors.orange));
      climbingActivitiesTime.add(ActivitiesDataDateTime(
          DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .subtract(Duration(days: 7*i)),
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

  /// Method to get series containing only activities from the past week
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

        /// Check if the activity happened on the given date
        if (dateTime.compareTo(DateTime(DateTime.now().year,
            DateTime.now().month, DateTime.now().day)
            .subtract(Duration(days: 7*i))) <=
            0 && dateTime.compareTo(DateTime(DateTime.now().year,
            DateTime.now().month, DateTime.now().day)
            .subtract(Duration(days: 7*(i+1)))) >=
            0) {
          int distanceKm = activity.distance;

          switch (activity.activityType) {
            case "Running":
              runningDistancePerWeek[i] += distanceKm;
              break;
            case "Cycling":
              cyclingDistancePerWeek[i] += distanceKm;
              break;
          }
        }
      }
    }

    for (int i = 0; i < 11; i++) {
      runningActivitiesDistance.add(ActivitiesDataDateTime(
          DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .subtract(Duration(days: 7*i)),
          runningDistancePerWeek[i],
          ThemeColors.lightBlue));
      cyclingActivitiesDistance.add(ActivitiesDataDateTime(
          DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .subtract(Duration(days: 7*i)),
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
      List<RecordedActivity> recAct, int noOfActivities, int type) {

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
        Colors.white));

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
