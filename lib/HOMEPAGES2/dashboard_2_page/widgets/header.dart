import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/dashboard_2_page/widgets/header_widgets/header_label.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/dashboard_2_page/widgets/header_widgets/header_user_section.dart';

class header extends StatefulWidget {
  const header({super.key});

  @override
  State<header> createState() => _headerState();
}

class _headerState extends State<header> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          header_label(),
          SizedBox(width: 15,), 
          header_user_section()
          ],
      ),
    );
  }
}
