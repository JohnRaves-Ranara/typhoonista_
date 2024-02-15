import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/entities2/new/Municipality.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/entities2/new/Typhoon.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/services2/FirestoreService2.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';

class test4 extends StatefulWidget {
  const test4({super.key});

  @override
  State<test4> createState() => _test4State();
}

class _test4State extends State<test4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Municipality>>(
        stream: FirestoreService2().streamAllMunicipalities(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Municipality> municipalities = snapshot.data!;
            List<int> damagePercentages = convertToPercentages(municipalities);
            for (int i = 0; i < municipalities.length; i++) {
              municipalities[i].damageCostInPercentage = damagePercentages[i];
            }
            return Expanded(
                flex: 40,
                child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: Offset(0, 3),
                            blurRadius: 2,
                            spreadRadius: 1,
                          ),
                        ]),
                    child: Row(children: [
                      Container(
                        child: SfCircularChart(
                          tooltipBehavior: TooltipBehavior(
                              enable: true,
                              activationMode: ActivationMode.longPress,
                              animationDuration: 100),
                          series: <CircularSeries>[
                            DoughnutSeries<Municipality, String>(
                              dataLabelSettings: DataLabelSettings(
                                textStyle: textStyles.lato_regular(fontSize: 12),
                                isVisible: true,
                                margin: EdgeInsets.zero,
                                connectorLineSettings: ConnectorLineSettings(
                                    length: '20%', type: ConnectorType.curve),
                                labelPosition: ChartDataLabelPosition.outside,
                                overflowMode: OverflowMode.shift,
                                labelIntersectAction:
                                    LabelIntersectAction.shift,
                              ),
                              dataLabelMapper: (Municipality data, _) =>
                                  "₱ ${NumberFormat('#,##0.00', 'en_US').format(data.totalDamageCost)}",
                              pointColorMapper: (Municipality data, _) =>
                                  data.colorMarker,
                              dataSource: municipalities,
                              xValueMapper: (Municipality data, _) =>
                                  data.munName,
                              yValueMapper: (Municipality data, _) =>
                                  data.totalDamageCost,
                            )
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          FutureBuilder<Typhoon?>(
                              future: FirestoreService2().getOngoingTyphoon(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  Typhoon ongoingTyphoon = snapshot.data!;
                                  return Text(
                                    'Total Damage Cost\nof Typhoon ${ongoingTyphoon.typhoonName}\nto Rice Crops\n(Municipal)',
                                    textAlign: TextAlign.center,
                                    style: textStyles.lato_bold(fontSize: 18),
                                  );
                                } else {
                                  return Center(
                                    child: Text("no ongoing typhoon"),
                                  );
                                }
                              }),
                          SizedBox(
                            height: 30,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: municipalities
                                      .map((municipality) => Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 10,
                                                  backgroundColor:
                                                      municipality.colorMarker,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  municipality.munName,
                                                  style: textStyles.lato_light(
                                                      fontSize: 16),
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
                                  children: municipalities
                                      .map((municipality) => Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5),
                                            child: Row(
                                              children: [
                                                Text(
                                                  '${municipality.damageCostInPercentage}%',
                                                  style: textStyles.lato_light(
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ])));
          } else {
            return Center(
              child: Text("no municipalities"),
            );
          }
        },
      ),
    );
  }

  List<int> convertToPercentages(List<Municipality> municipalities) {
    List<double> damageCosts =
        municipalities.map((mun) => mun.totalDamageCost).toList();
    double sum = damageCosts.reduce((value, element) => value + element);
    List<int> percentages =
        damageCosts.map((number) => (number * 100) ~/ sum).toList();

    return percentages;
  }
}
