import 'package:flutter/material.dart';

class history_page extends StatefulWidget {
  const history_page({super.key});

  @override
  State<history_page> createState() => _history_pageState();
}

class _history_pageState extends State<history_page> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      child: Center(
        child: Text("history_page"),
      ),
    );
  }
}