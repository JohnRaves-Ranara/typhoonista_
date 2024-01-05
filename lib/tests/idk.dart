import 'package:flutter/material.dart';

class idk extends StatefulWidget {
  const idk({super.key});

  @override
  State<idk> createState() => _idkState();
}

class _idkState extends State<idk> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 200,
          color: Colors.teal,
          child: Center(
            child: Container(
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 10.0,
                    spreadRadius: -5.0,
                    offset: Offset(0, 5),
                  )
                ]),
                width: 200,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter text',
                    border: InputBorder.none,
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
