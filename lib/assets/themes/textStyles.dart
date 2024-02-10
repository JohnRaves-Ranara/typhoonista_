import 'package:flutter/material.dart';

class textStyles{
  static lato_bold({double? fontSize, Color? color, bool? underlined}) => TextStyle(fontFamily: 'lato_bold', fontSize: fontSize, color: color, decoration: (underlined==true) ? TextDecoration.underline : null);
  static lato_black({double? fontSize, Color? color, bool? underlined, double? letterSpacing}) => TextStyle(fontFamily: 'lato_black', fontSize: fontSize, color: color, decoration: (underlined==true) ? TextDecoration.underline : null, letterSpacing: letterSpacing);
  static lato_regular({double? fontSize, Color? color, bool? underlined}) => TextStyle(fontFamily: 'lato_regular', fontSize: fontSize, color: color, decoration: (underlined==true) ? TextDecoration.underline : null);
  static lato_light({double? fontSize, Color? color, bool? underlined}) => TextStyle(fontFamily: 'lato_light', fontSize: fontSize, color: color, decoration: (underlined==true) ? TextDecoration.underline : null);
  static lato_thin({double? fontSize, Color? color, bool? underlined}) => TextStyle(fontFamily: 'lato_thin', fontSize: fontSize, color: color, decoration: (underlined==true) ? TextDecoration.underline : null);
}