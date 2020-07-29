import 'package:data_visualization_app/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/';
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ThemeColors.darkBlue,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.maxFinite,
                margin: EdgeInsets.fromLTRB(24, 24, 24, 0),
                decoration: BoxDecoration(
                    color: ThemeColors.lightBlue,
                    borderRadius: BorderRadius.circular(12)),
                padding: EdgeInsets.all(2.0),
                child: Container(
                    padding: EdgeInsets.all(18.0),
                    decoration: BoxDecoration(
                        color: ThemeColors.darkBlue,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "Enter fresh data",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
