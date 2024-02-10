import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';

class typhoon_donutchart extends StatefulWidget {
  const typhoon_donutchart({super.key});

  @override
  State<typhoon_donutchart> createState() => _typhoon_donutchartState();
}

class _typhoon_donutchartState extends State<typhoon_donutchart> {
  late List<LocationDamage> data;

  @override
  void initState() {
    super.initState();
    data = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 45,
        child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Row(children: [
              Container(
                child: SfCircularChart(
                  series: <CircularSeries>[
                    DoughnutSeries<LocationDamage, String>(
                      pointColorMapper: (LocationDamage data, _) =>
                          data.pointColor,
                      dataSource: data,
                      xValueMapper: (LocationDamage data, _) =>
                          data.locationName,
                      yValueMapper: (LocationDamage data, _) =>
                          data.damageInPercentage,
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    'Total Damage Cost of \nTyphoon to Rice Crops',
                    textAlign: TextAlign.center,
                    style: textStyles.lato_bold(fontSize: 20),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: data
                            .map((d) => Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 10,
                                        backgroundColor: d.pointColor,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        d.locationName!,
                                        style:
                                            textStyles.lato_light(fontSize: 16),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: data
                            .map((d) => Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${d.damageInPercentage}%',
                                        style:
                                            textStyles.lato_light(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  )
                ],
              ),
            ])));
  }

  List<LocationDamage> getData() {
    final List<LocationDamage> data = [
      LocationDamage('Aklan', 30, Colors.green),
      LocationDamage('Tagum', 15, Colors.red),
      LocationDamage('Aborlan', 15, Colors.orange),
      LocationDamage('Hevabi', 40, Colors.blue)
    ];
    return data;
  }
}

class LocationDamage {
  String? locationName;
  double? damageInPercentage;
  Color? pointColor;
  LocationDamage(this.locationName, this.damageInPercentage, this.pointColor);
}
