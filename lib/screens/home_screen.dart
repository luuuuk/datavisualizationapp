import 'package:data_visualization_app/models/recorded_activity.dart';
import 'package:data_visualization_app/screens/activity_list_screen.dart';
import 'package:data_visualization_app/screens/add_data_screen.dart';
import 'package:data_visualization_app/services/database_manager.dart';
import 'package:data_visualization_app/services/sorting_data.dart';
import 'package:data_visualization_app/theme.dart';
import 'package:data_visualization_app/widgets/border_container.dart';
import 'package:data_visualization_app/widgets/bottom_bar.dart';
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
                      BorderContainerWidget(_buildWeeklyOverview(snapshot.data),
                          "Weekly Activity Overview"),
                      BorderContainerWidget(
                          _buildWeeklyActivityChart(snapshot.data),
                          "Weekly Activity Time"),
                      BorderContainerWidget(
                          _buildTotalDistanceChart(snapshot.data),
                          "Total Activity Distance"),
                      BorderContainerWidget(
                        _buildAllActivitiesTableWidget(snapshot.data),
                        "Activities Overview",
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
            child: Icon(Icons.list, color: Colors.white,),
            backgroundColor: ThemeColors.orange,
            onTap: () { Navigator.pushNamed(context, ActivityListScreen.routeName); },
    ),
        // FAB 2
        SpeedDialChild(
            child: Icon(Icons.add, color: Colors.white,),
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

  /// Method to build the BarChart containing the data for the duration of the given [activities]
  Widget _buildTotalDistanceChart(List<RecordedActivity> activities) {
    return SizedBox(
      height: 200.0,
      child: new charts.BarChart(
        SortingDataService().getTotalActivitiesDistance(activities),
        animate: false,
        barGroupingType: charts.BarGroupingType.stacked,
        domainAxis: new charts.OrdinalAxisSpec(
            renderSpec: new charts.SmallTickRendererSpec(

                // Tick and Label styling here.
                labelStyle: new charts.TextStyleSpec(
                    fontSize: 12, // size in Pts.
                    color: charts.MaterialPalette.white),

                // Change the line colors to match text color.
                lineStyle: new charts.LineStyleSpec(
                    color: charts.MaterialPalette.white))),
        primaryMeasureAxis: new charts.NumericAxisSpec(
            renderSpec: new charts.GridlineRendererSpec(

                // Tick and Label styling here.
                labelStyle: new charts.TextStyleSpec(
                    fontSize: 12, // size in Pts.
                    color: charts.MaterialPalette.white),

                // Change the line colors to match text color.
                lineStyle: new charts.LineStyleSpec(
                    color: charts.MaterialPalette.white))),
      ),
    );
  }

  Widget _buildWeeklyActivityChart(List<RecordedActivity> activities) {
    List<charts.Series<ActivitiesDataDateTime, DateTime>> data =
        SortingDataService().getWeeklyActivity(activities);

    if (data.isNotEmpty) {
      return SizedBox(
        height: 200.0,
        child: new charts.TimeSeriesChart(
          data,
          animate: false,
          defaultRenderer: new charts.LineRendererConfig(includePoints: true),
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

  Widget _buildAllActivitiesTableWidget(List<RecordedActivity> activities) {
    return Center(
      child: DataTable(
        columns: [
          DataColumn(
              label: Text(
            "Type",
            style: GoogleFonts.montserrat(
                fontSize: 12.0, fontWeight: FontWeight.w900),
          )),
          DataColumn(
              label: Text(
            "Duration",
            style: GoogleFonts.montserrat(
                fontSize: 12.0, fontWeight: FontWeight.w900),
          )),
          DataColumn(
              label: Text(
            "Distance",
            style: GoogleFonts.montserrat(
                fontSize: 12.0, fontWeight: FontWeight.w900),
          )),
        ],
        rows: getTableRows(activities),
      ),
    );
  }

  /// Method to build a weekly overview table containing only activity data from the past week
  Widget _buildWeeklyOverview(List<RecordedActivity> activities) {
    /// Hours, Minutes, Seconds, Distance
    List<int> cyclingTime = [0, 0];
    List<int> runningTime = [0, 0];
    int climbingTime = 0;

    for (RecordedActivity activity in activities) {
      List stringDateSplitted = activity.date.split(".");
      DateTime dateTime = DateTime(int.parse(stringDateSplitted[2]),
          int.parse(stringDateSplitted[1]), int.parse(stringDateSplitted[0]));

      /// If older than a week, do not include
      if (dateTime.compareTo(DateTime.now().subtract(Duration(days: 7))) > 0) {
        List stringDurationSplitted = activity.duration.split(":");
        int durationInHours = int.parse(stringDurationSplitted[0]);

        /// Add up duration and distance per activity type
        switch (activity.activityType) {
          case "Running":
            {
              runningTime[0] += durationInHours;
              runningTime[1] += activity.distance;
            }
            break;
          case "Cycling":
            {
              cyclingTime[0] += durationInHours;
              cyclingTime[1] += activity.distance;
            }
            break;
          case "Climbing":
            {
              climbingTime += durationInHours;
            }
        }
      }
    }

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
            " hours, " +
            cyclingTime[1].toString() +
            " km"),
        _buildTableRow("Running, " +
            runningTime[0].toString() +
            " hours, " +
            runningTime[1].toString() +
            " km"),
        _buildTableRow("Climbing, " + climbingTime.toString() + " hours, -"),
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
}
