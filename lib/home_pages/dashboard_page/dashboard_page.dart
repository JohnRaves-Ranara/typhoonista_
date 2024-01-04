import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/home_pages/dashboard_page/widgets/dashboard_content.dart';
import 'package:typhoonista_thesis/home_pages/dashboard_page/widgets/header.dart';

class dashboard_page extends StatefulWidget {
  const dashboard_page({super.key});

  @override
  State<dashboard_page> createState() => _dashboard_pageState();
}

class _dashboard_pageState extends State<dashboard_page> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xfff6f6f6),
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          header(),
          dashboard_content()
        ],
      ),
    );
  }
}
