import 'package:data_visualization_app/router.dart';
import 'package:data_visualization_app/screens/activity_list_screen.dart';
import 'package:data_visualization_app/screens/add_data_screen.dart';
import 'package:data_visualization_app/screens/goals_screen.dart';
import 'package:data_visualization_app/screens/test_screen.dart';
import 'package:data_visualization_app/screens/welcome_screen.dart';
import 'package:data_visualization_app/theme.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Visualizer',
      debugShowCheckedModeBanner: false,
      theme: VisualizationTheme().theme,
      initialRoute: WelcomeScreen.routeName,
      onGenerateRoute: (settings) => RouterProvider().getRoute(settings),
    );
  }
}
