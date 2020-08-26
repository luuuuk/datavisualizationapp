import 'package:data_visualization_app/models/recorded_activity.dart';
import 'package:data_visualization_app/screens/add_data_screen.dart';
import 'package:data_visualization_app/screens/modify_data_screen.dart';
import 'package:data_visualization_app/screens/welcome_screen.dart';
import 'package:data_visualization_app/services/database_manager.dart';
import 'package:data_visualization_app/theme.dart';
import 'package:dotted_border/dotted_border.dart';
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
      resizeToAvoidBottomPadding: false,
      key: _key,
      body: FutureBuilder<List<RecordedActivity>>(
        future: getActivityData(),
        builder: (context, AsyncSnapshot<List<RecordedActivity>> snapshot) {
          if (snapshot.hasData) {
            return Container(
              padding: EdgeInsets.only(top: 32),
                color: ThemeColors.darkGrey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
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
                                    'Activities',
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
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AddDataScreen.routeName).then((value) {
                            setState(() {

                            });
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(8,8,8,0),
                          child: DottedBorder(
                            padding: EdgeInsets.all(8),
                            borderType: BorderType.RRect,
                            radius: Radius.circular(16),
                            color: Colors.white,
                            child: ListTile(
                              leading: Icon(Icons.add_circle_outline, color: Colors.white, size: 32,),
                              title: Row(
                                children: [
                                  Text(
                                    'Add',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Colors.white,
                                        fontSize: 18.0),
                                  ),
                                  SizedBox(width: 10.0),
                                  Text(
                                    'New Activity',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
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
                                    /// Open ModifyActivityScreen
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => ModifyDataScreen(
                                            snapshot.data[index]))).then((value) {
                                              setState(() {});
                                    });
                                  }),
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
                            child: Card(
                              margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                              elevation: 0,
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: ThemeColors.darkBlue,
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: ListTile(
                                  leading: _getActivityIcon(snapshot.data[index]),
                                  title: Text(snapshot.data[index].activityType + " " + snapshot.data[index].date, style: GoogleFonts.montserrat(
                                      color: Colors.white),),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Text("\t\t\tDuration: " + snapshot.data[index].duration, style: GoogleFonts.montserrat(
                                          color: Colors.white),),
                                      snapshot.data[index].activityType == ActivityInfo.activity3Name ? Text("\t\t\tDistance: - km", style: GoogleFonts.montserrat(
                                          color: Colors.white),) : Text("\t\t\tDistance: " + snapshot.data[index].distance.toString()+ " km", style: GoogleFonts.montserrat(
                                          color: Colors.white),),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ));
          } else {
            return Container(
                padding: EdgeInsets.only(top: 32),
                color: ThemeColors.darkGrey,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
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
                                  'Activities',
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
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AddDataScreen.routeName);
                      },
                      child: Container(
                        margin: EdgeInsets.all(8),
                        child: DottedBorder(
                          padding: EdgeInsets.all(8),
                          borderType: BorderType.RRect,
                          radius: Radius.circular(16),
                          color: Colors.white,
                          child: ListTile(
                            leading: Icon(Icons.add_circle_outline, color: Colors.white, size: 32,),
                            title: Row(
                              children: [
                                Text(
                                  'Add',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.white,
                                      fontSize: 18.0),
                                ),
                                SizedBox(width: 10.0),
                                Text(
                                  'New Activity',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ));
          }
        },
      ),
    );
  }

  /// Method to get the data from the database
  Future<List<RecordedActivity>> getActivityData() async {
    DatabaseManager dbManager = new DatabaseManager();
    List<RecordedActivity> activities = await dbManager.getActivities();

    activities.sort((a,b) {
      List<String> splittedDateA = a.date.split(".");
      List<String> splittedDateB = b.date.split(".");
      DateTime dateA = DateTime(int.parse(splittedDateA[2]),int.parse(splittedDateA[1]),int.parse(splittedDateA[0]));
      DateTime dateB = DateTime(int.parse(splittedDateB[2]),int.parse(splittedDateB[1]),int.parse(splittedDateB[0]));
      return -dateA.compareTo(dateB);
    });

    return activities;
  }

  /// Method to handle deleting of the specified [activity]
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

  /// Method to return an icon which matches the type of the specified [activity]
  Widget _getActivityIcon(RecordedActivity activity){

    Icon typeIcon;

    switch(activity.activityType){
      case ActivityInfo.activity1Name: typeIcon = Icon(ActivityInfo.activity1Icon, color: ThemeColors.lightBlue,);
      break;
      case ActivityInfo.activity2Name: typeIcon = Icon(ActivityInfo.activity2Icon, color: ThemeColors.orange,);
      break;
      case ActivityInfo.activity3Name: typeIcon = Icon(ActivityInfo.activity3Icon, color: ThemeColors.yellowGreenish,);
      break;
      case ActivityInfo.activity4Name: typeIcon = Icon(ActivityInfo.activity4Icon, color: ThemeColors.blueGreenisShade2,);
      break;
      default: typeIcon = Icon(ActivityInfo.activity1Icon, color: ThemeColors.lightBlue,);
    }

    return typeIcon;
  }
}
