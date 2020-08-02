import 'package:data_visualization_app/models/recorded_activity.dart';
import 'package:data_visualization_app/services/database_manager.dart';
import 'package:data_visualization_app/widgets/border_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../theme.dart';

class AddDataScreen extends StatefulWidget {
  static const routeName = '/AddDataScreen';
  @override
  _AddDataScreenState createState() => new _AddDataScreenState();
}

class _AddDataScreenState extends State<AddDataScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DateTime dateTime;
  final Map<int, Widget> type = <int, Widget>{
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
  int segmentedControlGroupValue = 0;
  TextEditingController _dateController = new TextEditingController();
  TextEditingController _timeController = new TextEditingController();
  TextEditingController _distanceController = new TextEditingController();
  DateTime selectedDate = DateTime.now();
  Duration selectedDuration = new Duration();
  bool isClimbing = false;
  int selectedDistance = 0;

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
          "Add Data",
          style: GoogleFonts.montserrat(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: ThemeColors.darkBlue,
        child: ListView(
          children: [
            BorderContainerWidget(
              CupertinoSlidingSegmentedControl(
                  backgroundColor: ThemeColors.lightBlue,
                  groupValue: segmentedControlGroupValue,
                  children: type,
                  thumbColor: ThemeColors.orange,
                  onValueChanged: (i) {
                    setState(() {
                      segmentedControlGroupValue = i;
                      i == 2 ? isClimbing = true : isClimbing = false;
                    });
                  }),
              "Activity Type",
            ),
            BorderContainerWidget(
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _dateController,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      hintText: 'Activity Date',
                      prefixIcon: Icon(
                        Icons.calendar_today_outlined,
                        color: ThemeColors.orange,
                      ),
                    ),
                  ),
                ),
              ),
              "Date",
            ),
            BorderContainerWidget(
              GestureDetector(
                onTap: () => _selectTime(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _timeController,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      hintText: 'Activity Duration',
                      prefixIcon: Icon(
                        Icons.timelapse,
                        color: ThemeColors.orange,
                      ),
                    ),
                  ),
                ),
              ),
              "Duration",
            ),
            AnimatedOpacity(
              duration: Duration(seconds: 1),
              opacity: isClimbing ? 0.0 : 1.0,
              child: BorderContainerWidget(
                TextFormField(
                  onChanged: (String enteredDistance) => {
                    setState(() {
                      selectedDistance = int.parse(enteredDistance);
                      _distanceController.value = TextEditingValue(text: enteredDistance);
                    })
                  },
                  controller: _distanceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Activity Distance',
                    prefixIcon: Icon(
                      Icons.add_road_outlined,
                      color: ThemeColors.orange,
                    ),
                  ),
                ),
                "Distance",
              ),
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

  /// Method to provide a DatePicker to select a date
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            child: CupertinoDatePicker(
              initialDateTime: DateTime.now(),
              onDateTimeChanged: (DateTime newdate) {
                setState(() {
                  selectedDate = newdate;
                  _dateController.value = TextEditingValue(
                      text: DateFormat('dd.MM.yyyy').format(selectedDate));
                });
              },
              minimumYear: 2000,
              maximumYear: 2100,
              minuteInterval: 1,
              mode: CupertinoDatePickerMode.date,
            ),
          );
        });
  }

  /// Method to provide a TimePicker to select a duration
  Future<Null> _selectTime(BuildContext context) async {
    final Duration picked = await showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            child: CupertinoTimerPicker(
              mode: CupertinoTimerPickerMode.hms,
              minuteInterval: 1,
              secondInterval: 1,
              initialTimerDuration: selectedDuration,
              onTimerDurationChanged: (Duration changedtimer) {
                setState(() {
                  selectedDuration = changedtimer;
                  _timeController.value =
                      TextEditingValue(text: format(changedtimer));
                });
              },
            ),
          );
        });
  }

  /// Method to format a given duration
  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  /// Method to save the entries on the screen
  Future<void> saveEntries() async {
    String activityType;
    switch(segmentedControlGroupValue){
      case 0: activityType = "Running";
      break;
      case 1: activityType = "Cycling";
      break;
      case 2: activityType = "Climbing";
      break;
      default: activityType = "Running";
    }

    RecordedActivity newActivity = RecordedActivity(activityType, DateFormat('dd.MM.yyyy').format(selectedDate).toString(), format(selectedDuration).toString(), selectedDistance);

    DatabaseManager dbManager = new DatabaseManager();
    int success = await dbManager.saveActivity(newActivity);

    showSnackBar(success == 0 ? false : true);

    List<RecordedActivity> activities = await dbManager.getActivities();


    for(RecordedActivity activity in activities){
      print(activity.toString());
    }
  }

  /// Method to show the snack bar
  void showSnackBar(bool success) {

    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: success ? Colors.green : Colors.red, // Set color depending on success
        content: success? const Text(
          'Activity has been saved.',
          style: TextStyle(color: Colors.white),
        )
            :const Text(
          'There has been a problem while saving your activity.',
          style: TextStyle(color: Colors.white),
        ),
        //action: SnackBarAction(
        //    label: 'DISMISS', onPressed: ,),
      ),
    );
  }
}
