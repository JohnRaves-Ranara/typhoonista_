import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/dashboard_2_page/widgets/dashboard_2_content_widgets/actions_and_overview.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/dashboard_2_page/widgets/dashboard_2_content_widgets/typhoon_forecast.dart';

class dashboard_2_content extends StatefulWidget {
  const dashboard_2_content({super.key});

  @override
  State<dashboard_2_content> createState() => _dashboard_2_contentState();
}

class _dashboard_2_contentState extends State<dashboard_2_content> {
  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      child: Column(
        children: [
          actions_and_overview(),
          typhoon_forecast()
        ],
      ),
    
    ),);
  }
}