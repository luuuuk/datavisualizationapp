import 'package:data_visualization_app/models/recorded_activity.dart';
import 'package:data_visualization_app/screens/activity_list_screen.dart';
import 'package:data_visualization_app/screens/add_data_screen.dart';
import 'package:data_visualization_app/services/database_manager.dart';
import 'package:data_visualization_app/services/sorting_data.dart';
import 'package:data_visualization_app/theme.dart';
import 'package:data_visualization_app/widgets/border_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class HomeScreen extends StatefulWidget {
  static const routeName = '/';
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool hasData = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ThemeColors.darkBlue,
        child: Center(
          child: FutureBuilder<List<RecordedActivity>>(
              future: getActivityData(),
              builder:
                  (context, AsyncSnapshot<List<RecordedActivity>> snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    children: [
                      BorderContainerWidget(
                          _weeklyOverviewWidget(snapshot.data), "Last 7 Days"),
                      BorderContainerWidget(
                        _buildOverview(snapshot.data, 1),
                        "Monthly Activity Overview: " + _getCurrentMonthName(),
                      ),
                      BorderContainerWidget(
                        _build12WeeksActivityTimeChart(snapshot.data),
                        "Activity Time last 12 weeks",
                      ),
                      BorderContainerWidget(
                        _build12WeeksCyclingDistanceChart(snapshot.data),
                        "Cycling Distance last 12 weeks",
                      ),
                      BorderContainerWidget(
                          _buildAverageSpeedProgression(snapshot.data, 1),
                          "Average Speed Progression in Cycling"),
                      BorderContainerWidget(
                        _build12WeeksRunningDistanceChart(snapshot.data),
                        "Running Distance last 12 weeks",
                      ),
                      BorderContainerWidget(
                          _buildAverageSpeedProgression(snapshot.data, 0),
                          "Average Speed Progression in Running"),
                      BorderContainerWidget(
                        _buildOverview(snapshot.data, 2),
                        "Yearly Activity Overview",
                      ),
                      BorderContainerWidget(
                        _buildYearlyDurationChart(snapshot.data),
                        "Total Activity Time " + DateTime.now().year.toString(),
                      ),
                      BorderContainerWidget(
                        _buildYearlyDistanceChart(snapshot.data),
                        "Total Activity Distance " +
                            DateTime.now().year.toString(),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 64),
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: Text(
                      "You have not yet entered any data to be displayed. \nStart by using the button down here in the right corner.",
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
              }),
        ),
      ),
      floatingActionButton: _getFAB(),
    );
  }

  Widget _getFAB() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22, color: Colors.white),
      backgroundColor: ThemeColors.orange,
      visible: true,
      curve: Curves.bounceIn,
      children: [
        // FAB 1
        SpeedDialChild(
          child: Icon(
            Icons.list,
            color: Colors.white,
          ),
          backgroundColor: ThemeColors.orange,
          onTap: () {
            Navigator.pushNamed(context, ActivityListScreen.routeName);
          },
        ),
        // FAB 2
        SpeedDialChild(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: ThemeColors.orange,
          onTap: () {
            Navigator.pushNamed(context, AddDataScreen.routeName);
          },
        ),
      ],
    );
  }

  /// Method to get the data from the database
  Future<List<RecordedActivity>> getActivityData() async {
    DatabaseManager dbManager = new DatabaseManager();
    List<RecordedActivity> activities = await dbManager.getActivities();

    if (activities == null || activities.isEmpty) {
      setState(() {
        hasData = false;
      });
      return null;
    } else {
      setState(() {
        hasData = true;
      });
    }

    return activities;
  }

  /// Method to fill the rows of the table
  List<DataRow> getTableRows(List<RecordedActivity> activities) {
    List<DataRow> tableRows = new List<DataRow>();

    for (RecordedActivity recAct in activities) {
      tableRows.add(DataRow(
        cells: [
          DataCell(Text(
            recAct.activityType,
            style: GoogleFonts.montserrat(color: Colors.white),
          )),
          DataCell(Text(
            recAct.duration,
            style: GoogleFonts.montserrat(color: Colors.white),
          )),
          DataCell(Text(
            recAct.distance.toString(),
            style: GoogleFonts.montserrat(color: Colors.white),
          )),
        ],
      ));
    }

    return tableRows;
  }

  /// Method to build the BarChart containing the data for the distance of the given [activities]
  Widget _buildYearlyDistanceChart(List<RecordedActivity> activities) {
    return SizedBox(
      height: 100.0,
      child: new charts.BarChart(
        SortingDataService().getYearlyActivitiesDistance(activities),
        animate: false,
        vertical: false,
        domainAxis: charts.AxisSpec<String>(
          renderSpec: charts.GridlineRendererSpec(
            labelStyle: new charts.TextStyleSpec(
              fontSize: 10,
              color: charts.MaterialPalette.white,
            ),
          ),
        ),
        primaryMeasureAxis: charts.NumericAxisSpec(
          renderSpec: charts.GridlineRendererSpec(
            labelStyle: charts.TextStyleSpec(
                fontSize: 10, color: charts.MaterialPalette.white),
            lineStyle: charts.LineStyleSpec(
                thickness: 1, color: charts.MaterialPalette.white),
          ),
        ),
      ),
    );
  }

  /// Method to build the BarChart containing the data for the duration of the given [activities]
  Widget _buildYearlyDurationChart(List<RecordedActivity> activities) {
    return Column(
      children: [
        SizedBox(
          height: 200.0,
          child: new charts.PieChart(
            SortingDataService().getYearlyActivitiesTime(activities),
            animate: false,
            defaultRenderer: new charts.ArcRendererConfig(
                arcWidth: 45,
                arcRendererDecorators: [
                  new charts.ArcLabelDecorator(
                    labelPosition: charts.ArcLabelPosition.outside,
                    outsideLabelStyleSpec: charts.TextStyleSpec(
                        color: charts.Color.white, fontSize: 12),
                  )
                ]),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              Icons.directions_run,
              color: ThemeColors.lightBlue,
            ),
            Icon(
              Icons.directions_bike,
              color: ThemeColors.orange,
            ),
            Icon(
              Icons.filter_hdr,
              color: ThemeColors.yellowGreenish,
            ),
          ],
        ),
      ],
    );
  }

  TableRow _buildTableRow(String listOfNames) {
    return TableRow(
      children: listOfNames.split(',').map((name) {
        return Container(
          alignment: Alignment.center,
          child: Text(name, style: GoogleFonts.montserrat(color: Colors.white)),
          padding: EdgeInsets.all(8.0),
        );
      }).toList(),
    );
  }

  /// Method to assemble the weekly overview
  Widget _weeklyOverviewWidget(List<RecordedActivity> activities) {
    return Column(
      children: <Widget>[
        _buildOverview(activities, 0),
        Container(
          padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
        ),
        Text(
          "Activity Time in h",
          style: GoogleFonts.montserrat(color: Colors.white),
        ),
        _buildWeeklyActivityChart(activities),
      ],
    );
  }

  /// Method to build a weekly overview table containing only activity data
  /// overviewCode 0: weekly, 1: monthly, 2: yearly
  Widget _buildOverview(List<RecordedActivity> activities, int overviewCode) {
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

  _build12WeeksActivityTimeChart(List<RecordedActivity> activities) {
    List<charts.Series<ActivitiesDataDateTime, DateTime>> data =
        SortingDataService().getActivityTimePast12Weeks(activities);

    return _buildLineGraphWithAreaAndPoints(data, 200);
  }

  _build12WeeksCyclingDistanceChart(List<RecordedActivity> activities) {
    List<charts.Series<ActivitiesDataDateTime, DateTime>> data =
        SortingDataService().getActivityDistancePast12Weeks(activities);

    data.removeAt(0);

    return _buildLineGraphWithAreaAndPoints(data, 200);
  }

  _build12WeeksRunningDistanceChart(List<RecordedActivity> activities) {
    List<charts.Series<ActivitiesDataDateTime, DateTime>> data =
        SortingDataService().getActivityDistancePast12Weeks(activities);

    data.removeAt(1);

    return _buildLineGraphWithAreaAndPoints(data, 200);
  }

  Widget _buildWeeklyActivityChart(List<RecordedActivity> activities) {
    List<charts.Series<ActivitiesDataDateTime, DateTime>> data =
        SortingDataService().getWeeklyActivity(activities);

    return _buildLineGraphWithAreaAndPoints(data, 140);
  }

  _buildLineGraphWithAreaAndPoints(
      List<charts.Series<ActivitiesDataDateTime, DateTime>> data,
      double height) {
    if (data.isNotEmpty) {
      return SizedBox(
        height: height,
        child: new charts.TimeSeriesChart(
          data,
          animate: false,
          defaultRenderer: new charts.LineRendererConfig(
            includePoints: true,
            includeArea: true,
          ),
          domainAxis: new charts.DateTimeAxisSpec(
              renderSpec: charts.GridlineRendererSpec(
                  axisLineStyle: charts.LineStyleSpec(
                    color: charts.MaterialPalette
                        .white, // this also doesn't change the Y axis labels
                  ),
                  labelStyle: new charts.TextStyleSpec(
                    fontSize: 10,
                    color: charts.MaterialPalette.white,
                  ),
                  lineStyle: charts.LineStyleSpec(
                    thickness: 0,
                    color: charts.MaterialPalette.white,
                  )),
              tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
                  hour: new charts.TimeFormatterSpec(
                format: 'H',
                transitionFormat: 'H',
              ))),
          primaryMeasureAxis: charts.NumericAxisSpec(
              renderSpec: charts.GridlineRendererSpec(
                  labelStyle: charts.TextStyleSpec(
                      fontSize: 10, color: charts.MaterialPalette.white),
                  lineStyle: charts.LineStyleSpec(
                      thickness: 1, color: charts.MaterialPalette.white))),
          behaviors: [
            new charts.SeriesLegend(
              // Positions for "start" and "end" will be left and right respectively
              // for widgets with a build context that has directionality ltr.
              // For rtl, "start" and "end" will be right and left respectively.
              // Since this example has directionality of ltr, the legend is
              // positioned on the right side of the chart.
              position: charts.BehaviorPosition.bottom,
              // For a legend that is positioned on the left or right of the chart,
              // setting the justification for [endDrawArea] is aligned to the
              // bottom of the chart draw area.
              outsideJustification: charts.OutsideJustification.middleDrawArea,
              // By default, if the position of the chart is on the left or right of
              // the chart, [horizontalFirst] is set to false. This means that the
              // legend entries will grow as new rows first instead of a new column.
              horizontalFirst: true,
              // By setting this value to 2, the legend entries will grow up to two
              // rows before adding a new column.
              desiredMaxRows: 2,
              // This defines the padding around each legend entry.
              cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
              // Render the legend entry text with custom styles.
              entryTextStyle: charts.TextStyleSpec(
                color: charts.Color.white,
                fontFamily: 'Montserrat',
                fontSize: 10,
              ),
            )
          ],
        ),
      );
    } else {
      return Center(
        child: Text(
          "There seems to be no training data this week...\nTime to start training!",
          style: GoogleFonts.montserrat(color: Colors.white),
        ),
      );
    }
  }

  _buildAverageSpeedProgression(List<RecordedActivity> activities, int type) {
    var data = SortingDataService().getAverageSpeedData(activities, 8, type);

    if (data.isNotEmpty) {
      return SizedBox(
        height: 200.0,
        child: charts.BarChart(
          data,
          animate: false,
          domainAxis: charts.AxisSpec<String>(
            renderSpec: charts.GridlineRendererSpec(
              labelStyle: new charts.TextStyleSpec(
                fontSize: 10,
                color: charts.MaterialPalette.white,
              ),
            ),
          ),
          primaryMeasureAxis: charts.NumericAxisSpec(
            renderSpec: charts.GridlineRendererSpec(
              labelStyle: charts.TextStyleSpec(
                  fontSize: 10, color: charts.MaterialPalette.white),
              lineStyle: charts.LineStyleSpec(
                  thickness: 1, color: charts.MaterialPalette.white),
            ),
          ),
          customSeriesRenderers: [
            new charts.BarTargetLineRendererConfig<String>(
                // ID used to link series to this renderer.
                customRendererId: 'customTargetLine',
                groupingType: charts.BarGroupingType.stacked)
          ],
        ),
      );
    } else {
      return Container(
        child: Text(
          "No activities yet.",
          style: GoogleFonts.montserrat(color: Colors.white),
        ),
      );
    }
  }

  /// Method to return the name of the current month
  String _getCurrentMonthName() {
    switch (DateTime.now().month) {
      case DateTime.january:
        return "January";
      case DateTime.february:
        return "February";
      case DateTime.march:
        return "March";
      case DateTime.april:
        return "April";
      case DateTime.may:
        return "May";
      case DateTime.june:
        return "June";
      case DateTime.july:
        return "July";
      case DateTime.august:
        return "August";
      case DateTime.september:
        return "September";
      case DateTime.october:
        return "October";
      case DateTime.november:
        return "November";
      case DateTime.december:
        return "December";
      default:
        return "Current Month";
    }
  }
}
