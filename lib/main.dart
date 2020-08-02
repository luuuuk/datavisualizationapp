import 'package:data_visualization_app/screens/activity_list_screen.dart';
import 'package:data_visualization_app/screens/add_data_screen.dart';
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
      debugShowCheckedModeBanner: false,
      theme: VisualizationTheme().theme,
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        AddDataScreen.routeName: (context) => AddDataScreen(),
        ActivityListScreen.routeName: (context) => ActivityListScreen(),
      },
    );
  }
}
