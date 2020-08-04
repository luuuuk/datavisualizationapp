import 'package:data_visualization_app/models/recorded_activity.dart';
import 'package:data_visualization_app/services/database_manager.dart';
import 'package:data_visualization_app/theme.dart';
import 'package:data_visualization_app/widgets/border_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityListScreen extends StatefulWidget {
  static const routeName = '/ActivityListScreen';
  @override
  _ActivityListScreenState createState() => new _ActivityListScreenState();
}

class _ActivityListScreenState extends State<ActivityListScreen> {
  GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        backgroundColor: ThemeColors.lightBlue,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Activity List",
          style: GoogleFonts.montserrat(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: FutureBuilder<List<RecordedActivity>>(
          future: getActivityData(),
          builder: (context, AsyncSnapshot<List<RecordedActivity>> snapshot) {
            if (snapshot.hasData) {
              return Container(
                  color: ThemeColors.darkBlue,
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            caption: 'Edit',
                            color: Colors.amberAccent,
                            icon: Icons.edit,
                            onTap: () {
                              /// Open EditActivityScreen
                            },
                          ),
                          IconSlideAction(
                            caption: 'Delete',
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () {
                              setState(() {
                                deleteData(snapshot.data[index]);
                                snapshot.data.removeAt(index);
                              });
                            },
                          ),
                        ],
                        child: Container(
                          padding: EdgeInsets.all(5.0),
                          child: BorderContainerWidget(
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Date: " + snapshot.data[index].date,
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white),
                                ),
                                Divider(
                                  color: ThemeColors.lightBlue,
                                  thickness: 1.0,
                                ),
                                Text(
                                  "Duration: " + snapshot.data[index].duration,
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white),
                                ),
                                Divider(
                                  color: ThemeColors.lightBlue,
                                  thickness: 1.0,
                                ),
                                Text(
                                  "Distance: " +
                                      snapshot.data[index].distance.toString() +
                                      " km",
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white),
                                ),
                              ],
                            ),
                            "Activity: " + snapshot.data[index].activityType,
                          ),
                        ),
                      );
                    },
                  ));
            } else {
              return Center(
                child: Text(
                  "You have not yet entered any data to be displayed. \nStart getting active now!",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }
          },
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

  void deleteData(RecordedActivity activity) {
    DatabaseManager dbManager = new DatabaseManager();
    dbManager.deleteActivity(activity);
  }

  /// Method to show the snack bar
  void showSnackBar() {
    _key.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.red, // Set color depending on success
        content: const Text(
          'Activity has been deleted.',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
