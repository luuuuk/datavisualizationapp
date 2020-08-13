import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme.dart';

/// Widget with a 2 points border surrounding other content given by the [child]
class BorderContainerWidget extends StatelessWidget{

  final Widget child;
  final String title;
  final bool alignmentRight;

  BorderContainerWidget(this.child, this.title, this.alignmentRight);

  @override
  Widget build(BuildContext context) {
   return Container(
     margin: alignmentRight ? EdgeInsets.only(left: 32) : EdgeInsets.only(right: 32),
       padding: EdgeInsets.fromLTRB(0, 32, 0, 32),
       decoration: BoxDecoration(
           color: !alignmentRight ? ThemeColors.yellowGreenish : ThemeColors.blueGreenis,
           borderRadius: alignmentRight ? BorderRadius.only(topLeft: Radius.circular(80), bottomLeft: Radius.circular(80))
               : BorderRadius.only(topRight: Radius.circular(80), bottomRight: Radius.circular(80))),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.stretch,
         children: [
           Container(
             alignment: alignmentRight ? Alignment.topRight : Alignment.topLeft,
             padding: alignmentRight ? EdgeInsets.only(right: 16) : EdgeInsets.only(left: 16),
             child: Text(title, style: TextStyle(
                 fontFamily: 'Montserrat',
                 color: ThemeColors.darkBlue,
                 fontWeight: FontWeight.bold,
                 fontSize: 18.0),),
           ),
           Container(
             margin: EdgeInsets.fromLTRB(0, 32, 0, 0),
             child: child,
           ),
         ],
       ),
   );
  }

}