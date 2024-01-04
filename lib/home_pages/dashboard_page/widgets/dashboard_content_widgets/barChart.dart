import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typhoonista_thesis/entities/DamageCostBar.dart';
import 'dart:math';
import '../../../../providers/sample_provider.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';

class barChart extends StatefulWidget {
  barChart({super.key});

  @override
  State<barChart> createState() => _barChartState();
}

class _barChartState extends State<barChart> {
  late List<DamageCostBar> typhoons1;

  @override
  void initState() {
    super.initState();
    // List<DamageCostBar> bruh = [
    //   DamageCostBar("asd", 1826374),
    //   DamageCostBar("bruh", 7625473),
    //   DamageCostBar("what", 2716543)
    // ];
    // context.read<SampleProvider>().initializeBarChart();
    
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SampleProvider>(
      builder: (context, sampleProvider, child) {
        typhoons1 = context.read<SampleProvider>().damageCostBars;
        //create separate list of only costs
        final sortedTyphoonCost =
            typhoons1.map((typhoon) => typhoon.damageCost).toList();
        //sort the cost list
        sortedTyphoonCost.sort();

        return Container(
          child: BarChart(BarChartData(
              gridData: FlGridData(show: false),
              barGroups: typhoons1
                  .map((typhoon) => BarChartGroupData(
                          x: typhoons1.indexOf(typhoon),
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
                        getTitlesWidget: getTitlesWidget)),
              ),
              borderData: FlBorderData(show: false),
              maxY: (sortedTyphoonCost.last + 10000).round() + .0,
              minY: 0)),
        );
      },
    );
  }

  Widget getTitlesWidget(double value, TitleMeta meta) {
    return SideTitleWidget(
        child: Text(
          typhoons1[value.toInt()].typhoonName,
          style: textStyles.lato_light(
            color: Colors.black,
          ),
        ),
        axisSide: meta.axisSide);
  }
}
