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
      List<RecordedActivity> recAct, int yearsAgo) {
    int runningDistance = 0;
    int cyclingDistance = 0;
    int hikingDistance = 0;

    for (RecordedActivity activity in recAct) {
      List splittedDate = activity.date.split(".");

      if (int.parse(splittedDate[2]) == (DateTime.now().year - yearsAgo)) {
        switch (activity.activityType) {
          case ActivityInfo.activity1Name:
            runningDistance += activity.distance;
            break;
          case ActivityInfo.activity2Name:
            cyclingDistance += activity.distance;
            break;
          case ActivityInfo.activity4Name:
            hikingDistance += activity.distance;
            break;
          case ActivityInfo.activity3Name:
            break;
        }
      }
    }

    var data = [
      new ActivitiesData(
          ActivityInfo.activity1Name, runningDistance, ThemeColors.lightBlue),
      new ActivitiesData(
          ActivityInfo.activity2Name, cyclingDistance, ThemeColors.orange),
      new ActivitiesData(ActivityInfo.activity4Name, hikingDistance,
          ThemeColors.blueGreenisShade1),
    ];

    var series = [
      new charts.Series(
        id: 'Total Activity Distance',
        domainFn: (ActivitiesData clickData, _) => clickData.naming,
        measureFn: (ActivitiesData clickData, _) => clickData.number,
        colorFn: (ActivitiesData clickData, _) => clickData.color,
        data: data,
        labelAccessorFn: (ActivitiesData clickData, _) =>
            clickData.number.toString() + " km",
      ),
    ];

    return series;
  }

  /// Method to get series only containing the total activity distance
  List<charts.Series<ActivitiesData, String>> getYearlyActivitiesTime(
      List<RecordedActivity> recAct, int yearsAgo) {
    int runningTime = 0;
    int cyclingTime = 0;
    int climbingTime = 0;
    int hikingTime = 0;

    for (RecordedActivity activity in recAct) {
      List splittedDate = activity.date.split(".");

      if (int.parse(splittedDate[2]) == (DateTime.now().year - yearsAgo)) {
        List stringDurationSplitted = activity.duration.split(":");
        int durationInMin = int.parse(stringDurationSplitted[0]) * 60 +
            int.parse(stringDurationSplitted[1]);

        switch (activity.activityType) {
          case ActivityInfo.activity1Name:
            runningTime += durationInMin;
            break;
          case ActivityInfo.activity2Name:
            cyclingTime += durationInMin;
            break;
          case ActivityInfo.activity3Name:
            climbingTime += durationInMin;
            break;
          case ActivityInfo.activity4Name:
            hikingTime += durationInMin;
            break;
        }
      }
    }

    var data = [
      new ActivitiesData(
          ActivityInfo.activity1Name, runningTime, ThemeColors.lightBlue),
      new ActivitiesData(
          ActivityInfo.activity2Name, cyclingTime, ThemeColors.orange),
      new ActivitiesData(
          ActivityInfo.activity3Name, climbingTime, ThemeColors.yellowGreenish),
      new ActivitiesData(ActivityInfo.activity4Name, hikingTime,
          ThemeColors.blueGreenisShade1),
    ];

    var series = [
      new charts.Series(
        id: 'Total Activity Distance',
        domainFn: (ActivitiesData clickData, _) => clickData.naming,
        measureFn: (ActivitiesData clickData, _) => clickData.number,
        colorFn: (ActivitiesData clickData, _) => clickData.color,
        data: data,
        labelAccessorFn: (ActivitiesData clickData, _) =>
            (clickData.number ~/ 60).toString() +
            " h : " +
            (clickData.number - (clickData.number ~/ 60) * 60).toString() +
            " m",
      ),
    ];

    return series;
  }

  /// Method to get series containing only activities from the past week
  List<charts.Series<ActivitiesDataDateTime, DateTime>> getWeeklyActivity(
      List<RecordedActivity> recAct, int weeksAgo) {
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
    int compareLimit;
    weeksAgo == 0 ? compareLimit = DateTime.now().weekday : compareLimit = 6;
    for (int i = 0; i < compareLimit; i++) {
      /// Check if activities match the date
      for (RecordedActivity activity in recAct) {
        List stringDateSplitted = activity.date.split(".");
        DateTime dateTime = DateTime(int.parse(stringDateSplitted[2]),
            int.parse(stringDateSplitted[1]), int.parse(stringDateSplitted[0]));

        /// Check if the activity happened on the given date
        if (dateTime.compareTo((DateTime(DateTime.now().year,
                    DateTime.now().month, DateTime.now().day))
                .subtract(Duration(days: ((7*weeksAgo)-1)))
                .subtract(Duration(days: i))) ==
            0) {
          List stringDurationSplitted = activity.duration.split(":");
          double durationInMin =
              int.parse(stringDurationSplitted[0]).toDouble() +
                  int.parse(stringDurationSplitted[1]) / 60;

          switch (activity.activityType) {
            case ActivityInfo.activity1Name:
              runningTimePerDay[i] += durationInMin;
              break;
            case ActivityInfo.activity2Name:
              cyclingTimePerDay[i] += durationInMin;
              break;
            case ActivityInfo.activity3Name:
              climbingTimePerDay[i] += durationInMin;
              break;
            case ActivityInfo.activity4Name:
              hikingTimePerDay[i] += durationInMin;
              break;
          }
        }
      }
    }

    for (int i = 0; i < compareLimit; i++) {
      runningActivitiesTime.insert(
          0,
          ActivitiesDataDateTime(
              (DateTime(DateTime.now().year,
                  DateTime.now().month, DateTime.now().day))
                  .subtract(Duration(days: (7*weeksAgo -1)))
                  .subtract(Duration(days: i)),
              runningTimePerDay[i],
              ThemeColors.darkBlue));
      cyclingActivitiesTime.insert(
          0,
          ActivitiesDataDateTime(
              (DateTime(DateTime.now().year,
                  DateTime.now().month, DateTime.now().day))
                  .subtract(Duration(days: (7*weeksAgo -1)))
                  .subtract(Duration(days: i)),
              cyclingTimePerDay[i],
              ThemeColors.orange));
      climbingActivitiesTime.insert(
          0,
          ActivitiesDataDateTime(
              (DateTime(DateTime.now().year,
                  DateTime.now().month, DateTime.now().day))
                  .subtract(Duration(days: (7*weeksAgo -1)))
                  .subtract(Duration(days: i)),
              climbingTimePerDay[i],
              ThemeColors.cream));
      hikingActivitiesTime.insert(
          0,
          ActivitiesDataDateTime(
              (DateTime(DateTime.now().year,
                  DateTime.now().month, DateTime.now().day))
                  .subtract(Duration(days: (7*weeksAgo -1)))
                  .subtract(Duration(days: i)),
              hikingTimePerDay[i],
              ThemeColors.blueGreenisShade1));
    }

    /// Fill in the rest of the week until day 7 (sunday)
    int daysToAdd = 0;

    if(weeksAgo == 0){
      while (runningActivitiesTime.length != 7 &&
          cyclingActivitiesTime.length != 7 &&
          climbingActivitiesTime.length != 7 &&
          hikingActivitiesTime.length != 7) {
        runningActivitiesTime.add(ActivitiesDataDateTime(
            DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day)
                .add(Duration(days: daysToAdd + 1)),
            runningTimePerDay[DateTime.now().weekday + daysToAdd],
            ThemeColors.darkBlue));
        cyclingActivitiesTime.add(ActivitiesDataDateTime(
            DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day)
                .add(Duration(days: daysToAdd + 1)),
            cyclingTimePerDay[DateTime.now().weekday + daysToAdd],
            ThemeColors.orange));
        climbingActivitiesTime.add(ActivitiesDataDateTime(
            DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day)
                .add(Duration(days: daysToAdd + 1)),
            climbingTimePerDay[DateTime.now().weekday + daysToAdd],
            ThemeColors.cream));
        hikingActivitiesTime.add(ActivitiesDataDateTime(
            DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day)
                .add(Duration(days: daysToAdd + 1)),
            hikingTimePerDay[DateTime.now().weekday + daysToAdd],
            ThemeColors.blueGreenisShade1));

        daysToAdd++;
      }
    }

    if (runningActivitiesTime.isNotEmpty) {
      series.add(charts.Series<ActivitiesDataDateTime, DateTime>(
        id: ActivityInfo.activity1Name,
        colorFn: (ActivitiesDataDateTime sales, __) => sales.color,
        domainFn: (ActivitiesDataDateTime sales, _) => sales.dateTime,
        measureFn: (ActivitiesDataDateTime sales, _) => sales.number,
        data: runningActivitiesTime,
      ));
    }
    if (cyclingActivitiesTime.isNotEmpty) {
      series.add(
        charts.Series<ActivitiesDataDateTime, DateTime>(
          id: ActivityInfo.activity2Name,
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
          id: ActivityInfo.activity3Name,
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
          id: ActivityInfo.activity4Name,
          colorFn: (ActivitiesDataDateTime sales, __) => sales.color,
          domainFn: (ActivitiesDataDateTime sales, _) => sales.dateTime,
          measureFn: (ActivitiesDataDateTime sales, _) => sales.number,
          data: hikingActivitiesTime,
        ),
      );
    }

    return series;
  }

  /// Method to get series containing only activities from the current month
  List<charts.Series<ActivitiesDataDateTime, DateTime>> getMonthlyActivity(
      List<RecordedActivity> recAct, int monthsAgo) {
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

    List<double> runningTimePerDay = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    List<double> cyclingTimePerDay = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    List<double> climbingTimePerDay = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    List<double> hikingTimePerDay = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

    /// Go through all activities from today-day-1 to today
    /// (weekday starts at 1

    int loopEnd;
    int yearsAgo = 0;
    if(monthsAgo == 0){
      loopEnd = DateTime.now().day;
    } else {
      if(monthsAgo > 11){
        yearsAgo = monthsAgo%12;
        monthsAgo -= 12*yearsAgo;
        print("yearsAgo: " + yearsAgo.toString());
      }
      loopEnd = DateTime(DateTime.now().year - yearsAgo, (DateTime.now().month - (monthsAgo-1)), 0).day;
      print("Calculated loop end :" + loopEnd.toString());
    }

    for (int i = 0; i < loopEnd; i++) {
      /// Check if activities match the date
      for (RecordedActivity activity in recAct) {
        List stringDateSplitted = activity.date.split(".");
        DateTime dateTime = DateTime(int.parse(stringDateSplitted[2]),
            int.parse(stringDateSplitted[1]), int.parse(stringDateSplitted[0]));

        DateTime compareDate;

        if(monthsAgo == 0 && yearsAgo == 0){
          compareDate = DateTime(DateTime.now().year,
              DateTime.now().month, DateTime.now().day)
              .subtract(Duration(days: i));
        } else {
          print("Detected monthsInPast > 0, mothsInPast :" + monthsAgo.toString());
          compareDate = DateTime(DateTime.now().year - yearsAgo,
              DateTime.now().month - (monthsAgo-1), 0)
              .subtract(Duration(days: i));
          print("compareDate: " + compareDate.toString());
        }

        /// Check if the activity happened on the given date
        if (dateTime.compareTo(compareDate) ==
            0) {
          List stringDurationSplitted = activity.duration.split(":");
          double durationInMin =
              int.parse(stringDurationSplitted[0]).toDouble() +
                  int.parse(stringDurationSplitted[1]) / 60;

          switch (activity.activityType) {
            case ActivityInfo.activity1Name:
              runningTimePerDay[i] += durationInMin;
              break;
            case ActivityInfo.activity2Name:
              cyclingTimePerDay[i] += durationInMin;
              break;
            case ActivityInfo.activity3Name:
              climbingTimePerDay[i] += durationInMin;
              break;
            case ActivityInfo.activity4Name:
              hikingTimePerDay[i] += durationInMin;
              break;
          }
        }
      }
    }

    for (int i = 0; i < loopEnd; i++) {

      DateTime compareDate;
      if(monthsAgo == 0){
        compareDate = DateTime(DateTime.now().year,
            DateTime.now().month, DateTime.now().day)
            .subtract(Duration(days: i));
      } else {
        compareDate = DateTime(DateTime.now().year - yearsAgo,
            DateTime.now().month - (monthsAgo-1), 0)
            .subtract(Duration(days: i));
      }

      runningActivitiesTime.insert(
          0,
          ActivitiesDataDateTime(
              compareDate,
              runningTimePerDay[i],
              ThemeColors.darkBlue));
      cyclingActivitiesTime.insert(
          0,
          ActivitiesDataDateTime(
              compareDate,
              cyclingTimePerDay[i],
              ThemeColors.orange));
      climbingActivitiesTime.insert(
          0,
          ActivitiesDataDateTime(
              compareDate,
              climbingTimePerDay[i],
              ThemeColors.cream));
      hikingActivitiesTime.insert(
          0,
          ActivitiesDataDateTime(
              compareDate,
              hikingTimePerDay[i],
              ThemeColors.blueGreenisShade1));
    }

    /// Fill in the rest of the month until day 31
    int daysToAdd = 0;

    if(monthsAgo == 0 && yearsAgo == 0){
      while (runningActivitiesTime.length != 31 &&
          cyclingActivitiesTime.length != 31 &&
          climbingActivitiesTime.length != 31 &&
          hikingActivitiesTime.length != 31) {
        runningActivitiesTime.add(ActivitiesDataDateTime(
            DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day)
                .add(Duration(days: daysToAdd + 1)),
            runningTimePerDay[DateTime.now().day + daysToAdd],
            ThemeColors.darkBlue));
        cyclingActivitiesTime.add(ActivitiesDataDateTime(
            DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day)
                .add(Duration(days: daysToAdd + 1)),
            cyclingTimePerDay[DateTime.now().day + daysToAdd],
            ThemeColors.orange));
        climbingActivitiesTime.add(ActivitiesDataDateTime(
            DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day)
                .add(Duration(days: daysToAdd + 1)),
            climbingTimePerDay[DateTime.now().day + daysToAdd],
            ThemeColors.cream));
        hikingActivitiesTime.add(ActivitiesDataDateTime(
            DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day)
                .add(Duration(days: daysToAdd + 1)),
            hikingTimePerDay[DateTime.now().day + daysToAdd],
            ThemeColors.blueGreenisShade1));

        daysToAdd++;
      }
    }

    if (runningActivitiesTime.isNotEmpty) {
      series.add(charts.Series<ActivitiesDataDateTime, DateTime>(
        id: ActivityInfo.activity1Name,
        colorFn: (ActivitiesDataDateTime sales, __) => sales.color,
        domainFn: (ActivitiesDataDateTime sales, _) => sales.dateTime,
        measureFn: (ActivitiesDataDateTime sales, _) => sales.number,
        data: runningActivitiesTime,
      ));
    }
    if (cyclingActivitiesTime.isNotEmpty) {
      series.add(
        charts.Series<ActivitiesDataDateTime, DateTime>(
          id: ActivityInfo.activity2Name,
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
          id: ActivityInfo.activity3Name,
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
          id: ActivityInfo.activity4Name,
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
  List<charts.Series<ActivitiesDataDateTime, DateTime>>
      getActivityTimePast12Weeks(List<RecordedActivity> recAct) {
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

    List<double> runningTimePerWeek = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    List<double> cyclingTimePerWeek = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    List<double> climbingTimePerWeek = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    List<double> hikingTimePerWeek = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

    /// Go through all activties from weeks T-11 to now()
    for (int i = 0; i < 11; i++) {
      /// Check if activities match the date
      for (RecordedActivity activity in recAct) {
        List stringDateSplitted = activity.date.split(".");
        DateTime dateTime = DateTime(int.parse(stringDateSplitted[2]),
            int.parse(stringDateSplitted[1]), int.parse(stringDateSplitted[0]));

        /// Check if activity happened this week
        if (i < DateTime.now().weekday &&
            dateTime.compareTo(DateTime(DateTime.now().year,
                        DateTime.now().month, DateTime.now().day)
                    .subtract(Duration(days: i))) ==
                0) {
          /// Add duration to current week
          List stringDurationSplitted = activity.duration.split(":");
          double durationInMin =
              int.parse(stringDurationSplitted[0]).toDouble() +
                  int.parse(stringDurationSplitted[1]) / 60;

          switch (activity.activityType) {
            case ActivityInfo.activity1Name:
              runningTimePerWeek[0] += durationInMin;
              break;
            case ActivityInfo.activity2Name:
              cyclingTimePerWeek[0] += durationInMin;
              break;
            case ActivityInfo.activity3Name:
              climbingTimePerWeek[0] += durationInMin;
              break;
            case ActivityInfo.activity4Name:
              hikingTimePerWeek[0] += durationInMin;
          }
        }

        /// Check if the activity happened on the given date
        if (dateTime.compareTo(DateTime(DateTime.now().year,
                        DateTime.now().month, DateTime.now().day)
                    .subtract(
                        Duration(days: 7 * i + DateTime.now().weekday))) <=
                0 &&
            dateTime.compareTo(DateTime(DateTime.now().year,
                        DateTime.now().month, DateTime.now().day)
                    .subtract(Duration(
                        days: 7 * (i + 1) + DateTime.now().weekday))) >=
                0) {
          List stringDurationSplitted = activity.duration.split(":");
          double durationInMin =
              int.parse(stringDurationSplitted[0]).toDouble() +
                  int.parse(stringDurationSplitted[1]) / 60;

          switch (activity.activityType) {
            case ActivityInfo.activity1Name:
              runningTimePerWeek[i + 1] += durationInMin;
              break;
            case ActivityInfo.activity2Name:
              cyclingTimePerWeek[i + 1] += durationInMin;
              break;
            case ActivityInfo.activity3Name:
              climbingTimePerWeek[i + 1] += durationInMin;
              break;
            case ActivityInfo.activity4Name:
              hikingTimePerWeek[i + 1] += durationInMin;
          }
        }
      }
    }

    for (int i = 0; i < 12; i++) {
      runningActivitiesTime.add(ActivitiesDataDateTime(
          DateTime(
                  DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .subtract(Duration(days: 7 * i + DateTime.now().weekday)),
          runningTimePerWeek[i],
          ThemeColors.lightBlue));
      cyclingActivitiesTime.add(ActivitiesDataDateTime(
          DateTime(
                  DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .subtract(Duration(days: 7 * i + DateTime.now().weekday)),
          cyclingTimePerWeek[i],
          ThemeColors.orange));
      climbingActivitiesTime.add(ActivitiesDataDateTime(
          DateTime(
                  DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .subtract(Duration(days: 7 * i + DateTime.now().weekday)),
          climbingTimePerWeek[i],
          ThemeColors.yellowGreenish));
      hikingActivitiesTime.add(ActivitiesDataDateTime(
          DateTime(
                  DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .subtract(Duration(days: 7 * i + DateTime.now().weekday)),
          hikingTimePerWeek[i],
          ThemeColors.blueGreenisShade1));
    }

    if (runningActivitiesTime.isNotEmpty) {
      series.add(charts.Series<ActivitiesDataDateTime, DateTime>(
        id: ActivityInfo.activity1Name,
        colorFn: (ActivitiesDataDateTime sales, __) => sales.color,
        domainFn: (ActivitiesDataDateTime sales, _) => sales.dateTime,
        measureFn: (ActivitiesDataDateTime sales, _) => sales.number,
        data: runningActivitiesTime,
      ));
    }
    if (cyclingActivitiesTime.isNotEmpty) {
      series.add(
        charts.Series<ActivitiesDataDateTime, DateTime>(
          id: ActivityInfo.activity2Name,
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
          id: ActivityInfo.activity3Name,
          colorFn: (ActivitiesDataDateTime sales, __) => sales.color,
          domainFn: (ActivitiesDataDateTime sales, _) => sales.dateTime,
          measureFn: (ActivitiesDataDateTime sales, _) => sales.number,
          data: climbingActivitiesTime,
        ),
      );
    }
    if (hikingActivitiesTime.isNotEmpty) {
      series.add(charts.Series<ActivitiesDataDateTime, DateTime>(
        id: ActivityInfo.activity4Name,
        colorFn: (ActivitiesDataDateTime sales, __) => sales.color,
        domainFn: (ActivitiesDataDateTime sales, _) => sales.dateTime,
        measureFn: (ActivitiesDataDateTime sales, _) => sales.number,
        data: hikingActivitiesTime,
      ));
    }

    return series;
  }

  /// Method to get series containing only activity distances from the past 12 weeks
  List<charts.Series<ActivitiesDataDateTime, DateTime>>
      getActivityDistancePast12Weeks(List<RecordedActivity> recAct) {
    List<charts.Series<ActivitiesDataDateTime, DateTime>> series =
        new List<charts.Series<ActivitiesDataDateTime, DateTime>>();
    List<ActivitiesDataDateTime> runningActivitiesDistance =
        new List<ActivitiesDataDateTime>();
    List<ActivitiesDataDateTime> cyclingActivitiesDistance =
        new List<ActivitiesDataDateTime>();
    List<ActivitiesDataDateTime> hikingActivitiesDistance =
        new List<ActivitiesDataDateTime>();

    List<double> runningDistancePerWeek = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    List<double> cyclingDistancePerWeek = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    List<double> hikingDistancePerWeek = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

    /// Go through all activties from weeks T-11 to now()
    for (int i = 0; i < 11; i++) {
      /// Check if activities match the date
      for (RecordedActivity activity in recAct) {
        List stringDateSplitted = activity.date.split(".");
        DateTime dateTime = DateTime(int.parse(stringDateSplitted[2]),
            int.parse(stringDateSplitted[1]), int.parse(stringDateSplitted[0]));

        /// Check if activity happened this week
        if (i < DateTime.now().weekday &&
            dateTime.compareTo(DateTime(DateTime.now().year,
                        DateTime.now().month, DateTime.now().day)
                    .subtract(Duration(days: i))) ==
                0) {
          /// Add distance to current week
          int distanceKm = activity.distance;

          switch (activity.activityType) {
            case ActivityInfo.activity1Name:
              runningDistancePerWeek[0] += distanceKm;
              break;
            case ActivityInfo.activity2Name:
              cyclingDistancePerWeek[0] += distanceKm;
              break;
            case ActivityInfo.activity4Name:
              hikingDistancePerWeek[0] += distanceKm;
              break;
          }
        }

        /// Check if the activity happened on the given date
        if (dateTime.compareTo(DateTime(DateTime.now().year,
                        DateTime.now().month, DateTime.now().day)
                    .subtract(
                        Duration(days: 7 * i + DateTime.now().weekday))) <=
                0 &&
            dateTime.compareTo(DateTime(DateTime.now().year,
                        DateTime.now().month, DateTime.now().day)
                    .subtract(Duration(
                        days: 7 * (i + 1) + DateTime.now().weekday))) >=
                0) {
          int distanceKm = activity.distance;

          switch (activity.activityType) {
            case ActivityInfo.activity1Name:
              runningDistancePerWeek[i + 1] += distanceKm;
              break;
            case ActivityInfo.activity2Name:
              cyclingDistancePerWeek[i + 1] += distanceKm;
              break;
            case ActivityInfo.activity4Name:
              hikingDistancePerWeek[i + 1] += distanceKm;
              break;
          }
        }
      }
    }

    for (int i = 0; i < 12; i++) {
      runningActivitiesDistance.add(ActivitiesDataDateTime(
          DateTime(
                  DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .subtract(Duration(days: 7 * i + DateTime.now().weekday)),
          runningDistancePerWeek[i],
          ThemeColors.lightBlue));
      cyclingActivitiesDistance.add(ActivitiesDataDateTime(
          DateTime(
                  DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .subtract(Duration(days: 7 * i + DateTime.now().weekday)),
          cyclingDistancePerWeek[i],
          ThemeColors.orange));
      hikingActivitiesDistance.add(ActivitiesDataDateTime(
          DateTime(
                  DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .subtract(Duration(days: 7 * i + DateTime.now().weekday)),
          hikingDistancePerWeek[i],
          ThemeColors.blueGreenisShade1));
    }

    if (runningActivitiesDistance.isNotEmpty) {
      series.add(charts.Series<ActivitiesDataDateTime, DateTime>(
        id: ActivityInfo.activity1Name,
        colorFn: (ActivitiesDataDateTime sales, __) => sales.color,
        domainFn: (ActivitiesDataDateTime sales, _) => sales.dateTime,
        measureFn: (ActivitiesDataDateTime sales, _) => sales.number,
        data: runningActivitiesDistance,
      ));
    }
    if (cyclingActivitiesDistance.isNotEmpty) {
      series.add(
        charts.Series<ActivitiesDataDateTime, DateTime>(
          id: ActivityInfo.activity2Name,
          colorFn: (ActivitiesDataDateTime sales, __) => sales.color,
          domainFn: (ActivitiesDataDateTime sales, _) => sales.dateTime,
          measureFn: (ActivitiesDataDateTime sales, _) => sales.number,
          data: cyclingActivitiesDistance,
        ),
      );
    }
    if (hikingActivitiesDistance.isNotEmpty) {
      series.add(
        charts.Series<ActivitiesDataDateTime, DateTime>(
          id: ActivityInfo.activity4Name,
          colorFn: (ActivitiesDataDateTime sales, __) => sales.color,
          domainFn: (ActivitiesDataDateTime sales, _) => sales.dateTime,
          measureFn: (ActivitiesDataDateTime sales, _) => sales.number,
          data: hikingActivitiesDistance,
        ),
      );
    }

    return series;
  }

  /// Method to get series only containing the total activity distance
  /// type 0: Running, type 1: Cycling
  List<charts.Series<ActivitiesPrecisionNumData, int>> getAverageSpeedData(
      List<RecordedActivity> recAct,
      int noOfActivities,
      int type,
      bool inverseColors) {
    List<charts.Series<ActivitiesPrecisionNumData, int>> series =
        new List<charts.Series<ActivitiesPrecisionNumData, int>>();
    List<ActivitiesPrecisionNumData> averageSpeeds =
        new List<ActivitiesPrecisionNumData>();
    List<ActivitiesPrecisionNumData> lineData =
        new List<ActivitiesPrecisionNumData>();
    double totalAverage = 0;

    /// Sort activities
    recAct.sort((a, b) {
      List<String> splittedDateA = a.date.split(".");
      List<String> splittedDateB = b.date.split(".");
      DateTime dateA = DateTime(int.parse(splittedDateA[2]),
          int.parse(splittedDateA[1]), int.parse(splittedDateA[0]));
      DateTime dateB = DateTime(int.parse(splittedDateB[2]),
          int.parse(splittedDateB[1]), int.parse(splittedDateB[0]));
      return -dateA.compareTo(dateB);
    });

    int noOfIncludedActivities = 0;
    String lookingForType =
        type == 0 ? ActivityInfo.activity1Name : ActivityInfo.activity2Name;

    /// Iterate through all activities
    for (RecordedActivity activity in recAct) {
      /// Include only the wanted number of activities and the right activity type
      if (noOfIncludedActivities < noOfActivities &&
          activity.activityType == lookingForType) {
        List splittedDuration = activity.duration.split(":");
        List splittedDate = activity.date.split(".");

        double averageSpeed = activity.distance.toDouble() /
            (double.parse(splittedDuration[0]) +
                double.parse(splittedDuration[1]) / 60);

        averageSpeeds.insert(
            0,
            ActivitiesPrecisionNumData(noOfIncludedActivities, averageSpeed,
                type == 0 ? ThemeColors.lightBlue : ThemeColors.orange));

        noOfIncludedActivities++;
      }
    }

    if (averageSpeeds.isNotEmpty) {
      for (ActivitiesPrecisionNumData data in averageSpeeds) {
        totalAverage += data.number;
      }
      totalAverage /= averageSpeeds.length;

      /// Add data for trend line
      lineData.add(ActivitiesPrecisionNumData(0, totalAverage,
          type == 0 ? ThemeColors.lightBlue : ThemeColors.orange));

      lineData.add(ActivitiesPrecisionNumData(
          averageSpeeds.length,
          totalAverage,
          type == 0 ? ThemeColors.lightBlue : ThemeColors.orange));

      series.add(
        charts.Series<ActivitiesPrecisionNumData, int>(
          id: type == 0
              ? ActivityInfo.activity1Name
              : ActivityInfo.activity2Name,
          colorFn: (ActivitiesPrecisionNumData sales, __) => sales.color,
          domainFn: (ActivitiesPrecisionNumData sales, _) =>
              averageSpeeds.length - sales.id,
          measureFn: (ActivitiesPrecisionNumData sales, _) => sales.number,
          data: averageSpeeds,
        ),
      );
      series.add(
        charts.Series<ActivitiesPrecisionNumData, int>(
            id: 'Mobile',
            colorFn: (ActivitiesPrecisionNumData sales, __) => sales.color,
            domainFn: (ActivitiesPrecisionNumData sales, _) => sales.id,
            measureFn: (ActivitiesPrecisionNumData sales, _) => sales.number,
            data: lineData)
          ..setAttribute(charts.rendererIdKey, 'progressionLine'),
      );
    }

    return series;
  }

  List<List<int>> getOverviewData(
      List<RecordedActivity> activities, int overviewCode, int inThePast) {
    /// Hours, Minutes, Seconds, Distance
    List<int> cyclingTime = [0, 0, 0, 0];
    List<int> runningTime = [0, 0, 0, 0];
    List<int> climbingTime = [0, 0, 0, 0];
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
            if(inThePast == 0){
              expressionToEvaluate = (dateTime.compareTo(DateTime.now()
                  .subtract(Duration(days: DateTime.now().weekday))) >
                  0);
            } else {
              expressionToEvaluate = ((dateTime.compareTo((DateTime.now()
                  .subtract(Duration(days: 7 * inThePast)))
                  .subtract(Duration(days: DateTime.now().weekday)))) >
                  0 &&
                  (dateTime.compareTo((DateTime.now()
                      .subtract(Duration(days: 7 * (inThePast-1))))
                      .subtract(Duration(days: DateTime.now().weekday - 1)))) <
                      0);
            }
          }
          break;
        case 1:
          {
            if (DateTime.now().month - inThePast < 1) {
            } else {
              expressionToEvaluate =
                  (dateTime.month == (DateTime.now().month - inThePast));
            }
          }
          break;
        case 2:
          {
            expressionToEvaluate =
                (dateTime.year == (DateTime.now().year - inThePast));
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
          case ActivityInfo.activity1Name:
            {
              runningTime[0] += durationInHours;
              runningTime[1] += durationInMinutes;
              runningTime[2] += activity.distance;
              runningTime[3]++;
            }
            break;
          case ActivityInfo.activity2Name:
            {
              cyclingTime[0] += durationInHours;
              cyclingTime[1] += durationInMinutes;
              cyclingTime[2] += activity.distance;
              cyclingTime[3]++;
            }
            break;
          case ActivityInfo.activity3Name:
            {
              climbingTime[0] += durationInHours;
              climbingTime[1] += durationInMinutes;
              climbingTime[3]++;
            }
            break;
          case ActivityInfo.activity4Name:
            {
              hikingTime[0] += durationInHours;
              hikingTime[1] += durationInMinutes;
              hikingTime[2] += activity.distance;
              hikingTime[3]++;
            }
            break;
          default:
            {
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
        SortingDataService().getOverviewData(activities, goal.timeFrame, 0);

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
              (data[goal.activityType][0] + data[goal.activityType][1] / 60)
                  .toDouble();
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

class ActivitiesPrecisionNumData {
  final int id;
  final double number;
  final charts.Color color;

  ActivitiesPrecisionNumData(this.id, this.number, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
