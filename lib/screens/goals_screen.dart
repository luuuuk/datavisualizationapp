import 'package:data_visualization_app/models/activity_goal.dart';
import 'package:data_visualization_app/models/recorded_activity.dart';
import 'package:data_visualization_app/services/database_manager.dart';
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
  TextEditingController _goalValueController = new TextEditingController();
  TextEditingController _goalTitleController = new TextEditingController();
  bool isClimbing = false;
  int selectedGoalValue = 0;
  String selectedTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: ThemeColors.lightBlue,
        title: Text(
          "Your Goals",
          style: GoogleFonts.montserrat(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: ThemeColors.darkBlue,
        child: ListView(
          shrinkWrap: true,
          children: [
            FutureBuilder<List<ActivityGoal>>(
                future: getGoalData(),
                builder: (context, AsyncSnapshot<List<ActivityGoal>> snapshot) {
                  if (snapshot.hasData) {
                    return BorderContainerWidget(
                            Container(
                              height: 110,
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
                                        width: MediaQuery.of(context).size.width * 0.7,
                                        height: 110,
                                        child: GoalWidget(
                                            snapshot.data[index].goalNumber.toDouble(),
                                            0,
                                            snapshot.data[index].goalTitle,
                                            snapshot.data[index].goalType,
                                            snapshot.data[index].activityType),
                                      ),
                                    );
                                  }),
                            ),
                        "Your Goals");
                  } else {
                    return BorderContainerWidget(
                        Container(
                          height: 80,
                          child: Center(
                            child: Text("No goals defined."),
                          ),
                        ),
                        "Your Goals");
                  }
                }),
            BorderContainerWidget(
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                child: CupertinoSlidingSegmentedControl(
                    backgroundColor: ThemeColors.lightBlue,
                    groupValue: segmentedActivityGroupValue,
                    children: activityType,
                    thumbColor: ThemeColors.orange,
                    onValueChanged: (i) {
                      setState(() {
                        segmentedActivityGroupValue = i;
                        i == 2 ? isClimbing = true : isClimbing = false;
                      });
                    }),
              ),
              "Activity Type",
            ),
            BorderContainerWidget(
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                child: CupertinoSlidingSegmentedControl(
                    backgroundColor: ThemeColors.lightBlue,
                    groupValue: segmentedGoalGroupValue,
                    children: goalType,
                    thumbColor: ThemeColors.orange,
                    onValueChanged: (i) {
                      setState(() {
                        segmentedGoalGroupValue = i;
                      });
                    }),
              ),
              "Goal Type",
            ),
            BorderContainerWidget(
              Container(
                child: CupertinoSlidingSegmentedControl(
                    backgroundColor: ThemeColors.lightBlue,
                    groupValue: segmentedTimeFrameGroupController,
                    children: timeFrame,
                    thumbColor: ThemeColors.orange,
                    onValueChanged: (i) {
                      setState(() {
                        segmentedTimeFrameGroupController = i;
                      });
                    }),
              ),
              "Goal Time Span",
            ),
            BorderContainerWidget(
              TextFormField(
                onChanged: (String enteredDistance) => {
                  setState(() {
                    selectedGoalValue = int.parse(enteredDistance);
                    _goalValueController.value =
                        TextEditingValue(text: enteredDistance);
                  })
                },
                controller: _goalValueController,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  hintText:
                      segmentedGoalGroupValue == 0 ? 'Distance in km' : 'Duration in h',
                  prefixIcon: Icon(
                    Icons.flag,
                    color: ThemeColors.orange,
                  ),
                ),
              ),
              segmentedGoalGroupValue == 0 ? "Distance in km" : "Duration in h",
            ),
            BorderContainerWidget(
              TextFormField(
                onChanged: (String enteredTitle) => {
                  setState(() {
                    selectedTitle = enteredTitle;
                    _goalTitleController.value =
                        TextEditingValue(text: enteredTitle);
                  })
                },
                controller: _goalTitleController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Title',
                  prefixIcon: Icon(
                    Icons.text_fields,
                    color: ThemeColors.orange,
                  ),
                ),
              ),
              "Title",
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 24, 0, 0),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ThemeColors.orange,
        onPressed: () => saveEntries(),
        tooltip: 'Save data',
        child: Icon(
          Icons.save,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
        segmentedGoalGroupValue,
        segmentedActivityGroupValue,
        segmentedTimeFrameGroupController);

    setState(() {

    });

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

  /// Method to handle deleting of the specified [activity]
  void deleteData(ActivityGoal goal) {
    DatabaseManager dbManager = new DatabaseManager();
    dbManager.deleteGoal(goal);
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
                'Activity has been saved.',
                style: TextStyle(color: Colors.white),
              )
            : const Text(
                'There has been a problem while saving your activity.',
                style: TextStyle(color: Colors.white),
              ),
        //action: SnackBarAction(
        //    label: 'DISMISS', onPressed: ,),
      ),
    );
  }
}
