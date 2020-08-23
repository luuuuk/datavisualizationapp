import 'package:carousel_slider/carousel_slider.dart';
import 'package:data_visualization_app/models/activity_goal.dart';
import 'package:data_visualization_app/models/recorded_activity.dart';
import 'package:data_visualization_app/screens/activity_list_screen.dart';
import 'package:data_visualization_app/screens/add_data_screen.dart';
import 'package:data_visualization_app/screens/goals_screen.dart';
import 'package:data_visualization_app/screens/welcome_screen.dart';
import 'package:data_visualization_app/services/database_manager.dart';
import 'package:data_visualization_app/services/sorting_data.dart';
import 'package:data_visualization_app/theme.dart';
import 'package:data_visualization_app/widgets/border_container.dart';
import 'package:data_visualization_app/widgets/goal.dart';
import 'package:data_visualization_app/widgets/overview.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class HomeScreen extends StatefulWidget {
  static const routeName = '/HomeScreen';
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _currentPosition = 0;

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
                  return Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.15,
                        width: MediaQuery.of(context).size.width / 1.1,
                        child: Container(
                          margin: EdgeInsets.only(top: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, WelcomeScreen.routeName);
                                },
                                alignment: Alignment.topLeft,
                                icon: Icon(
                                  Icons.keyboard_arrow_left,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Your',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Colors.white,
                                        fontSize: 25.0),
                                  ),
                                  SizedBox(width: 10.0),
                                  Text(
                                    'Statistics',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25.0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        width: MediaQuery.of(context).size.width,
                        child: CarouselSlider(
                          options: CarouselOptions(
                              height: MediaQuery.of(context).size.height * 0.8,
                              initialPage: 0,
                              viewportFraction: 0.95,
                              enableInfiniteScroll: true,
                              autoPlay: false,
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                              scrollDirection: Axis.horizontal,
                              onPageChanged: (page, reason) {
                                setState(() {
                                  _currentPosition = page.toDouble();
                                });
                              }),
                          items: [
                            Container(
                              margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                //boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(0, 5), blurRadius: 1.0, spreadRadius: 1.0)],
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(32)),
                              ),
                              child: _weeklyOverviewWidget(snapshot.data),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(32)),
                              ),
                              child: _monthlyOverviewWidget(snapshot.data),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(32)),
                              ),
                              child: _last12WeeksOverviewWidget(snapshot.data),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(32)),
                              ),
                              child: _annualOverviewWidget(snapshot.data),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: Center(
                          child: DotsIndicator(
                            dotsCount: 4,
                            position: _currentPosition,
                            axis: Axis.horizontal,
                            decorator: DotsDecorator(
                              color: ThemeColors.blueGreenisShade1,
                              activeColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      /*
                      BorderContainerWidget(
                        _build12WeeksActivityTimeChart(snapshot.data),
                        "Activity Time last 12 weeks",
                        true,
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      BorderContainerWidget(
                        _build12WeeksCyclingDistanceChart(snapshot.data),
                        "Cycling Distance last 12 weeks",
                        false,
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      BorderContainerWidget(
                        _buildAverageSpeedProgression(snapshot.data, 1, false),
                        "Average Speed Progression in Cycling",
                        true,
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      BorderContainerWidget(
                        _build12WeeksRunningDistanceChart(snapshot.data),
                        "Running Distance last 12 weeks",
                        false,
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      BorderContainerWidget(
                        _buildAverageSpeedProgression(snapshot.data, 0, false),
                        "Average Speed Progression in Running",
                        true,
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      BorderContainerWidget(
                        _annualOverviewWidget(snapshot.data),
                        "Annual Activity Overview " +
                            DateTime.now().year.toString(),
                        false,
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      */
                    ],
                  );
                } else {
                  return ListView(children: [
                    Container(
                      padding: EdgeInsets.all(32),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            IconButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, WelcomeScreen.routeName);
                              },
                              alignment: Alignment.topLeft,
                              icon: Icon(
                                Icons.keyboard_arrow_left,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  'Your',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.white,
                                      fontSize: 25.0),
                                ),
                                SizedBox(width: 10.0),
                                Text(
                                  'Statistics',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25.0),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "You have not yet entered any data to be displayed. \nStart getting active today!",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ]);
                }
              }),
        ),
      ),
    );
  }

  /// Method to get the data from the database
  Future<List<RecordedActivity>> getActivityData() async {
    DatabaseManager dbManager = new DatabaseManager();
    List<RecordedActivity> activities = await dbManager.getActivities();

    return activities;
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
            Icon(
              Icons.directions_walk,
              color: ThemeColors.blueGreenisShade1,
            ),
          ],
        ),
      ],
    );
  }

  /// Method to assemble the weekly overview
  Widget _weeklyOverviewWidget(List<RecordedActivity> activities) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            child: Column(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Weekly",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: ThemeColors.darkBlue,
                            fontSize: 16.0),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Overview",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: ThemeColors.darkBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 8),
                  child: _buildWeeklyActivityChart(activities),
                ),
                Container(
                  child: OverviewWidget(activities, 0),
                ),
              ],
            ),
          ),
          Container(
            child: _buildGoalList(0),
          ),
        ]);
  }

  Widget _monthlyOverviewWidget(List<RecordedActivity> activities) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            child: Column(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Monthly Overview",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: ThemeColors.darkBlue,
                            fontSize: 16.0),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        _getCurrentMonthName(),
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: ThemeColors.darkBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 8),
                  child: _buildMonthlyActivityChart(activities),
                ),
                Container(
                  child: OverviewWidget(activities, 1),
                ),
              ],
            ),
          ),
          Container(
            child: _buildGoalList(1),
          ),
        ]);
  }

  Widget _last12WeeksOverviewWidget(List<RecordedActivity> activities) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Overview",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: ThemeColors.darkBlue,
                            fontSize: 16.0),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Last 12 Weeks",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: ThemeColors.darkBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 8),
                  child: _build12WeeksActivityTimeChart(activities),
                ),
                Container(child: _build12WeeksCyclingDistanceChart(activities)),
                Container(child: _build12WeeksRunningDistanceChart(activities)),
              ],
            ),
          ),
        ]);
  }

  /// Method to assemble the yearly overview
  Widget _annualOverviewWidget(List<RecordedActivity> activities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OverviewWidget(activities, 2),
        Container(
          margin: EdgeInsets.fromLTRB(8, 16, 8, 8),
          padding: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(32),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                child: Text(
                  "Total Activity Time " + DateTime.now().year.toString(),
                  style: GoogleFonts.montserrat(color: Colors.white),
                ),
              ),
              _buildYearlyDurationChart(activities),
            ],
          ),
        ),
        /*
        Container(
          margin: EdgeInsets.fromLTRB(8, 16, 8, 8),
          padding: EdgeInsets.fromLTRB(8, 0, 0, 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(32),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: Text(
                  "Total Activity Distance " + DateTime.now().year.toString(),
                  style: GoogleFonts.montserrat(color: Colors.white),
                ),
              ),
              _buildYearlyDistanceChart(activities),
            ],
          ),
        ),
         */
        /*
        Container(
          margin: EdgeInsets.fromLTRB(8, 16, 8, 32),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(32),
            ),
          ),
          padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: _buildGoalList(2),
        ),
         */
      ],
    );
  }

  /// Method to return a list view containing the goals for the specified time span
  /// where 0: week, 1: month, 2: year
  Widget _buildGoalList(int timeSpan) {
    return FutureBuilder<List<ActivityGoal>>(
        future: getGoalData(timeSpan),
        builder: (context, AsyncSnapshot<List<ActivityGoal>> snapshot) {
          if (snapshot.hasData) {
            return Container(
              height: 100,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Container(
                            child: FutureBuilder<double>(
                                future: SortingDataService()
                                    .getCurrentGoalProgress(
                                        snapshot.data[index]),
                                builder: (context,
                                    AsyncSnapshot<double> goalProgress) {
                                  if (goalProgress.hasData) {
                                    return GoalWidget(
                                        snapshot.data[index].goalNumber
                                            .toDouble(),
                                        goalProgress.data,
                                        snapshot.data[index].goalTitle,
                                        snapshot.data[index].goalType,
                                        snapshot.data[index].activityType,
                                        snapshot.data[index].timeFrame,
                                        true);
                                  } else {
                                    return Container();
                                  }
                                }),
                          );
                        }),
                  ),
                ],
              ),
            );
          } else {
            return Container();
          }
        });
  }

  _build12WeeksActivityTimeChart(List<RecordedActivity> activities) {
    List<charts.Series<ActivitiesDataDateTime, DateTime>> data =
        SortingDataService().getActivityTimePast12Weeks(activities);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        RotatedBox(
          quarterTurns: 3,
          child: Text(
            "All activities",
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: ThemeColors.darkBlue,
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
            textAlign: TextAlign.justify,
            overflow: TextOverflow.fade,
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Expanded(
          child: _buildLineGraphWithAreaAndPoints(
              data, MediaQuery.of(context).size.height * 0.2, true, false),
        ),
      ],
    );
  }

  _build12WeeksCyclingDistanceChart(List<RecordedActivity> activities) {
    List<charts.Series<ActivitiesDataDateTime, DateTime>> data =
        SortingDataService().getActivityDistancePast12Weeks(activities);

    data.removeAt(0);
    data.removeLast();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        RotatedBox(
          quarterTurns: 3,
          child: Text(
            "Cycling",
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: ThemeColors.darkBlue,
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
            textAlign: TextAlign.justify,
            overflow: TextOverflow.fade,
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Expanded(
          child: _buildLineGraphWithAreaAndPoints(
              data, MediaQuery.of(context).size.height * 0.2, true, true),
        ),
      ],
    );
  }

  _build12WeeksRunningDistanceChart(List<RecordedActivity> activities) {
    List<charts.Series<ActivitiesDataDateTime, DateTime>> data =
        SortingDataService().getActivityDistancePast12Weeks(activities);

    data.removeAt(1);
    data.removeLast();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        RotatedBox(
          quarterTurns: 3,
          child: Text(
            "Running",
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: ThemeColors.darkBlue,
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
            textAlign: TextAlign.justify,
            overflow: TextOverflow.fade,
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Expanded(
          child: _buildLineGraphWithAreaAndPoints(
              data, MediaQuery.of(context).size.height * 0.2, true, true),
        ),
      ],
    );
  }

  Widget _buildWeeklyActivityChart(List<RecordedActivity> activities) {
    List<charts.Series<ActivitiesDataDateTime, DateTime>> data =
        SortingDataService().getWeeklyActivity(activities);

    return _buildActivityBarChart(data, 160, true);
  }

  _buildMonthlyActivityChart(List<RecordedActivity> activities) {
    List<charts.Series<ActivitiesDataDateTime, DateTime>> data =
        SortingDataService().getMonthlyActivity(activities);

    return _buildActivityBarChart(data, 160, true);
  }

  _buildActivityBarChart(
      List<charts.Series<ActivitiesDataDateTime, DateTime>> data,
      double height,
      bool inverseColors) {
    if (data.isNotEmpty) {
      return Container(
        padding: EdgeInsets.all(4.0),
        margin: EdgeInsets.only(bottom: 32),
        child: SizedBox(
          height: height,
          child: new charts.TimeSeriesChart(
            data,
            animate: true,
            defaultRenderer: new charts.BarRendererConfig<DateTime>(
              cornerStrategy: const charts.ConstCornerStrategy(30),
              groupingType: charts.BarGroupingType.stacked,
            ),
            defaultInteractions: false,
            domainAxis: new charts.DateTimeAxisSpec(
              renderSpec: charts.GridlineRendererSpec(
                axisLineStyle: charts.LineStyleSpec(
                  color: inverseColors
                      ? charts.Color.fromHex(code: "#2D274CFF")
                      : charts.MaterialPalette
                          .white, // this also doesn't change the Y axis labels
                ),
                labelStyle: new charts.TextStyleSpec(
                  fontSize: 10,
                  color: inverseColors
                      ? charts.Color.fromHex(code: "#2D274CFF")
                      : charts.MaterialPalette.white,
                ),
                lineStyle: charts.LineStyleSpec(
                  thickness: 2,
                  color: inverseColors
                      ? charts.Color.fromHex(code: "#2D274CFF")
                      : charts.MaterialPalette.white,
                ),
              ),
              tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
                hour: new charts.TimeFormatterSpec(
                  format: 'H',
                  transitionFormat: 'H',
                ),
              ),
            ),
            primaryMeasureAxis: charts.NumericAxisSpec(
              tickFormatterSpec: charts.BasicNumericTickFormatterSpec(
                  (num value) => '$value h'),
              tickProviderSpec:
                  new charts.BasicNumericTickProviderSpec(desiredTickCount: 3),
              renderSpec: charts.GridlineRendererSpec(
                labelStyle: charts.TextStyleSpec(
                    fontSize: 10,
                    color: inverseColors
                        ? charts.Color.fromHex(code: "#2D274CFF")
                        : charts.MaterialPalette.white),
                lineStyle: charts.LineStyleSpec(
                    thickness: 2,
                    color: inverseColors
                        ? charts.Color.fromHex(code: "#2D274CFF")
                        : charts.MaterialPalette.white),
              ),
            ),
          ),
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

  _buildLineGraphWithAreaAndPoints(
      List<charts.Series<ActivitiesDataDateTime, DateTime>> data,
      double height,
      bool inverseColors,
      bool distance) {
    if (data.isNotEmpty) {
      return Container(
        //padding: EdgeInsets.all(4.0),
        //margin: EdgeInsets.only(bottom: 32),
        child: SizedBox(
          height: height,
          child: new charts.TimeSeriesChart(
            data,
            animate: true,
            defaultRenderer: new charts.LineRendererConfig(
              includePoints: true,
              includeArea: true,
            ),
            domainAxis: new charts.DateTimeAxisSpec(
              renderSpec: charts.GridlineRendererSpec(
                axisLineStyle: charts.LineStyleSpec(
                  color: inverseColors
                      ? charts.Color.fromHex(code: "#2D274CFF")
                      : charts.MaterialPalette
                          .white, // this also doesn't change the Y axis labels
                ),
                labelStyle: new charts.TextStyleSpec(
                  fontSize: 10,
                  color: inverseColors
                      ? charts.Color.fromHex(code: "#2D274CFF")
                      : charts.MaterialPalette.white,
                ),
                lineStyle: charts.LineStyleSpec(
                  thickness: 2,
                  color: inverseColors
                      ? charts.Color.fromHex(code: "#2D274CFF")
                      : charts.MaterialPalette.white,
                ),
              ),
              tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
                hour: new charts.TimeFormatterSpec(
                  format: 'H',
                  transitionFormat: 'H',
                ),
              ),
            ),
            primaryMeasureAxis: charts.NumericAxisSpec(
              tickFormatterSpec: charts.BasicNumericTickFormatterSpec(
                  (num value) {
                    String valueTronc = value.toStringAsFixed(0);

                    return distance ? valueTronc + " km" : valueTronc + " h";
                  }),
              tickProviderSpec:
                  new charts.BasicNumericTickProviderSpec(desiredTickCount: 3),
              renderSpec: charts.GridlineRendererSpec(
                labelStyle: charts.TextStyleSpec(
                    fontSize: 10,
                    color: inverseColors
                        ? charts.Color.fromHex(code: "#2D274CFF")
                        : charts.MaterialPalette.white),
                lineStyle: charts.LineStyleSpec(
                    thickness: 2,
                    color: inverseColors
                        ? charts.Color.fromHex(code: "#2D274CFF")
                        : charts.MaterialPalette.white),
              ),
            ),
          ),
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

  _buildAverageSpeedProgression(
      List<RecordedActivity> activities, int type, bool inverseColors) {
    var data =
        SortingDataService().getAverageSpeedData(activities, 9, type, false);

    if (data.isNotEmpty) {
      return Container(
        margin: EdgeInsets.only(bottom: 32),
        child: SizedBox(
          height: 200.0,
          child: charts.BarChart(
            data,
            animate: false,
            domainAxis: charts.AxisSpec<String>(
              renderSpec: charts.GridlineRendererSpec(
                lineStyle: charts.LineStyleSpec(
                  thickness: 2,
                  color: inverseColors
                      ? charts.Color.fromHex(code: "#2D274CFF")
                      : charts.MaterialPalette.white,
                ),
                labelStyle: new charts.TextStyleSpec(
                  fontSize: 10,
                  color: inverseColors
                      ? charts.Color.fromHex(code: "#2D274CFF")
                      : charts.MaterialPalette.white,
                ),
              ),
            ),
            primaryMeasureAxis: charts.NumericAxisSpec(
              renderSpec: charts.GridlineRendererSpec(
                labelStyle: charts.TextStyleSpec(
                    fontSize: 10,
                    color: inverseColors
                        ? charts.Color.fromHex(code: "#2D274CFF")
                        : charts.MaterialPalette.white),
                lineStyle: charts.LineStyleSpec(
                    thickness: 2,
                    color: inverseColors
                        ? charts.Color.fromHex(code: "#2D274CFF")
                        : charts.MaterialPalette.white),
              ),
            ),
            customSeriesRenderers: [
              new charts.BarTargetLineRendererConfig<String>(
                  // ID used to link series to this renderer.
                  customRendererId: 'customTargetLine',
                  groupingType: charts.BarGroupingType.stacked)
            ],
          ),
        ),
      );
    } else {
      return Container(
        child: Text(
          "No activities yet.",
          style: GoogleFonts.montserrat(
            color: inverseColors ? ThemeColors.darkBlue : Colors.white,
          ),
        ),
      );
    }
  }

  Future<List<ActivityGoal>> getGoalData(int timeFrame) async {
    DatabaseManager dbManager = new DatabaseManager();

    List<ActivityGoal> allGoals = await dbManager.getGoals();
    List<ActivityGoal> returnGoals = new List();

    for (ActivityGoal goal in allGoals) {
      if (goal.timeFrame == timeFrame) {
        returnGoals.add(goal);
      }
    }

    return returnGoals;
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
