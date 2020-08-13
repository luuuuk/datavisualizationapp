import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme.dart';

/// Widget with a 2 points border surrounding other content given by the [child]
class BorderContainerWidget extends StatefulWidget {
  final Widget child;
  final String title;
  final bool alignmentRight;

  BorderContainerWidget(this.child, this.title, this.alignmentRight);

  @override
  _BorderContainerWidgetState createState() =>
      new _BorderContainerWidgetState(child, title, alignmentRight);
}

class _BorderContainerWidgetState extends State<BorderContainerWidget> {
  final Widget child;
  final String title;
  final bool alignmentRight;
  bool showDetails = false;

  _BorderContainerWidgetState(this.child, this.title, this.alignmentRight);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showDetails = !showDetails;
        });
      },
      child: AnimatedContainer(
        duration: Duration(seconds: 2),
        curve: Curves.fastOutSlowIn,
        margin: alignmentRight
            ? EdgeInsets.only(left: 32)
            : EdgeInsets.only(right: 32),
        padding: EdgeInsets.fromLTRB(0, 32, 0, 32),
        decoration: BoxDecoration(
          color: !alignmentRight
              ? ThemeColors.yellowGreenish
              : ThemeColors.blueGreenis,
          borderRadius: alignmentRight
              ? BorderRadius.only(
                  topLeft: Radius.circular(80), bottomLeft: Radius.circular(80))
              : BorderRadius.only(
                  topRight: Radius.circular(80),
                  bottomRight: Radius.circular(80)),
        ),
        child: showDetails
            ? Column(
                children: [
                  Container(
                    alignment:
                        alignmentRight ? Alignment.topRight : Alignment.topLeft,
                    padding: alignmentRight
                        ? EdgeInsets.only(right: 16)
                        : EdgeInsets.only(left: 16),
                    child: Text(
                      title,
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: ThemeColors.darkBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 32, 0, 0),
                    child: child,
                  ),
                ],
              )
            : Container(
                alignment:
                    alignmentRight ? Alignment.topRight : Alignment.topLeft,
                padding: alignmentRight
                    ? EdgeInsets.only(right: 16)
                    : EdgeInsets.only(left: 16),
                child: Text(
                  title,
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: ThemeColors.darkBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0),
                ),
              ),
      ),
    );
  }
}
