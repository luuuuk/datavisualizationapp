import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme.dart';

/// Widget with a 2 points border surrounding other content given by the [child]
class BorderContainerWidget extends StatelessWidget{

  final Widget child;
  final String title;

  BorderContainerWidget(this.child, this.title);

  @override
  Widget build(BuildContext context) {
   return Container(
     margin: EdgeInsets.fromLTRB(8, 16, 8, 0),
     decoration: BoxDecoration(
         color: ThemeColors.lightBlue,
         borderRadius: BorderRadius.circular(12)),
     padding: EdgeInsets.all(2.0),
     child: Container(
       padding: EdgeInsets.all(20.0),
       decoration: BoxDecoration(
           color: ThemeColors.darkBlue,
           borderRadius: BorderRadius.circular(10)),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.stretch,
         children: [
           Container(
             child: Text(title, style: GoogleFonts.montserrat(color: Colors.white, fontSize: 14),textAlign: TextAlign.left,),
           ),
           Container(
             margin: EdgeInsets.fromLTRB(0, 14, 0, 0),
             child: child,
           ),
         ],
       ),
     ),
   );
  }

}