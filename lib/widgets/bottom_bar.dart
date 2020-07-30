import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

class BottomBarWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: ThemeColors.darkBlue,
      shape: CircularNotchedRectangle(),
      notchMargin: 4.0,
      clipBehavior: Clip.antiAlias,
      child: BottomNavigationBar(
          backgroundColor: ThemeColors.blueGreenis,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.list,
                  color: ThemeColors.darkBlue,
                ),
                title: Text(
                  "List",
                  style: GoogleFonts.montserrat(color: ThemeColors.darkBlue),
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.edit,
                  color: ThemeColors.darkBlue,
                ),
                title: Text(
                  "Edit",
                  style: GoogleFonts.montserrat(color: ThemeColors.darkBlue),
                )),
          ]),
    );
  }

}