import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';

class Sidebar_2 extends StatefulWidget {
  const Sidebar_2({super.key});

  @override
  State<Sidebar_2> createState() => _Sidebar_2State();
}

class _Sidebar_2State extends State<Sidebar_2> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 6,
      child: Container(
      // color: Colors.orange,
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('lib/assets/images/typhoonista_logo_smallest.png', height: 25,),
          RotatedBox(quarterTurns: 3, child: Text("TYPHOONISTA", style: textStyles.lato_black(fontSize: 20, color: Colors.blue, letterSpacing: 8)),),
          Image.asset('lib/assets/images/2paper.png', color: Colors.blue, height: 27,)
        ],
      ),
    ));
  }
}