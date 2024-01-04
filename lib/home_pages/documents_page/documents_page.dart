import 'package:flutter/material.dart';

class documents_page extends StatefulWidget {
  const documents_page({super.key});

  @override
  State<documents_page> createState() => _documents_pageState();
}

class _documents_pageState extends State<documents_page> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.pink.shade200,
      child: Center(
        child: Text("documents_page"),
      ),
    );
  }
}