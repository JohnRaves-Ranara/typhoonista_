import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/entities2/new/Day.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/entities2/new/Owner.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/entities2/new/Typhoon.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/services2/FirestoreService2.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';
import 'package:typhoonista_thesis/providers/sample_provider.dart';

class typhoon_forecast extends StatefulWidget {
  const typhoon_forecast({super.key});

  @override
  State<typhoon_forecast> createState() => _typhoon_forecastState();
}

class _typhoon_forecastState extends State<typhoon_forecast> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 55,
      child: StreamBuilder<List<Owner>>(
        stream: FirestoreService2().streamAllOwners(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Owner> owners = snapshot.data!;
            print("REBUILD");
            return Row(children: [
              Expanded(
                flex: 60,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(15)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: Offset(0, 3),
                          blurRadius: 2,
                          spreadRadius: 1,
                        ),
                      ]),
                  child: StreamBuilder<List<Day>>(
                    stream: FirestoreService2().streamAllDays(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Day> days = snapshot.data!;
                        for (Owner owner in owners) {
                          for (Day day in days) {
                            if (day.ownerID == owner.id) {
                              owner.days.add(day);
                            }
                          }
                          owner.days
                              .sort((a, b) => a.dayNum!.compareTo(b.dayNum!));
                        }

                        return Column(
                          children: [
                            //todo ibutang diri tong typhoon name og 6 day forecast shi
                            FutureBuilder<Typhoon?>(
                                future: FirestoreService2().getOngoingTyphoon(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    Typhoon ongoingTyphoon = snapshot.data!;
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Typhoon ${ongoingTyphoon.typhoonName}",
                                          style: textStyles.lato_bold(
                                              fontSize: 22),
                                        ),
                                        Text(
                                          '6-Day Rice Crop Damage Forecast',
                                          style: textStyles.lato_bold(
                                              fontSize: 22),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "",
                                          style: textStyles.lato_bold(
                                              fontSize: 22),
                                        ),
                                        Text(
                                          '6-Day Rice Crop Damage Forecast',
                                          style: textStyles.lato_bold(
                                              fontSize: 22),
                                        ),
                                      ],
                                    );
                                  }
                                }),
                            SizedBox(
                              height: 20,
                            ),
                            Expanded(child: Consumer<SampleProvider>(
                              builder: (context, prov, _) {
                                Set<Owner> selectedOwners = prov.selectedOwners;
                                return SfCartesianChart(
                                  trackballBehavior: TrackballBehavior(
                                    
                                      enable: true,
                                      activationMode: ActivationMode.singleTap),
                                  series: (selectedOwners.isEmpty)
                                      ? owners
                                          .map((owner) =>
                                              AreaSeries<Day, String>(
                                                //todo
                                                // trendlines: <Trendline>[
                                                //   Trendline(
                                                //     type: TrendlineType.linear,
                                                //     forwardForecast: 3,
                                                //   )
                                                // ],
                                                animationDuration: 200,
                                                dataSource: owner.days,
                                                color: owner.colorMarker,
                                                xValueMapper: (Day data, _) =>
                                                    "Day ${data.dayNum}",
                                                yValueMapper: (Day data, _) =>
                                                    data.damageCost,
                                              ))
                                          .toList()
                                      : selectedOwners
                                          .map((selectedOwner) =>
                                              AreaSeries<Day, String>(
                                                animationDuration: 200,
                                                dataSource: selectedOwner.days,
                                                color:
                                                    selectedOwner.colorMarker,
                                                xValueMapper: (Day data, _) =>
                                                    "Day ${data.dayNum}",
                                                yValueMapper: (Day data, _) =>
                                                    data.damageCost,
                                              ))
                                          .toList(),
                                  primaryXAxis: CategoryAxis(
                                    labelStyle: textStyles.lato_regular(),
                                    edgeLabelPlacement:
                                        EdgeLabelPlacement.shift,
                                    labelPlacement: LabelPlacement.onTicks,
                                  ),
                                  // primaryYAxis: NumericAxis(
                                  //   numberFormat:
                                  //       NumberFormat.compact(locale: 'en'),
                                  //   axisLabelFormatter:
                                  //       (AxisLabelRenderDetails details) {
                                  //     // Custom label formatting for millions and thousands
                                  //     String label = details.text;
                                  //     double value = double.parse(
                                  //         details.value.toString());

                                  //     if (value >= 1000000) {
                                  //       // Format in millions
                                  //       label =
                                  //           '${(value / 1000000).toStringAsFixed(1)}M';
                                  //     } else if (value >= 1000) {
                                  //       // Format in thousands
                                  //       label =
                                  //           '${(value / 1000).toStringAsFixed(1)}K';
                                  //     }

                                  //     return ChartAxisLabel(
                                  //         label, textStyles.lato_regular());
                                  //   },
                                  // ),
                                );
                              },
                            ))
                          ],
                        );
                      } else {
                        return Center(
                          child: Text("no day data"),
                        );
                      }
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 40,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: Offset(0, 3),
                          blurRadius: 2,
                          spreadRadius: 1,
                        ),
                      ]),
                  child: Row(
                    children: [
                      Column(
                        children: owners
                            .map(
                              (owner) => Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Row(
                                  children: [
                                    Consumer<SampleProvider>(
                                      builder: (context, prov, _) {
                                        Set<Owner> selectedOwners =
                                            prov.selectedOwners;
                                        return Container(
                                          child: (!selectedOwners
                                                  .contains(owner))
                                              ? GestureDetector(
                                                  onTap: (() {
                                                    prov.addSelectedOwner(
                                                        owner);
                                                  }),
                                                  child: Icon(Icons
                                                      .visibility_outlined))
                                              : GestureDetector(
                                                  onTap: (() {
                                                    prov.removeSelectedOwner(
                                                        owner);
                                                  }),
                                                  child:
                                                      Icon(Icons.visibility)),
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    CircleAvatar(
                                      radius: 10,
                                      backgroundColor: owner.colorMarker,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: owners
                            .map(
                              (owner) => Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  owner.ownerName,
                                  style: textStyles.lato_light(fontSize: 16),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: owners
                            .map(
                              (owner) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  "${NumberFormat('#,##0.00', 'en_US').format(owner.totalDamageCost)}",
                                  style: textStyles.lato_light(fontSize: 16),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              )
            ]);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  // Color getRandomColor() {
  //   int red = Random().nextInt(256);
  //   int green = Random().nextInt(256);
  //   int blue = Random().nextInt(256);
  //   // Create a new random color
  //   Color randomColor = Color.fromARGB(255, red, green, blue).withOpacity(0.3);
  //   return randomColor;
  // }
}

// import 'package:typhoonista_thesis/HOMEPAGES2/services2/FirestoreService2.dart';

// void main()async{
//   await FirestoreService2().getOwners();
// }