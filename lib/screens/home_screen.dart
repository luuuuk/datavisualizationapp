import 'package:data_visualization_app/models/recorded_activity.dart';
import 'package:data_visualization_app/screens/add_data_screen.dart';
import 'package:data_visualization_app/services/database_manager.dart';
import 'package:data_visualization_app/services/sorting_data.dart';
import 'package:data_visualization_app/theme.dart';
import 'package:data_visualization_app/widgets/border_container.dart';
import 'package:data_visualization_app/widgets/bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                        Center(
                          child: DataTable(
                            columns: [
                              DataColumn(
                                  label: Text(
                                "Type",
                                style: GoogleFonts.montserrat(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w900),
                              )),
                              DataColumn(
                                  label: Text(
                                "Duration",
                                style: GoogleFonts.montserrat(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w900),
                              )),
                              DataColumn(
                                  label: Text(
                                "Distance",
                                style: GoogleFonts.montserrat(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w900),
                              )),
                            ],
                            rows: getTableRows(snapshot.data),
                          ),
                        ),
                        "Activity Overview",
                      ),
                      BorderContainerWidget(
                          _buildTotalDistanceChart(snapshot.data),
                          "Total Distance"),
                      BorderContainerWidget(
                        _buildWeeklyActivityChart(snapshot.data),
                        "Weekly Activities"
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: ThemeColors.orange,
        onPressed: () {
          Navigator.pushNamed(context, AddDataScreen.routeName);
        },
        tooltip: 'Add data',
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomBarWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
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
          DataCell(Text(recAct.activityType, style: GoogleFonts.montserrat(color: Colors.white),)),
          DataCell(Text(recAct.duration, style: GoogleFonts.montserrat(color: Colors.white),)),
          DataCell(Text(recAct.distance.toString(), style: GoogleFonts.montserrat(color: Colors.white),)),
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

  Widget _buildWeeklyActivityChart(List<RecordedActivity> activities){

    List<charts.Series<ActivitiesDataDateTime, DateTime>> data = SortingDataService().getWeeklyActivity(activities);

    if(data.isNotEmpty) {
      return SizedBox(
        height: 200.0,
        child: new charts.TimeSeriesChart(
          data,
          animate: false,
          domainAxis: new charts.DateTimeAxisSpec(
              renderSpec: charts.GridlineRendererSpec(
                  axisLineStyle: charts.LineStyleSpec(
                    color: charts.MaterialPalette.white, // this also doesn't change the Y axis labels
                  ),
                  labelStyle: new charts.TextStyleSpec(
                    fontSize: 10,
                    color: charts.MaterialPalette.white,
                  ),
                  lineStyle: charts.LineStyleSpec(
                    thickness: 1,
                    color: charts.MaterialPalette.white,
                  )
              ),
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
                        thickness: 1,
                        color: charts.MaterialPalette.white)))
        ),
      );
    }
    else {
      return Center(
        child: Text("There seems to be no training data this week...\nTime to start training!", style: GoogleFonts.montserrat(color: Colors.white),),
      );
    }
  }
}
