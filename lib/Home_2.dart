import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/dashboard_2_page/dashboard_2.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/sidebar_2.dart';

class Home_2 extends StatefulWidget {
  const Home_2({super.key});

  @override
  State<Home_2> createState() => _Home_2State();
}

class _Home_2State extends State<Home_2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar_2(),
          dashboard_2()
        ],
      ),
    );
  }
}