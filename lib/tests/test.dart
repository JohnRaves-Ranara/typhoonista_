import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:typhoonista_thesis/entities/DamageCostBar.dart';
import 'package:typhoonista_thesis/providers/sample_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class test extends StatefulWidget {
  test({super.key});

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {
  final List<ChartData> damageCosts = [
    ChartData("Yolanda", 8736492, Uuid().toString()),
    ChartData("Makora", 3872645, Uuid().toString()),
    ChartData("Megumi", 2902734, Uuid().toString()),
    ChartData("What", 2837567, Uuid().toString()),
    ChartData("dsdas", 2837567, Uuid().toString()),
    ChartData("zz", 898423, Uuid().toString()),
  ];

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: Center(
    //     child: Container(
    //       height: 500,
    //       width: 800,
    //       color: Colors.red.shade100,
    //       child: SfCartesianChart(
    //         primaryXAxis: CategoryAxis(
    //           labelStyle: textStyles.lato_regular(),
    //         ),
    //         primaryYAxis: NumericAxis(
    //           labelStyle: textStyles.lato_regular(),
    //         ),
    //         series:[
    //           StackedColumnSeries <ChartData, String>(
    //             dataSource: damageCosts,
    //             xValueMapper: (ChartData ch, _) => ch.title,
    //             yValueMapper: (ChartData ch, _) => ch.cost
    //             )
    //         ],
    //       ),
    //     ),
    //   ),
    // );
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
          child: Text("CHANGE LIST"),
          onPressed: (() {
            List<DamageCostBar> bars = [
              DamageCostBar("ANJING", 1234567),
              DamageCostBar("HELLO", 1234567),
              DamageCostBar("KITTY", 1234567),
              DamageCostBar("DUTERTE", 1234567)
            ];
            context.read<SampleProvider>().changeDamageCostBarsList(bars);
            Navigator.pop(context);
          }),
        ),
        ElevatedButton(
          child: Text("CHANGE LIST"),
          onPressed: (() async{
            final bruh = await FirebaseFirestore.instance.collection("test").get();
            print(bruh.docs.length);
            Navigator.pop(context);
          }),
        ),
          ],
        )
      ),
    );
  }
}

class ChartData {
  final String title;
  final int cost;
  final String id;

  ChartData(this.title, this.cost, this.id);
}
