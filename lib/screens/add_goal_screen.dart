import 'dart:ui';

import 'package:data_visualization_app/models/activity_goal.dart';
import 'package:data_visualization_app/models/recorded_activity.dart';
import 'package:data_visualization_app/screens/welcome_screen.dart';
import 'package:data_visualization_app/services/database_manager.dart';
import 'package:data_visualization_app/services/sorting_data.dart';
import 'package:data_visualization_app/widgets/border_container.dart';
import 'package:data_visualization_app/widgets/goal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme.dart';

class AddGoalScreen extends StatefulWidget {
  static const routeName = '/AddGoalScreen';
  @override
  _AddGoalScreenState createState() => new _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DateTime dateTime;

  TextEditingController _goalValueController = new TextEditingController();
  bool isClimbing = false;
  int selectedGoalValue = 0;
  String selectedTitle = "";
  int goalActivityValue = 0;
  int goalTypeValue = 0;
  int goalTimeFrameValue = 0;
  Color selectedColor = ThemeColors.darkBlue;
  Color unselectedColor = ThemeColors.blueGreenisShade1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Container(
          color: ThemeColors.blueGreenisShade1,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 32),
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          alignment: Alignment.topLeft,
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'Add',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Colors.white,
                                  fontSize: 25.0),
                            ),
                            SizedBox(width: 10.0),
                            Text(
                              'New Goal',
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
                Container(
                  margin: EdgeInsets.fromLTRB(32, 0, 0, 16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        bottomLeft: Radius.circular(32.0)),
                  ),
                  alignment: Alignment.topRight,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Goal',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: ThemeColors.mediumBlue,
                                    fontSize: 16.0),
                              ),
                              SizedBox(width: 10.0),
                              Text(
                                'Activity',
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
                      Container(
                        padding: EdgeInsets.only(top: 16),
                        child: SizedBox(
                          height: 60,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    goalActivityValue = 0;
                                    FocusScope.of(context).unfocus();
                                  });
                                },
                                child: AnimatedContainer(
                                  curve: Curves.fastOutSlowIn,
                                  duration: Duration(milliseconds: 500),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                    color: goalActivityValue == 0
                                        ? selectedColor
                                        : unselectedColor,
                                  ),
                                  padding: EdgeInsets.all(16),
                                  margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  child: Icon(
                                    ActivityInfo.activity1Icon,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    goalActivityValue = 1;
                                    FocusScope.of(context).unfocus();
                                  });
                                },
                                child: AnimatedContainer(
                                  curve: Curves.fastOutSlowIn,
                                  duration: Duration(milliseconds: 500),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                    color: goalActivityValue == 1
                                        ? selectedColor
                                        : unselectedColor,
                                  ),
                                  padding: EdgeInsets.all(16),
                                  margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  child: Icon(
                                    ActivityInfo.activity2Icon,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    goalActivityValue = 2;
                                    FocusScope.of(context).unfocus();
                                  });
                                },
                                child: AnimatedContainer(
                                  curve: Curves.fastOutSlowIn,
                                  duration: Duration(milliseconds: 500),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                    color: goalActivityValue == 2
                                        ? selectedColor
                                        : unselectedColor,
                                  ),
                                  padding: EdgeInsets.all(16),
                                  margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  child: Icon(
                                    ActivityInfo.activity3Icon,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    goalActivityValue = 3;
                                    FocusScope.of(context).unfocus();
                                  });
                                },
                                child: AnimatedContainer(
                                  curve: Curves.fastOutSlowIn,
                                  duration: Duration(milliseconds: 500),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                    color: goalActivityValue == 3
                                        ? selectedColor
                                        : unselectedColor,
                                  ),
                                  padding: EdgeInsets.all(16),
                                  margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  child: Icon(
                                    ActivityInfo.activity4Icon,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    goalActivityValue = 4;
                                    FocusScope.of(context).unfocus();
                                  });
                                },
                                child: AnimatedContainer(
                                  curve: Curves.fastOutSlowIn,
                                  duration: Duration(milliseconds: 500),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                    color: goalActivityValue == 4
                                        ? selectedColor
                                        : unselectedColor,
                                  ),
                                  padding: EdgeInsets.all(16),
                                  margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  child: Icon(
                                    ActivityInfo.activity5Icon,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Goal',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: ThemeColors.mediumBlue,
                                      fontSize: 16.0),
                                ),
                                SizedBox(width: 10.0),
                                Text(
                                  'Period',
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
                      Container(
                        padding: EdgeInsets.only(top: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  goalTimeFrameValue = 0;
                                  FocusScope.of(context).unfocus();
                                });
                              },
                              child: AnimatedContainer(
                                curve: Curves.fastOutSlowIn,
                                duration: Duration(milliseconds: 500),
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                                  color: goalTimeFrameValue == 0
                                      ? selectedColor
                                      : unselectedColor,
                                ),
                                padding: EdgeInsets.all(16),
                                margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                child: Text(
                                  "Weekly",
                                  style:  TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.white,
                                      fontSize: 14.0),
                                ),
                                ),
                              ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  goalTimeFrameValue = 1;
                                  FocusScope.of(context).unfocus();
                                });
                              },
                              child: AnimatedContainer(
                                curve: Curves.fastOutSlowIn,
                                duration: Duration(milliseconds: 500),
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                                  color: goalTimeFrameValue == 1
                                      ? selectedColor
                                      : unselectedColor,
                                ),
                                padding: EdgeInsets.all(16),
                                margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                child:  Text(
                                  "Monthly",
                                  style:  TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.white,
                                      fontSize: 14.0),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  goalTimeFrameValue = 2;
                                  FocusScope.of(context).unfocus();
                                });
                              },
                              child: AnimatedContainer(
                                curve: Curves.fastOutSlowIn,
                                duration: Duration(milliseconds: 500),
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                                  color: goalTimeFrameValue == 2
                                      ? selectedColor
                                      : unselectedColor,
                                ),
                                padding: EdgeInsets.all(16),
                                margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                child:  Text(
                                  "Annual",
                                  style:  TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.white,
                                      fontSize: 14.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Goal',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: ThemeColors.mediumBlue,
                                      fontSize: 16.0),
                                ),
                                SizedBox(width: 10.0),
                                Text(
                                  'Type',
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
                      Container(
                        padding: EdgeInsets.only(top: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  goalTypeValue = 0;
                                  FocusScope.of(context).unfocus();
                                });
                              },
                              child: AnimatedContainer(
                                curve: Curves.fastOutSlowIn,
                                duration: Duration(milliseconds: 500),
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                                  color: goalTypeValue == 0
                                      ? selectedColor
                                      : unselectedColor,
                                ),
                                padding: EdgeInsets.all(16),
                                margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                child: Text(
                                  "Distance",
                                  style:  TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.white,
                                      fontSize: 14.0),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  goalTypeValue = 1;
                                  FocusScope.of(context).unfocus();
                                });
                              },
                              child: AnimatedContainer(
                                curve: Curves.fastOutSlowIn,
                                duration: Duration(milliseconds: 500),
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                                  color: goalTypeValue == 1
                                      ? selectedColor
                                      : unselectedColor,
                                ),
                                padding: EdgeInsets.all(16),
                                margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                child:  Text(
                                  "Time",
                                  style:  TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.white,
                                      fontSize: 14.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(32, 0, 0, 16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        bottomLeft: Radius.circular(32.0)),
                  ),
                  alignment: Alignment.topRight,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 16, bottom: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Goal',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: ThemeColors.mediumBlue,
                                      fontSize: 16.0),
                                ),
                                SizedBox(width: 10.0),
                                Text(
                                  'Target Value',
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
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: TextFormField(
                              onEditingComplete: () => FocusScope.of(context).unfocus(),
                              inputFormatters: <TextInputFormatter>[
                                //FilteringTextInputFormatter.digitsOnly
                              ],
                              onChanged: (String enteredDistance) => {
                                setState(() {
                                  selectedGoalValue = int.parse(enteredDistance);
                                  _goalValueController.value =
                                      TextEditingValue(text: enteredDistance);
                                })
                              },
                              controller: _goalValueController,
                              keyboardType: TextInputType.numberWithOptions(),
                              decoration: InputDecoration.collapsed(
                                hintText: goalTypeValue == 0
                                    ? 'Enter Distance'
                                    : 'Enter Duration',
                                hintStyle: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: ThemeColors.mediumBlue,
                                      fontSize: 12.0),
                              ),
                              textInputAction: TextInputAction.done,
                              cursorColor: ThemeColors.mediumBlue,
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: ThemeColors.mediumBlue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0),
                            ),
                          ),
                          Text(
                              goalTypeValue == 0
                                  ? 'km'
                                  : 'hours',
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
                GestureDetector(
                  onTap: () => saveEntries(),
                  child: Container(
                    alignment: Alignment.bottomRight,
                    margin: EdgeInsets.only(left: MediaQuery.of(context).size.width / 1.5, bottom: 32),
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(32), bottomLeft: Radius.circular(32)),
                      color: ThemeColors.mediumBlue
                    ),
                    child:Text(
                      'Save',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                          fontSize: 16.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Method to format a given duration
  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  /// Method to save the entries on the screen
  Future<void> saveEntries() async {
    ActivityGoal newGoal = ActivityGoal(
        DateTime.now().hashCode,
        selectedGoalValue,
        selectedTitle,
        goalTypeValue,
        goalActivityValue,
        goalTimeFrameValue);

    setState(() {});

    DatabaseManager dbManager = new DatabaseManager();
    int success = await dbManager.saveGoal(newGoal);

    showSnackBar(success == 0 ? false : true);
  }

  /// Method to get the data from the database
  Future<List<ActivityGoal>> getGoalData() async {
    DatabaseManager dbManager = new DatabaseManager();
    List<ActivityGoal> goals = await dbManager.getGoals();

    return goals;
  }

  /// Method to show the snack bar
  void showSnackBar(bool success) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: success
            ? Colors.green
            : Colors.red, // Set color depending on success
        content: success
            ? const Text(
                'New goal has been set.',
                style: TextStyle(color: Colors.white),
              )
            : const Text(
                'There has been a problem while saving your goal.',
                style: TextStyle(color: Colors.white),
              ),
        //action: SnackBarAction(
        //    label: 'DISMISS', onPressed: ,),
      ),
    );
  }
}
