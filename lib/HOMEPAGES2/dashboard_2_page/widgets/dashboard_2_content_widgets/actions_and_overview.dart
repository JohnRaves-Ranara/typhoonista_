import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/dashboard_2_page/widgets/dashboard_2_content_widgets/actions_and_overview_widgets/actions/actions.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/dashboard_2_page/widgets/dashboard_2_content_widgets/actions_and_overview_widgets/typhoon_averages_overview.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/dashboard_2_page/widgets/dashboard_2_content_widgets/actions_and_overview_widgets/typhoon_donutchart.dart';

class actions_and_overview extends StatefulWidget {
  const actions_and_overview({super.key});

  @override
  State<actions_and_overview> createState() => _actions_and_overviewState();
}

class _actions_and_overviewState extends State<actions_and_overview> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 45,
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        // color: Colors.purple,
      // padding: EdgeInsets.all(10),
      child: Row(
        children: [
          actions(),
          SizedBox(width: 20,),
          typhoon_donutchart(),
          SizedBox(width: 20,),
          typhoon_averages_overview(),
        ],
      ),
      ),
    );
  }
}