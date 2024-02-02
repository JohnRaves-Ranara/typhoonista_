import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';
import 'package:uuid/uuid.dart';

class test extends StatelessWidget {
  test({super.key});

  final List<ChartData> damageCosts = [
    ChartData("Yolanda", 8736492),
    ChartData("Makora", 3872645),
    ChartData("Megumi", 2902734),
    ChartData("What", 2837567),
    ChartData("dsdas", 2837567),
    ChartData("zz", 898423),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: Container(
          color: Colors.red.shade100,
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(
              labelStyle: textStyles.lato_regular(),
            ),
            primaryYAxis: NumericAxis(
              labelStyle: textStyles.lato_regular(),
            ),
            series:[
              StackedColumnSeries <ChartData, String>(
                dataSource: damageCosts,
                xValueMapper: (ChartData ch, _) => ch.title,
                yValueMapper: (ChartData ch, _) => ch.cost
                )
            ],
          ),
        ),
      ),
    );
  }
}

class ChartData {
  final String title;
  final int cost;

  ChartData(this.title, this.cost);
}