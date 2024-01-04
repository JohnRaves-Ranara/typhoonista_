import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'textDataProvider.dart';
import 'screen2.dart';

class screen1 extends StatefulWidget {
  const screen1({super.key});

  @override
  State<screen1> createState() => _screen1State();
}

class _screen1State extends State<screen1> {
  @override
  Widget build(BuildContext context) {
    final prov = context.read<TextDataProvider>();
    return Scaffold(
      body: Center(
        child: Container(
          height: 500,
          width: 800,
          color: Colors.pink,
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: prov.textList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(prov.textList[index].text),
                  );
                },
              ),
              ElevatedButton(
                  onPressed: (() {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => screen2()));
                  }),
                  child: Text("ADD"))
            ],
          ),
        ),
      ),
    );
  }
}
