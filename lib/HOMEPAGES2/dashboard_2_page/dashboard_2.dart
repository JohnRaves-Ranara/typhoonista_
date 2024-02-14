import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/dashboard_2_page/widgets/dashboard_2_content.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/dashboard_2_page/widgets/header.dart';

class dashboard_2 extends StatefulWidget {
  const dashboard_2({super.key});

  @override
  State<dashboard_2> createState() => _dashboard_2State();
}

class _dashboard_2State extends State<dashboard_2> {
  @override
  Widget build(BuildContext context) {
    return Expanded(flex: 94,
    child: Container(
      padding: EdgeInsets.all(20),
      color: Color(0xfff6f6f6),
      child: Column(
        children: [
          // header(),
          dashboard_2_content()
        ],
      ),
    ),
    );
  }
}