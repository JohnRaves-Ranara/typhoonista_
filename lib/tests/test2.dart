import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:typhoonista_thesis/tests/test.dart';
import 'package:uuid/uuid.dart';
import '../providers/sample_provider.dart';
import 'package:provider/provider.dart';
import '../entities/DamageCostBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class test2 extends StatefulWidget {
  test2({super.key});

  @override
  State<test2> createState() => _test2State();
}

class _test2State extends State<test2> {
  late List<DamageCostBar>? bruh;

  @override
  Widget build(BuildContext context) {
    return Consumer<SampleProvider>(
      builder: (context, sampleProvider, child) {
        bruh = sampleProvider.damageCostBars;
        return Scaffold(
            body: Center(
          child: Container(
            height: 500,
            width: 800,
            color: Colors.amber.shade200,
            child: Column(
              children: [
                ListView(
                    shrinkWrap: true,
                    children: (bruh == null)
                        ? [Text("EMPTY LIST")]
                        : bruh!
                            .map((dmgcostbar) => Text(dmgcostbar.typhoonName))
                            .toList()),
                ElevatedButton(
                    onPressed: (() {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => test()));
                    }),
                    child: Text("GOTO")),
                ElevatedButton(
                    onPressed: (() async {
                      final doc =  FirebaseFirestore.instance.collection('test').doc(Uuid().v1());
                      final json = {
                        "id" : doc.id,
                        "name" : "jayson",
                        "email" : "jayson@bruh.com"
                      };
                      await doc.set(json);
                    }),
                    child: Text("ADD"))
              ],
            ),
          ),
        ));
      },
    );
  }
}

class ChartData {
  final String title;
  final int cost;
  final String id;

  ChartData(this.title, this.cost, this.id);
}
