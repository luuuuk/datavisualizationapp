import 'package:data_visualization_app/screens/activity_list_screen.dart';
import 'package:data_visualization_app/screens/add_data_screen.dart';
import 'package:data_visualization_app/screens/goals_screen.dart';
import 'package:data_visualization_app/screens/home_screen.dart';
import 'package:data_visualization_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class WelcomeScreen extends StatefulWidget {
  static const routeName = '/WelcomeScreen';
  @override
  _WelcomeScreenState createState() => new _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  double _borderRadius = 120;

  AnimationController _container1controller;
  AnimationController _container2controller;
  AnimationController _container3controller;

  void initState() {
    super.initState();
    _container1controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
      lowerBound: 0,
      upperBound: 2000,
    );
    _container2controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
      lowerBound: 0,
      upperBound: 2000,
    );
    _container3controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
      lowerBound: 0,
      upperBound: 2000,
    );

    _container1controller.addListener(() {
      setState(() {});
    });
    _container2controller.addListener(() {
      setState(() {});
    });
    _container3controller.addListener(() {
      setState(() {});
    });

    _container1controller.animateTo(160);
    _container2controller.animateTo(180);
    _container3controller.animateTo(160);
  }

  void dispose() {
    _container1controller.dispose();
    _container2controller.dispose();
    _container3controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.darkGrey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              _container2controller.animateBack(0);
              _container3controller.animateBack(0);
              _container1controller
                  .animateTo(MediaQuery.of(context).size.height)
                  .whenComplete(() => Navigator.popAndPushNamed(
                      context, HomeScreen.routeName));
            },
            child: Container(
              height: _container1controller.value,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(_borderRadius)),
                color: ThemeColors.darkBlue,
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
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
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _container1controller.animateBack(0);
              _container3controller.animateBack(0);
              _container2controller
                  .animateTo(MediaQuery.of(context).size.height)
                  .whenComplete(() => Navigator.popAndPushNamed(
                  context, ActivityListScreen.routeName));
            },
            child: Container(
              height: _container2controller.value,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
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
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _container1controller.animateBack(0);
              _container2controller.animateBack(0);
              _container3controller
                  .animateTo(MediaQuery.of(context).size.height)
                  .whenComplete(() => Navigator.popAndPushNamed(
                  context, GoalsScreen.routeName));
            },
            child: Container(
              height: _container3controller.value,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.only(topRight: Radius.circular(_borderRadius)),
                color: ThemeColors.blueGreenisShade1,
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
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
              ),
            ),
          )
        ],
      ),
    );
  }
}
