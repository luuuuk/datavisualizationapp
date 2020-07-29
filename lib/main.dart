import 'package:data_visualization_app/theme.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Visualization',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: ThemeColors.darkBlue,
        accentColor: ThemeColors.yellowGreenish,

        // Define the default font family.
        fontFamily: 'Roboto',
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
      },
    );
  }
}
