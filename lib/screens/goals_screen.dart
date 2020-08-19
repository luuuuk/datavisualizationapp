import 'dart:ui';

import 'package:data_visualization_app/models/activity_goal.dart';
import 'package:data_visualization_app/screens/add_goal_screen.dart';
import 'package:data_visualization_app/screens/welcome_screen.dart';
import 'package:data_visualization_app/services/database_manager.dart';
import 'package:data_visualization_app/services/sorting_data.dart';
import 'package:data_visualization_app/widgets/border_container.dart';
import 'package:data_visualization_app/widgets/goal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme.dart';

class GoalsScreen extends StatefulWidget {
  static const routeName = '/GoalsScreen';
  @override
  _GoalsScreenState createState() => new _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DateTime dateTime;
  final Map<int, Widget> activityType = <int, Widget>{
    0: Text(
      "Running",
      style: GoogleFonts.montserrat(),
    ),
    1: Text(
      "Cycling",
      style: GoogleFonts.montserrat(),
    ),
    2: Text(
      "Climbing",
      style: GoogleFonts.montserrat(),
    ),
  };
  final Map<int, Widget> goalType = <int, Widget>{
    0: Text(
      "Distance",
      style: GoogleFonts.montserrat(),
    ),
    1: Text(
      "Time",
      style: GoogleFonts.montserrat(),
    ),
  };
  final Map<int, Widget> timeFrame = <int, Widget>{
    0: Text(
      "Week",
      style: GoogleFonts.montserrat(),
    ),
    1: Text(
      "Month",
      style: GoogleFonts.montserrat(),
    ),
    2: Text(
      "Year",
      style: GoogleFonts.montserrat(),
    ),
  };
  int segmentedActivityGroupValue = 0;
  int segmentedGoalGroupValue = 0;
  int segmentedTimeFrameGroupController = 0;
  bool isClimbing = false;
  int selectedGoalValue = 0;
  String selectedTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        color: ThemeColors.blueGreenisShade1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        Navigator.popAndPushNamed(context, WelcomeScreen.routeName);
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
                          'Goals',
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
            FutureBuilder<List<ActivityGoal>>(
                future: getGoalData(),
                builder: (context, AsyncSnapshot<List<ActivityGoal>> snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      margin: EdgeInsets.fromLTRB(32, 0, 0, 16),
                      padding: EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32),
                            bottomLeft: Radius.circular(32.0)),
                      ),
                      alignment: Alignment.topRight,
                      height: 280,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 16, 16, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Active',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: ThemeColors.mediumBlue,
                                      fontSize: 16.0),
                                ),
                                SizedBox(width: 10.0),
                                Text(
                                  'Goals',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: ThemeColors.mediumBlue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  return CupertinoContextMenu(
                                    actions: <Widget>[
                                      CupertinoContextMenuAction(
                                        child: const Text('Delete Goal'),
                                        onPressed: () {
                                          setState(() {
                                            deleteData(snapshot.data[index]);
                                            snapshot.data.removeAt(index);
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                    child: Container(
                                        child: FutureBuilder<double>(
                                            future: SortingDataService()
                                                .getCurrentGoalProgress(
                                                    snapshot.data[index]),
                                            builder: (context,
                                                AsyncSnapshot<double>
                                                    goalProgress) {
                                              if (goalProgress.hasData) {
                                                return GoalWidget(
                                                  snapshot
                                                      .data[index].goalNumber
                                                      .toDouble(),
                                                  goalProgress.data,
                                                  snapshot
                                                      .data[index].goalTitle,
                                                  snapshot.data[index].goalType,
                                                  snapshot
                                                      .data[index].activityType,
                                                  snapshot
                                                      .data[index].timeFrame,
                                                );
                                              } else {
                                                return Container();
                                              }
                                            })),
                                  );
                                }),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return BorderContainerWidget(
                        Container(
                          height: 80,
                          child: Center(
                            child: Text("No goals defined."),
                          ),
                        ),
                        "Your Goals",
                        true);
                  }
                }),
            GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, AddGoalScreen.routeName);
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(32, 0, 0, 16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      bottomLeft: Radius.circular(32.0)),
                ),
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      color: ThemeColors.mediumBlue,
                      size: 32,
                    ),
                    SizedBox(width: 20.0),
                    Row(
                      children: [
                        Text(
                          'Set',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: ThemeColors.mediumBlue,
                              fontSize: 16.0),
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          'New Goal',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: ThemeColors.mediumBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Method to get the data from the database
  Future<List<ActivityGoal>> getGoalData() async {
    DatabaseManager dbManager = new DatabaseManager();
    List<ActivityGoal> goals = await dbManager.getGoals();

    return goals;
  }

  /// Method to handle deleting of the specified [activity]
  void deleteData(ActivityGoal goal) {
    DatabaseManager dbManager = new DatabaseManager();
    dbManager.deleteGoal(goal);
  }
}
