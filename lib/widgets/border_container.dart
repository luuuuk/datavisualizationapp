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

  AnimationController _controller;
  Animation _animation;
  CurvedAnimation _curve;

  @override
  void initState() {

    ///An animation controller lets you control the
    ///duration of an animation
    ///Here the ticker for vsync provider is provided
    ///by the SingleTickerProviderStateMixin
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    ///Providing our animation with a curve (Parent here is the controller
    ///above)
    _curve = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    ///Creating a Tween animation with start and end values for the
    ///opacity and providing it with our animation controller
    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_curve);

    super.initState();
  }

  @override
  void dispose() {
    ///Don't forget to clean up resources when you are done using it
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showDetails = !showDetails;
          showDetails ? _controller.forward() : _controller.reverse();
        });
      },
      child: Container(
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
        child: AnimatedSize(
          vsync: this,
          duration: Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
          child: showDetails
              ? FadeTransition(
            opacity: _animation,
                child: Column(
                    children: [
                      Container(
                        alignment: alignmentRight
                            ? Alignment.topRight
                            : Alignment.topLeft,
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
                  ),
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
      ),
    );
  }
}
