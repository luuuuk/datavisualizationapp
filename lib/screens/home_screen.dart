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
                      BorderContainerWidget(_buildOverview(snapshot.data, 0),
                          "Weekly Activity Overview"),
                      BorderContainerWidget(
                          _buildWeeklyActivityChart(snapshot.data),
                          "Weekly Activity Time"),
                      BorderContainerWidget(
                        _buildOverview(snapshot.data, 1),
                        "Monthly Activity Overview" + _getCurrentMonthName(),
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
                        _build12WeeksRunningDistanceChart(snapshot.data),
                        "Running Distance last 12 weeks",
                      ),
                      BorderContainerWidget(
                        _buildOverview(snapshot.data, 2),
                        "Yearly Activity Overview",
                      ),
                      BorderContainerWidget(
                        _buildTotalDurationChart(snapshot.data),
                        "Total Activity Time",
                      ),
                      BorderContainerWidget(
                        _buildTotalDistanceChart(snapshot.data),
                        "Total Activity Distance",
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 24, 0, 0),
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
  Widget _buildTotalDistanceChart(List<RecordedActivity> activities) {
    return SizedBox(
      height: 200.0,
      child: new charts.PieChart(
        SortingDataService().getTotalActivitiesDistance(activities),
        animate: false,
        defaultRenderer: new charts.ArcRendererConfig(
            arcWidth: 60,
            arcRendererDecorators: [
              new charts.ArcLabelDecorator(
                  labelPosition: charts.ArcLabelPosition.inside)
            ]),
      ),
    );
  }

  /// Method to build the BarChart containing the data for the duration of the given [activities]
  Widget _buildTotalDurationChart(List<RecordedActivity> activities) {
    return SizedBox(
      height: 200.0,
      child: new charts.PieChart(
        SortingDataService().getTotalActivitiesTime(activities),
        animate: false,
        defaultRenderer: new charts.ArcRendererConfig(
            arcWidth: 60,
            arcRendererDecorators: [
              new charts.ArcLabelDecorator(
                  labelPosition: charts.ArcLabelPosition.inside)
            ]),
      ),
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

  /// Method to build a weekly overview table containing only activity data
  /// overviewCode 0: weekly, 1: monthly, 2: yearly
  Widget _buildOverview(List<RecordedActivity> activities, int overviewCode) {
    /// Hours, Minutes, Seconds, Distance
    List<int> cyclingTime = [0, 0, 0];
    List<int> runningTime = [0, 0, 0];
    List<int> climbingTime = [0, 0];
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
            }
            break;
          case "Cycling":
            {
              cyclingTime[0] += durationInHours;
              cyclingTime[1] += durationInMinutes;
              cyclingTime[2] += activity.distance;
            }
            break;
          case "Climbing":
            {
              climbingTime[0] += durationInHours;
              climbingTime[1] += durationInMinutes;
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

    return Table(
      border: TableBorder(
        horizontalInside: BorderSide(
          color: Colors.white,
          style: BorderStyle.solid,
          width: 1.0,
        ),
        verticalInside: BorderSide(
          color: Colors.white,
          style: BorderStyle.solid,
          width: 1.0,
        ),
      ),
      children: [
        _buildTableRow("Type, Duration, Distance"),
        _buildTableRow("Cycling , " +
            cyclingTime[0].toString() +
            " h : " +
            cyclingTime[1].toString() +
            " m," +
            cyclingTime[2].toString() +
            " km"),
        _buildTableRow("Running, " +
            runningTime[0].toString() +
            " h : " +
            runningTime[1].toString() +
            " m," +
            runningTime[2].toString() +
            " km"),
        _buildTableRow("Climbing, " +
            climbingTime[0].toString() +
            " h : " +
            climbingTime[1].toString() +
            " m, -"),
      ],
    );
  }

  _build12WeeksActivityTimeChart(List<RecordedActivity> activities) {
    List<charts.Series<ActivitiesDataDateTime, DateTime>> data =
        SortingDataService().getActivityTimePast12Weeks(activities);

    return _buildLineGraphWithAreaAndPoints(data);
  }

  _build12WeeksCyclingDistanceChart(List<RecordedActivity> activities) {
    List<charts.Series<ActivitiesDataDateTime, DateTime>> data =
        SortingDataService().getActivityDistancePast12Weeks(activities);

    data.removeAt(0);

    return _buildLineGraphWithAreaAndPoints(data);
  }

  _build12WeeksRunningDistanceChart(List<RecordedActivity> activities) {
    List<charts.Series<ActivitiesDataDateTime, DateTime>> data =
        SortingDataService().getActivityDistancePast12Weeks(activities);

    data.removeAt(1);

    return _buildLineGraphWithAreaAndPoints(data);
  }

  Widget _buildWeeklyActivityChart(List<RecordedActivity> activities) {
    List<charts.Series<ActivitiesDataDateTime, DateTime>> data =
        SortingDataService().getWeeklyActivity(activities);

    return _buildLineGraphWithAreaAndPoints(data);
  }

  _buildLineGraphWithAreaAndPoints(
      List<charts.Series<ActivitiesDataDateTime, DateTime>> data) {
    if (data.isNotEmpty) {
      return SizedBox(
        height: 200.0,
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
