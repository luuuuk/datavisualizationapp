import 'package:data_visualization_app/theme.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  static const routeName = '/WelcomeScreen';
  @override
  _WelcomeScreenState createState() => new _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.blueGreenis,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 3,
            decoration: BoxDecoration(
              color: ThemeColors.darkBlue,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(120.0)),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Your',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                          fontSize: 25.0)),
                  SizedBox(width: 10.0),
                  Text('Statistics',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0))
                ],
              ),
            ),
          ),
          Container(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Add',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                          fontSize: 25.0)),
                  SizedBox(width: 10.0),
                  Text('new activity',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0))
                ],
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 3,
            decoration: BoxDecoration(
              color: ThemeColors.yellowGreenish,
              borderRadius: BorderRadius.only(topRight: Radius.circular(120.0)),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Recent',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: ThemeColors.darkBlue,
                          fontSize: 25.0)),
                  SizedBox(width: 10.0),
                  Text('Activities',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: ThemeColors.darkBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
