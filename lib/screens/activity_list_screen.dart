import 'package:data_visualization_app/models/recorded_activity.dart';
import 'package:data_visualization_app/screens/modify_data_screen.dart';
import 'package:data_visualization_app/screens/welcome_screen.dart';
import 'package:data_visualization_app/services/database_manager.dart';
import 'package:data_visualization_app/theme.dart';
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
        backgroundColor: ThemeColors.yellowGreenish,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: ThemeColors.darkBlue,
          ),
          onPressed: () {
            Navigator.popAndPushNamed(context, WelcomeScreen.routeName);
          },
        ),
        title: Row(
          children: [
            Text(
              'Recent',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: ThemeColors.darkBlue,
                  fontSize: 25.0),
            ),
            SizedBox(width: 10.0),
            Text(
              'Activities',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: ThemeColors.darkBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<RecordedActivity>>(
        future: getActivityData(),
        builder: (context, AsyncSnapshot<List<RecordedActivity>> snapshot) {
          if (snapshot.hasData) {
            return Container(
              padding: EdgeInsets.only(top: 2, bottom: 2),
                color: ThemeColors.yellowGreenish,
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
                              /// Open ModifyActivityScreen
                              Navigator.pop(context);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ModifyDataScreen(
                                      snapshot.data[index])));
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
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                        elevation: 4,
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
                                snapshot.data[index].activityType == "Climbing" ? Text("\t\t\tDistance: - km", style: GoogleFonts.montserrat(
                                    color: Colors.white),) : Text("\t\t\tDistance: " + snapshot.data[index].distance.toString()+ " km", style: GoogleFonts.montserrat(
                                    color: Colors.white),),
                              ],
                            ),
                          ),
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
      case "Running": typeIcon = Icon(Icons.directions_run, color: ThemeColors.lightBlue,);
      break;
      case "Cycling": typeIcon = Icon(Icons.directions_bike, color: ThemeColors.orange,);
      break;
      case "Climbing": typeIcon = Icon(Icons.filter_hdr, color: ThemeColors.yellowGreenish,);
      break;
      default: typeIcon = Icon(Icons.directions_run, color: ThemeColors.lightBlue,);
    }

    return typeIcon;
  }
}
