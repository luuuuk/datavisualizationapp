import 'package:data_visualization_app/screens/activity_list_screen.dart';
import 'package:data_visualization_app/screens/add_data_screen.dart';
import 'package:data_visualization_app/screens/add_goal_screen.dart';
import 'package:data_visualization_app/screens/goals_screen.dart';
import 'package:data_visualization_app/screens/home_screen.dart';
import 'package:data_visualization_app/screens/modify_data_screen.dart';
import 'package:data_visualization_app/screens/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:page_transition/page_transition.dart';

class RouterProvider {

  getRoute(RouteSettings settings){
    switch (settings.name) {
      case WelcomeScreen.routeName:
        return PageTransition(child: WelcomeScreen(), type: PageTransitionType.fade);
        break;
      case HomeScreen.routeName:
        return PageTransition(child: HomeScreen(), type: PageTransitionType.fade);
        break;
      case AddDataScreen.routeName:
        return PageTransition(child: AddDataScreen(), type: PageTransitionType.rightToLeft);
        break;
      case GoalsScreen.routeName:
        return PageTransition(child: GoalsScreen(), type: PageTransitionType.fade);
        break;
      case ModifyDataScreen.routeName:
        return PageTransition(child: ModifyDataScreen(settings.arguments), type: PageTransitionType.fade);
        break;
      case ActivityListScreen.routeName:
        return PageTransition(child: ActivityListScreen(), type: PageTransitionType.fade);
        break;
        case AddGoalScreen.routeName:
        return PageTransition(child: AddGoalScreen(), type: PageTransitionType.downToUp);
        break;
      default:
        return null;
    }
  }

}