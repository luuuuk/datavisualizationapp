import 'package:data_visualization_app/screens/activity_list_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

class BottomBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: ThemeColors.lightBlue,
      shape: CircularNotchedRectangle(),
      notchMargin: 4.0,
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 64,
        child: Column(
          children: [
            IconButton(
              icon: Icon(
                Icons.list,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, ActivityListScreen.routeName);
              },
            ),
            Text("Activity List", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 10),)
          ],
        ),
      ),
    );
  }
}
