import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'textDataProvider.dart';

class screen2 extends StatefulWidget {
  const screen2({super.key});

  @override
  State<screen2> createState() => _screen2State();
}

class _screen2State extends State<screen2> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<TextDataProvider>(
      builder: (context, prov, child) {
        return Scaffold(
            body: Center(
          child: Container(
            height: 500,
            width: 800,
            child: Center(
              child: Column(
                children: [
                  TextField(
                    controller: controller,
                  ),
                  ElevatedButton(
                      onPressed: (() {
                        prov.addText(controller.text.trim());
                        Navigator.pop(context);
                      }),
                      child: Text("ADD"))
                ],
              ),
            ),
          ),
        ));
      },
    );
  }
}
