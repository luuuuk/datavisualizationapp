import 'package:data_visualization_app/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class GoalWidget extends StatelessWidget{

  final double goalNumber;
  final double currentNumber;
  final String goalTitle;

  GoalWidget(this.goalNumber, this.currentNumber, this.goalTitle);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ThemeColors.blueGreenis,
      elevation: 4.0,
      child: Container(
        padding: EdgeInsets.all(8),
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(goalTitle, style: GoogleFonts.montserrat(color: Colors.white, fontSize: 12),),
                Text(currentNumber.toStringAsPrecision(2) + "/" + goalNumber.toStringAsPrecision(2) + " km", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 12),),
              ],
            ),
            Container(padding: EdgeInsets.all(8.0),),
            LinearPercentIndicator(
              lineHeight: 14.0,
              percent: 0.5,
              center: Text(
                (goalNumber/currentNumber).toStringAsPrecision(2) + "%",
                style: new TextStyle(fontSize: 12.0),
              ),
              trailing: Icon(Icons.directions_run, color: ThemeColors.lightBlue,),
              linearStrokeCap: LinearStrokeCap.roundAll,
              backgroundColor: Colors.grey,
              progressColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

}