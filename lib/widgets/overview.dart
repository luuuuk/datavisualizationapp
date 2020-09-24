import 'package:data_visualization_app/models/recorded_activity.dart';
import 'package:data_visualization_app/services/sorting_data.dart';
import 'package:data_visualization_app/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Class implementing a widget giving an overview over past activities.
/// Data is being given by [activities] whereas the [overviewCode] defines the
/// time period over which the overview is being given, 0: one week 1: one month
/// 2: one year
class OverviewWidget extends StatelessWidget {
  final List<RecordedActivity> activities;
  final int overviewCode;

  OverviewWidget(this.activities, this.overviewCode);

  @override
  Widget build(BuildContext context) {
    List<List<int>> dataList =
        SortingDataService().getOverviewData(activities, overviewCode);
    List<Icon> iconList = [
      Icon(
        ActivityInfo.activity1Icon,
        color: ThemeColors.darkBlue,
      ),
      Icon(
        ActivityInfo.activity2Icon,
        color: ThemeColors.orange,
      ),
      Icon(
        ActivityInfo.activity3Icon,
        color: ThemeColors.cream,
      ),
      Icon(
        ActivityInfo.activity4Icon,
        color: ThemeColors.blueGreenisShade1,
      )
    ];

    return SizedBox(
      height: 101,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    dataList[0][3].toString() + " x ",
                    style: GoogleFonts.montserrat(
                        color: ThemeColors.darkBlue, fontSize: 11),
                  ),
                  iconList[0],
                ],
              ),
              Container(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  dataList[0][0].toString() +
                      " h : " +
                      dataList[0][1].toString() +
                      " m",
                  style: GoogleFonts.montserrat(
                      color: ThemeColors.darkBlue, fontSize: 11),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  dataList[0][2].toString() + " km",
                  style: GoogleFonts.montserrat(
                      color: ThemeColors.darkBlue, fontSize: 11),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  dataList[0][3] == 0
                      ? "- km/act"
                      : (dataList[0][2] / dataList[0][3])
                              .toStringAsPrecision(3) +
                          " km/act",
                  style: GoogleFonts.montserrat(
                      color: ThemeColors.darkBlue, fontSize: 11),
                ),
              ),
            ],
          ),
          VerticalDivider(
            color: ThemeColors.darkBlue,
            thickness: 1,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    dataList[1][3].toString() + " x ",
                    style: GoogleFonts.montserrat(
                        color: ThemeColors.darkBlue, fontSize: 11),
                  ),
                  iconList[1],
                ],
              ),
              Container(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  dataList[1][0].toString() +
                      " h : " +
                      dataList[1][1].toString() +
                      " m",
                  style: GoogleFonts.montserrat(
                      color: ThemeColors.darkBlue, fontSize: 11),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  dataList[1][2].toString() + " km",
                  style: GoogleFonts.montserrat(
                      color: ThemeColors.darkBlue, fontSize: 11),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  dataList[1][3] == 0
                      ? "- km/act"
                      : (dataList[1][2] / dataList[1][3])
                              .toStringAsPrecision(3) +
                          " km/act",
                  style: GoogleFonts.montserrat(
                      color: ThemeColors.darkBlue, fontSize: 11),
                ),
              ),
            ],
          ),
          VerticalDivider(
            color: ThemeColors.darkBlue,
            thickness: 1,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    dataList[2][3].toString() + " x ",
                    style: GoogleFonts.montserrat(
                        color: ThemeColors.darkBlue, fontSize: 11),
                  ),
                  iconList[2],
                ],
              ),
              Container(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  dataList[2][0].toString() +
                      " h : " +
                      dataList[2][1].toString() +
                      " m",
                  style: GoogleFonts.montserrat(
                      color: ThemeColors.darkBlue, fontSize: 11),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  dataList[2][2].toString() + " km",
                  style: GoogleFonts.montserrat(
                      color: ThemeColors.darkBlue, fontSize: 11),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  dataList[2][3] == 0
                      ? "- h/act"
                      : ((dataList[2][0] + dataList[2][1]/60) / dataList[2][3])
                              .toStringAsPrecision(3) +
                          " h/act",
                  style: GoogleFonts.montserrat(
                      color: ThemeColors.darkBlue, fontSize: 11),
                ),
              ),
            ],
          ),
          VerticalDivider(
            color: ThemeColors.darkBlue,
            thickness: 1,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    dataList[3][3].toString() + " x ",
                    style: GoogleFonts.montserrat(
                        color: ThemeColors.darkBlue, fontSize: 11),
                  ),
                  iconList[3],
                ],
              ),
              Container(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  dataList[3][0].toString() +
                      " h : " +
                      dataList[3][1].toString() +
                      " m",
                  style: GoogleFonts.montserrat(
                      color: ThemeColors.darkBlue, fontSize: 11),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  dataList[3][2].toString() + " km",
                  style: GoogleFonts.montserrat(
                      color: ThemeColors.darkBlue, fontSize: 11),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  dataList[3][3] == 0
                      ? "- km/act"
                      : (dataList[3][2] / dataList[3][3])
                              .toStringAsPrecision(3) +
                          " km/act",
                  style: GoogleFonts.montserrat(
                      color: ThemeColors.darkBlue, fontSize: 11),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
