import 'package:flutter/material.dart';

class settings_page extends StatefulWidget {
  const settings_page({super.key});

  @override
  State<settings_page> createState() => _settings_pageState();
}

class _settings_pageState extends State<settings_page> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.shade200,
      child: Center(
        child: Text("settings_page"),
      ),
    );
  }
}