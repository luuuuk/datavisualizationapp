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

class _BorderContainerWidgetState extends State<BorderContainerWidget>
    with TickerProviderStateMixin {
  final Widget child;
  final String title;
  final bool alignmentRight;
  bool showDetails = false;

  _BorderContainerWidgetState(this.child, this.title, this.alignmentRight);


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(32),
        padding: EdgeInsets.fromLTRB(0,16,0,16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
        child: AnimatedSize(
          vsync: this,
          duration: Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
          child: Column(
            children: [
              Container(
                alignment: Alignment.topRight,
                padding: EdgeInsets.only(right: 32, top: 8),
                child: Text(
                  title,
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: alignmentRight ? ThemeColors.darkBlue : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 32, 0, 0),
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
