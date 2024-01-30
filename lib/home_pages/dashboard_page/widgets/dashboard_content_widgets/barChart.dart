import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typhoonista_thesis/entities/DamageCostBar.dart';
import 'package:typhoonista_thesis/entities/Typhoon.dart';
import 'package:typhoonista_thesis/providers/page_provider.dart';
import 'package:typhoonista_thesis/services/FirestoreService.dart';
import 'dart:math';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';

class barChart extends StatefulWidget {
  barChart({super.key});

  @override
  State<barChart> createState() => _barChartState();
}

class _barChartState extends State<barChart> {
  late List<double> sortedTyphoonCost;
  @override
  void initState(){
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<page_provider>(
      builder: (context, prov, child) {
        return FutureBuilder(
          future: FirestoreService().getAllDamageCostBarsBasedOnYear(year: prov.recordedTyphoonsSelectedYear!),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<DamageCostBar> damageCostBars = snapshot.data!;
              sortedTyphoonCost =
                  damageCostBars.map((typhoon) => typhoon.damageCost).toList();
              //sort the cost list
              sortedTyphoonCost.sort();
              return Container(
                child: BarChart(BarChartData(
                    gridData: FlGridData(show: false),
                    barGroups: damageCostBars
                        .map((typhoon) => BarChartGroupData(
                                x: damageCostBars.indexOf(typhoon),
                                barRods: [
                                  BarChartRodData(
                                      toY: typhoon.damageCost + .0,
                                      color: Colors.amber,
                                      width: 30,
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(8)))
                                ]))
                        .toList(),
                    titlesData: FlTitlesData(
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                              reservedSize: 30,
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return SideTitleWidget(
                                    child: Text(
                                      damageCostBars[value.toInt()].typhoonName,
                                      style: textStyles.lato_light(
                                        color: Colors.black,
                                      ),
                                    ),
                                    axisSide: meta.axisSide);
                              })),
                    ),
                    borderData: FlBorderData(show: false),
                    maxY: (sortedTyphoonCost.last + 10000).round() + .0,
                    minY: 0)),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        );
      },
    );
  }

  // Widget getTitlesWidget(double value, TitleMeta meta) {
  //   return SideTitleWidget(
  //       child: Text(
  //         damageCostBars[value.toInt()].typhoonName,
  //         style: textStyles.lato_light(
  //           color: Colors.black,
  //         ),
  //       ),
  //       axisSide: meta.axisSide);
  // }
}
