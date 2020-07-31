import 'package:data_visualization_app/screens/add_data_screen.dart';
import 'package:data_visualization_app/theme.dart';
import 'package:data_visualization_app/widgets/border_container.dart';
import 'package:data_visualization_app/widgets/bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/';
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool hasData = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        color: ThemeColors.darkBlue,
        child: Center(
            child: hasData
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BorderContainerWidget(
                        Center(
                          child: Text(
                            "Here goes your data",
                            style:
                            GoogleFonts.montserrat(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        "Here goes your title",
                      ),
                    ],
                  )
                : Center(
                    child: Text(
                      "You have not yet entered any data to be displayed. \nStart by using the button down here in the right corner.",
                      style: GoogleFonts.montserrat(color: Colors.white, ),
                      textAlign: TextAlign.center,
                    ),
                  )),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ThemeColors.orange,
        onPressed: () {
          Navigator.pushNamed(context, AddDataScreen.routeName);
        },
        tooltip: 'Add data',
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomBarWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
