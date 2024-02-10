import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:typhoonista_thesis/entities/DamageCostBar.dart';
import 'package:typhoonista_thesis/home_pages/dashboard_page/widgets/dashboard_content_widgets/barChart.dart';
import 'package:typhoonista_thesis/services/FirestoreService.dart';
import 'package:provider/provider.dart';
import 'package:typhoonista_thesis/providers/page_provider.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';

class yada extends StatefulWidget {
  const yada({super.key});

  @override
  State<yada> createState() => _yadaState();
}

class _yadaState extends State<yada> {
  // late Stream<List<int>> _yearsStream;
  late int _selectedYear;

  @override
  void initState() {
    super.initState();
    setState(() {
      // _yearsStream = FirestoreService().getYearsListStream();
      _selectedYear = 2024;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "RECORDED TYPHOONS",
              style: textStyles.lato_bold(color: Colors.black, fontSize: 15),
            ),
            StreamBuilder<List<int>>(
              stream: FirestoreService().getYearsListStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) { 
                  final List<int> years = snapshot.data!;
                  _selectedYear = years.first;
                  // return ListView(
                  //   shrinkWrap: true,
                  //   children: years.map((year) => ListTile(title: Text(year.toString()),)).toList()
                  // );
                  return Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1, style: BorderStyle.solid),borderRadius: BorderRadius.circular(10),),
                    
                    child: DropdownButton(
                        isDense: true,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        borderRadius: BorderRadius.circular(10),
                        items: buildMenuItems(years),
                        value: _selectedYear,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedYear = newValue!;
                          });
                        }),
                  );
                } else {
                  return Text('NO DATA');
                }
              },
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        StreamBuilder<List<DamageCostBar>>(
            stream: FirestoreService()
                .getAllDamageCostBarsBasedOnYearint(_selectedYear),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // final List<DamageCostBar> dmgCostBars = snapshot.data!;
                // return ListView(
                //   shrinkWrap: true,
                //   children: dmgCostBars.map((dmgCostBar) => ListTile(title: Text(dmgCostBar.damageCost.toString()))).toList(),
                // );
                final List<DamageCostBar> damageCostBars = snapshot.data!;
                List<double> sortedTyphoonCost = damageCostBars
                    .map((typhoon) => typhoon.damageCost)
                    .toList();
                //sort the cost list
                sortedTyphoonCost.sort();
                return Expanded(
                  child: Container(
                    // margin: EdgeInsets.only(top: 20),
                    child: Expanded(
                      child: Container(
                        child: SfCartesianChart(
                          primaryXAxis: CategoryAxis(
                            labelStyle: textStyles.lato_regular(),
                          ),
                          primaryYAxis: NumericAxis(
                            
                            labelStyle: textStyles.lato_regular(),
                          ),
                          series: [
                            StackedColumnSeries<DamageCostBar, String>(
                                color: Color(0xffff8007 ),
                                dataSource: damageCostBars,
                                xValueMapper: (DamageCostBar ch, _) =>
                                    ch.typhoonName,
                                yValueMapper: (DamageCostBar ch, _) =>
                                    ch.damageCost)
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Center(child: Text('No data'),);
              }
            })
      ],
    );
  }

  List<DropdownMenuItem<int>> buildMenuItems(List<int> years) {
    return years
        .map((year) => DropdownMenuItem<int>(
              child: Text(year.toString()),
              value: year,
              onTap: (() {}),
            ))
        .toList();
  }
}


