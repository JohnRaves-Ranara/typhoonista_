import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/home_pages/dashboard_page/widgets/dashboard_content_widgets/barChart.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';
import 'package:typhoonista_thesis/tests/idk3.dart';

class recorded_typhoons extends StatefulWidget {
  const recorded_typhoons({super.key});

  @override
  State<recorded_typhoons> createState() => _recorded_typhoonsState();
}

class _recorded_typhoonsState extends State<recorded_typhoons> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 45,
        child: Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
            decoration: BoxDecoration(
                // color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(26),
                color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(child: yada())
                // Expanded(
                //   child: Container(
                //       // color: Colors.blue,
                //       child: barChart()),
                // ),
              ],
            )
            )
            );
  }
}
