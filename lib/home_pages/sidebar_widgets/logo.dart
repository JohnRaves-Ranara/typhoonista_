import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';
class logo extends StatelessWidget {
  const logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image.asset('assets/images/typhoonista_logo.png', height: 52, width: 52,),
          Image.asset('lib/assets/images/typhoonista_logo.png'),
          Text("Typhoonista", style: textStyles.lato_bold(fontSize: 18, color: Colors.black),)
        ],
      ),
    );
  }
}