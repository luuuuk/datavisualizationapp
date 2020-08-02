import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:ui';

import 'package:data_visualization_app/models/recorded_activity.dart';
import 'package:data_visualization_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SortingDataService {
  /// Method to get series only containing the total activity distance
  List<charts.Series<ActivitiesData, String>> getTotalActivitiesDistance(
      List<RecordedActivity> recAct) {
    int runningDistance = 0;
    int cyclingDistance = 0;

    for (RecordedActivity activity in recAct) {
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

    var data = [
      new ActivitiesData('Running', runningDistance, ThemeColors.blueGreenis),
      new ActivitiesData('Cycling', cyclingDistance, ThemeColors.orange),
      new ActivitiesData('Combined', runningDistance, ThemeColors.blueGreenis),
      new ActivitiesData('Combined', cyclingDistance, ThemeColors.orange),
    ];

    var series = [
      new charts.Series(
        id: 'Total Activity Distance',
        domainFn: (ActivitiesData clickData, _) => clickData.naming,
        measureFn: (ActivitiesData clickData, _) => clickData.number,
        colorFn: (ActivitiesData clickData, _) => clickData.color,
        data: data,
      ),
    ];

    return series;
  }

  /// Method to get series containing only activities from the past week
  List<charts.Series<ActivitiesDataDateTime, DateTime>> getWeeklyActivity(
      List<RecordedActivity> recAct) {
    List<charts.Series<ActivitiesDataDateTime, DateTime>> series = new List<charts.Series<ActivitiesDataDateTime, DateTime>>();
    List<ActivitiesDataDateTime> runningActivitiesTime = new List<ActivitiesDataDateTime>();
    List<ActivitiesDataDateTime> cyclingActivitiesTime = new List<ActivitiesDataDateTime>();
    List<ActivitiesDataDateTime> climbingActivitiesTime = new List<ActivitiesDataDateTime>();

    /// Get activities not older than a week
    for (RecordedActivity activity in recAct) {
      List stringDateSplitted = activity.date.split(".");
      DateTime dateTime = DateTime(
          int.parse(stringDateSplitted[2]), int.parse(stringDateSplitted[1]), int.parse(stringDateSplitted[0]));

      /// If older than a week, do not include
      if (dateTime.compareTo(DateTime.now().subtract(Duration(days: 7))) > 0) {

        List stringDurationSplitted = activity.duration.split(":");
        double durationInMin =
            int.parse(stringDurationSplitted[0]).toDouble() +
                int.parse(stringDurationSplitted[1]) / 60;

        switch (activity.activityType) {
          case "Running":
            runningActivitiesTime
                .add(ActivitiesDataDateTime(dateTime, durationInMin, ThemeColors.blueGreenis));
            break;
          case "Cycling":
            cyclingActivitiesTime
                .add(ActivitiesDataDateTime(dateTime, durationInMin, ThemeColors.orange));
            break;
          case "Climbing":
            climbingActivitiesTime
                .add(ActivitiesDataDateTime(dateTime, durationInMin, ThemeColors.yellowGreenish));
        }
      }
    }

    /// Add first and last day of the week for data series to be in that range
    for(int i = 0; i < 8; i++){
      runningActivitiesTime.add(ActivitiesDataDateTime(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day).subtract(Duration(days: i)), 0, ThemeColors.blueGreenis));
      cyclingActivitiesTime.add(ActivitiesDataDateTime(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day).subtract(Duration(days: i)), 0, ThemeColors.orange));
      climbingActivitiesTime.add(ActivitiesDataDateTime(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day).subtract(Duration(days: i)), 0, ThemeColors.yellowGreenish));
    }

    if (runningActivitiesTime.isNotEmpty) {
      series.add(charts.Series<ActivitiesDataDateTime, DateTime>(
        id: 'Running',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (ActivitiesDataDateTime sales, _) => sales.dateTime,
        measureFn: (ActivitiesDataDateTime sales, _) => sales.number,
        data: runningActivitiesTime,
      )..setAttribute(charts.rendererIdKey, 'customPoint'),);
    }
    if (cyclingActivitiesTime.isNotEmpty) {
      series.add(charts.Series<ActivitiesDataDateTime, DateTime>(
        id: 'Cycling',
        colorFn: (ActivitiesDataDateTime sales, __) => sales.color,
        domainFn: (ActivitiesDataDateTime sales, _) => sales.dateTime,
        measureFn: (ActivitiesDataDateTime sales, _) => sales.number,
        data: cyclingActivitiesTime,
      )..setAttribute(charts.rendererIdKey, 'customPoint'),);
    }
    if (climbingActivitiesTime.isNotEmpty) {
      series.add(charts.Series<ActivitiesDataDateTime, DateTime>(
        id: 'Climbing',
        colorFn: (ActivitiesDataDateTime sales, __) => sales.color,
        domainFn: (ActivitiesDataDateTime sales, _) => sales.dateTime,
        measureFn: (ActivitiesDataDateTime sales, _) => sales.number,
        data: climbingActivitiesTime,
      )..setAttribute(charts.rendererIdKey, 'customPoint'),);
    }

    return series;
  }

  /// Method to get series containing cumulated weekly activities for the last month

  /// Method to get series containing cumulated monthly activities for the last year

  /// Method to get series containing cumulated yearly activities for the last two years

  /// Method to get the average cycling speed over the last 10 weeks

  /// Method to get the average running speed over the last 10 weeks

  /// Method to get the average cycling speed over the last 10 months

  /// Method to get the average running speed over the last 10 months


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
