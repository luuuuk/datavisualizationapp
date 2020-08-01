import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:ui';

import 'package:data_visualization_app/models/recorded_activity.dart';
import 'package:data_visualization_app/theme.dart';
import 'package:flutter/material.dart';

class SortingDataService{

  List<charts.Series<ActivitiesData, String>> getTotalActivitiesDistance(List<RecordedActivity> recAct){

    int runningDistance = 0;
    int cyclingDistance = 0;

    for(RecordedActivity activity in recAct){
      switch(activity.activityType){
        case "Running": runningDistance += activity.distance;
        break;
        case "Cycling": cyclingDistance += activity.distance;
        break;
        case "Climbing": break;
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
}

class ActivitiesData{
  final String naming;
  final int number;
  final charts.Color color;

  ActivitiesData(this.naming, this.number, Color color)
      : this.color = new charts.Color(
      r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
