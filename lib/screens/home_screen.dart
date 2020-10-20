import 'package:carousel_slider/carousel_slider.dart';
import 'package:data_visualization_app/models/activity_goal.dart';
import 'package:data_visualization_app/models/recorded_activity.dart';
import 'package:data_visualization_app/screens/welcome_screen.dart';
import 'package:data_visualization_app/services/database_manager.dart';
import 'package:data_visualization_app/services/graph_builder.dart';
import 'package:data_visualization_app/services/sorting_data.dart';
import 'package:data_visualization_app/theme.dart';
import 'package:data_visualization_app/widgets/goal.dart';
import 'package:data_visualization_app/widgets/overview.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class HomeScreen extends StatefulWidget {
  static const routeName = '/HomeScreen';
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _currentPosition = 0;
  GraphBuilder graphBuilder = GraphBuilder();
  int weeksInPast = 0;
  int monthsInPast = 0;
  int yearsInPast = 0;

  @override
  Widget build(BuildContext context) {

    print("weeksInPast = " + weeksInPast.toString() + "\nmonthsInPast = " + monthsInPast.toString() + "\nyearsInPast = " + yearsInPast.toString());

    return Scaffold(
      body: Container(
        color: ThemeColors.darkBlue,
        child: Center(
          child: FutureBuilder<List<RecordedActivity>>(
            future: getActivityData(),
            builder: (context, AsyncSnapshot<List<RecordedActivity>> snapshot) {
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
                          _currentPosition == 0
                              ? Container(
                                  margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    //boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(0, 5), blurRadius: 1.0, spreadRadius: 1.0)],
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32)),
                                  ),
                                  child: _weeklyOverviewWidget(snapshot.data),
                                )
                              : _getEmptyContainer(),
                          _currentPosition == 1
                              ? Container(
                                  margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32)),
                                  ),
                                  child: _monthlyOverviewWidget(snapshot.data),
                                )
                              : _getEmptyContainer(),
                          _currentPosition == 2
                              ? Container(
                                  margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32)),
                                  ),
                                  child:
                                      _last12WeeksOverviewWidget(snapshot.data),
                                )
                              : _getEmptyContainer(),
                          _currentPosition == 3
                              ? Container(
                                  margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32)),
                                  ),
                                  child: _annualOverviewWidget(snapshot.data),
                                )
                              : _getEmptyContainer(),
                          _currentPosition == 4
                              ? Container(
                                  margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32)),
                                  ),
                                  child: _progressionWidget(snapshot.data),
                                )
                              : _getEmptyContainer(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: Center(
                        child: DotsIndicator(
                          dotsCount: 5,
                          position: _currentPosition,
                          axis: Axis.horizontal,
                          decorator: DotsDecorator(
                            color: ThemeColors.blueGreenisShade1,
                            activeColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return ListView(
                  children: [
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
                  ],
                );
              }
            },
          ),
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
    List<charts.Series<ActivitiesData, String>> data =
        SortingDataService().getYearlyActivitiesDistance(activities, yearsInPast);

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.14,
      child: graphBuilder.buildTimeSeriesChartHorizontalBarChart(data),
    );
  }

  /// Method to build the BarChart containing the data for the duration of the given [activities]
  Widget _buildYearlyDurationChart(List<RecordedActivity> activities) {
    List<charts.Series<ActivitiesData, String>> data =
        SortingDataService().getYearlyActivitiesTime(activities, yearsInPast);

    int totalHours = 0;

    for (int i = 0; i < 4; i++) {
      totalHours += data[0].data[i].number ~/ 60;
    }

    if(totalHours == 0){
      return SizedBox(
        height: 140.0,
        child: Center(
          child: Text(
            '0 h',
            style: TextStyle(
                fontFamily: 'Montserrat',
                color: ThemeColors.darkBlue,
                fontWeight: FontWeight.bold,
                fontSize: 12.0),
          ),
        ),
      );
    } else {
      return SizedBox(
        height: 140.0,
        child: Stack(
          children: [
            new charts.PieChart(
              data,
              animate: true,
              animationDuration: Duration(seconds: 1),
              defaultRenderer: new charts.ArcRendererConfig(
                arcWidth: 18,
                arcRendererDecorators: [
                  new charts.ArcLabelDecorator(
                    labelPosition: charts.ArcLabelPosition.outside,
                    outsideLabelStyleSpec: charts.TextStyleSpec(
                        color: charts.Color.fromHex(code: "#2D274CFF"),
                        fontSize: 12),
                  ),
                ],
              ),
            ),
            Center(
              child: Text(
                totalHours.toString() + " h",
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: ThemeColors.darkBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0),
              ),
            ),
          ],
        ),
      );
    }
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
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: ThemeColors.darkBlue, size: 16,),
                      onPressed: (){
                        /// Load data for previous week
                        setState(() {
                          weeksInPast++;
                        });
                      },
                    ),
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
                      weeksInPast == 0 ? "This Week" : weeksInPast > 1 ? "$weeksInPast Weeks ago" : "$weeksInPast Week ago",
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: ThemeColors.darkBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward_ios, color: weeksInPast == 0 ? Colors.white : ThemeColors.darkBlue, size: 16,),
                      onPressed: (){
                        /// Load data for next week if displayed week is not the current week
                        if(weeksInPast > 0){
                          setState(() {
                            weeksInPast--;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              Container(
                child: _buildWeeklyActivityChart(activities),
              ),
              Container(
                child: OverviewWidget(activities, 0, weeksInPast),
              ),
            ],
          ),
        ),
        Container(
          child: _buildGoalList(0),
        ),
      ],
    );
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
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: ThemeColors.darkBlue, size: 16,),
                      onPressed: (){
                        /// Load data for previous month
                        setState(() {
                          monthsInPast++;
                        });
                      },
                    ),
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
                      _getMonthName(),
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: ThemeColors.darkBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward_ios, color: monthsInPast == 0 ? Colors.white : ThemeColors.darkBlue, size: 16,),
                      onPressed: (){
                        /// Load data for next month if displayed month is not the current month
                        if(monthsInPast > 0){
                          setState(() {
                            monthsInPast--;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 8),
                child: _buildMonthlyActivityChart(activities),
              ),
              Container(
                child: OverviewWidget(activities, 1, monthsInPast),
              ),
            ],
          ),
        ),
        Container(
          child: _buildGoalList(1),
        ),
      ],
    );
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
                padding: EdgeInsets.only(top: 4),
                child: _build12WeeksActivityTimeChart(activities),
              ),
              Container(child: _build12WeeksCyclingDistanceChart(activities)),
              Container(child: _build12WeeksRunningDistanceChart(activities)),
            ],
          ),
        ),
      ],
    );
  }

  /// Method to assemble the yearly overview
  Widget _annualOverviewWidget(List<RecordedActivity> activities) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: ThemeColors.darkBlue, size: 16,),
                      onPressed: (){
                        /// Load data for previous year
                        setState(() {
                          yearsInPast++;
                        });
                      },
                    ),
                    Text(
                      "Annual Overview",
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: ThemeColors.darkBlue,
                          fontSize: 16.0),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                    (DateTime.now().year - yearsInPast).toString(),
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: ThemeColors.darkBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward_ios, color: yearsInPast == 0 ? Colors.white : ThemeColors.darkBlue, size: 16,),
                      onPressed: (){
                        /// Load data for next year if displayed year is not the current week
                        if(yearsInPast > 0){
                          setState(() {
                            yearsInPast--;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              Container(
                child: OverviewWidget(activities, 2, yearsInPast),
              ),
              Container(
                padding: EdgeInsets.only(top: 8),
                child: _buildYearlyDurationChart(activities),
              ),
              Container(
                child: _buildYearlyDistanceChart(activities),
              ),
            ],
          ),
        ),
        Container(
          child: _buildGoalList(2),
        ),
      ],
    );
  }

  Widget _progressionWidget(List<RecordedActivity> activities) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
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
                    "Progression",
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: ThemeColors.darkBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                ],
              ),
              Container(
                child: _buildAverageSpeedProgression(activities, 0, true),
              ),
              Container(
                child: _buildAverageSpeedProgression(activities, 1, true),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Method to return a list view containing the goals for the specified time span
  /// where 0: week, 1: month, 2: year
  Widget _buildGoalList(int timeSpan) {

    int retroView;
    switch(timeSpan){
      case 0: retroView = weeksInPast;
      break;
      case 1: retroView = monthsInPast;
      break;
      case 2: retroView = yearsInPast;
      break;
      default: retroView = weeksInPast;
    }

    return FutureBuilder<List<ActivityGoal>>(
        future: getGoalData(timeSpan),
        builder: (context, AsyncSnapshot<List<ActivityGoal>> snapshot) {
          if (snapshot.hasData && snapshot.data.isNotEmpty) {
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
                                        snapshot.data[index], retroView),
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
            return Container(
              child: Center(
                child: Text(
                  "You have no goals defined.",
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: ThemeColors.darkBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0),
                ),
              ),
            );
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
            ActivityInfo.activity2Name,
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
            ActivityInfo.activity1Name,
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
        SortingDataService().getWeeklyActivity(activities, weeksInPast);

    return _buildActivityBarChart(data, 160, true, true);
  }

  Widget _buildMonthlyActivityChart(List<RecordedActivity> activities) {
    List<charts.Series<ActivitiesDataDateTime, DateTime>> data =
        SortingDataService().getMonthlyActivity(activities, monthsInPast);

    return _buildActivityBarChart(data, 160, true, false);
  }

  Widget _buildActivityBarChart(
    List<charts.Series<ActivitiesDataDateTime, DateTime>> data,
    double height,
    bool inverseColors,
    bool week,
  ) {
    if (data.isNotEmpty) {
      return Container(
        padding: EdgeInsets.all(4.0),
        margin: EdgeInsets.only(bottom: 32),
        child: SizedBox(
          height: height,
          child: GraphBuilder()
              .buildTimeSeriesChartBarChart(data, height, inverseColors, week),
        ),
      );
    } else {
      return Center(
        child: Text(
          "There seems to be no training data this week...\nTime to start training!",
          style: GoogleFonts.montserrat(color: ThemeColors.darkBlue),
        ),
      );
    }
  }

  Widget _buildLineGraphWithAreaAndPoints(
      List<charts.Series<ActivitiesDataDateTime, DateTime>> data,
      double height,
      bool inverseColors,
      bool distance) {
    if (data.isNotEmpty) {
      return Container(
        child: SizedBox(
          height: height,
          child: graphBuilder.buildTimeSeriesChartPointsLinesArea(
              data, inverseColors, distance),
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

  Widget _buildAverageSpeedProgression(
      List<RecordedActivity> activities, int type, bool inverseColors) {
    List<charts.Series<ActivitiesPrecisionNumData, int>> data =
        SortingDataService().getAverageSpeedData(activities, 25, type, false);

    String nameToUse = type == 0 ? ActivityInfo.activity1Name : ActivityInfo.activity2Name;

    if (data.isNotEmpty) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          RotatedBox(
            quarterTurns: 3,
            child: Text(
              type == 0 ? ActivityInfo.activity1Name : ActivityInfo.activity2Name,
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
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: graphBuilder.buildScatterPlotChart(data),
            ),
          ),
        ],
      );
    } else {
      return Container(
        child: Text(
          "No " + nameToUse + " activities yet.",
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

  /// Method to return an empty white container for slider pages
  Widget _getEmptyContainer() {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(32)),
      ),
    );
  }

  /// Method to return the name of the month for which the data has been retrieved
  String _getMonthName() {
    switch (DateTime.now().month - monthsInPast) {
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
