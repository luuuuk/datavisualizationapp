import 'package:data_visualization_app/widgets/border_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme.dart';

class AddDataScreen extends StatefulWidget {
  static const routeName = '/AddDataScreen';
  @override
  _AddDataScreenState createState() => new _AddDataScreenState();
}

class _AddDataScreenState extends State<AddDataScreen> {
  DateTime dateTime;
  bool _visible;
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
  var segmentedControlGroupValue;
  TextEditingController _dateController = new TextEditingController();
  TextEditingController _timeController = new TextEditingController();
  DateTime selectedDate = DateTime.now();
  Duration selectedDuration = new Duration();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: ThemeColors.darkBlue,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: ThemeColors.blueGreenis,
        title: Text(
          "Add Data",
          style: GoogleFonts.montserrat(color: ThemeColors.darkBlue),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: ThemeColors.darkBlue,
        child: Expanded(
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
                          Icons.dialpad,
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
                          Icons.dialpad,
                          color: ThemeColors.orange,
                        ),
                      ),
                    ),
                  ),
                ),
                "Duration",
              ),
            ],
          ),
        ),
      ),
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
                  _dateController.value = TextEditingValue(text: selectedDate.toString());
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
                  _timeController.value = TextEditingValue(text: selectedDuration.toString());
                });
              },
            ),
          );
        });
  }
}
