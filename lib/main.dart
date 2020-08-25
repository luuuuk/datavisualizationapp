import 'package:data_visualization_app/router.dart';
import 'package:data_visualization_app/screens/welcome_screen.dart';
import 'package:data_visualization_app/theme.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Banana Stats',
      debugShowCheckedModeBanner: false,
      theme: VisualizationTheme().theme,
      initialRoute: WelcomeScreen.routeName,
      onGenerateRoute: (settings) => RouterProvider().getRoute(settings),
    );
  }
}
