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
  showEstimationInfo(Owner owner) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.5,
              padding: EdgeInsets.all(10),
              child: FutureBuilder<List<Day>?>(
                  future: FirestoreService2().getAllDaysBasedOnOwner(owner),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      owner.days = snapshot.data!;
                      Day firstDay =
                          owner.days.firstWhere((day) => day.dayNum == 1);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                owner.ownerName,
                                style: textStyles.lato_black(fontSize: 24),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Date Recorded:",
                                    style: textStyles.lato_bold(fontSize: 15),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "${DateTime.parse(owner.dateRecorded!).month}/${DateTime.parse(owner.dateRecorded!).day}/${DateTime.parse(owner.dateRecorded!).year} ${DateTime.parse(owner.dateRecorded!).hour.toString().padLeft(2, '0')}:${DateTime.parse(owner.dateRecorded!).minute.toString().padLeft(2, '0')}:${DateTime.parse(owner.dateRecorded!).second.toString().padLeft(2, '0')}",
                                    style:
                                        textStyles.lato_regular(fontSize: 15),
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Windspeed (km/h)",
                                            style: textStyles.lato_bold(
                                                fontSize: 15),
                                          ),
                                          Text(
                                            firstDay.windSpeed.toString(),
                                            style: textStyles.lato_regular(
                                                fontSize: 15),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "24-hour rainfall (mm)",
                                            style: textStyles.lato_bold(
                                                fontSize: 15),
                                          ),
                                          Text(
                                            firstDay.rainfall24.toString(),
                                            style: textStyles.lato_regular(
                                                fontSize: 15),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "6-hour rainfall (mm)",
                                            style: textStyles.lato_bold(
                                                fontSize: 15),
                                          ),
                                          Text(
                                            firstDay.rainfall6.toString(),
                                            style: textStyles.lato_regular(
                                                fontSize: 15),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Rice Price (PHP)",
                                            style: textStyles.lato_bold(
                                                fontSize: 15),
                                          ),
                                          Text(
                                            firstDay.ricePrice.toString(),
                                            style: textStyles.lato_regular(
                                                fontSize: 15),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Days Count",
                                            style: textStyles.lato_bold(
                                                fontSize: 15),
                                          ),
                                          Text(
                                            owner.days.length.toString(),
                                            style: textStyles.lato_regular(
                                                fontSize: 15),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Rice Area (ha)",
                                            style: textStyles.lato_bold(
                                                fontSize: 15),
                                          ),
                                          Text(
                                            firstDay.riceArea.toString(),
                                            style: textStyles.lato_regular(
                                                fontSize: 15),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Yield (ton/ha)",
                                            style: textStyles.lato_bold(
                                                fontSize: 15),
                                          ),
                                          Text(
                                            firstDay.riceYield.toString(),
                                            style: textStyles.lato_regular(
                                                fontSize: 15),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Province",
                                            style: textStyles.lato_bold(
                                                fontSize: 15),
                                          ),
                                          Text(
                                            owner.provName!,
                                            style: textStyles.lato_regular(
                                                fontSize: 15),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Municipality",
                                            style: textStyles.lato_bold(
                                                fontSize: 15),
                                          ),
                                          Text(
                                            owner.munName!,
                                            style: textStyles.lato_regular(
                                                fontSize: 15),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Distance of Typhoon to Location (km)",
                                            style: textStyles.lato_bold(
                                                fontSize: 15),
                                          ),
                                          Text(
                                            firstDay.distance.toString(),
                                            style: textStyles.lato_regular(
                                                fontSize: 15),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ),
          );
        });
  }

  Widget build(BuildContext context) {
    return Expanded(
        flex: 55,
        child: StreamBuilder(
            stream: FirestoreService2().streamOngoingTyphoon(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Typhoon ongoingTyphoon = snapshot.data!;
                return StreamBuilder<List<Owner>>(
                  stream: FirestoreService2().streamAllOwners(ongoingTyphoon),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print("YES NAAY OWNERS!!!!!!!!");

                      List<Owner> owners = snapshot.data!;
                      print(owners.length);
                      owners.sort((a, b) => DateTime.parse(b.dateRecorded!)
                          .compareTo(DateTime.parse(a.dateRecorded!)));
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
                              stream: FirestoreService2()
                                  .streamAllDays(ongoingTyphoon),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  List<Day> days = snapshot.data!;
                                  for (Owner owner in owners) {
                                    for (Day day in days) {
                                      if (day.ownerID == owner.id) {
                                        owner.days.add(day);
                                      }
                                    }
                                    owner.days.sort((a, b) =>
                                        a.dayNum!.compareTo(b.dayNum!));
                                  }

                                  return Column(
                                    children: [
                                      //todo ibutang diri tong typhoon name og 6 day forecast shi
                                      StreamBuilder<Typhoon?>(
                                          stream: FirestoreService2()
                                              .streamOngoingTyphoon(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              Typhoon ongoingTyphoon =
                                                  snapshot.data!;
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Typhoon ${ongoingTyphoon.typhoonName}",
                                                    style: textStyles.lato_bold(
                                                        fontSize: 22),
                                                  ),
                                                  Text(
                                                    'Rice Crop Damage Forecast',
                                                    style: textStyles.lato_bold(
                                                        fontSize: 22),
                                                  ),
                                                ],
                                              );
                                            } else {
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "",
                                                    style: textStyles.lato_bold(
                                                        fontSize: 22),
                                                  ),
                                                  Text(
                                                    'Rice Crop Damage Forecast',
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
                                          Set<Owner> selectedOwners =
                                              prov.selectedOwners;
                                          return SfCartesianChart(
                                            trackballBehavior:
                                                TrackballBehavior(
                                                    enable: true,
                                                    activationMode:
                                                        ActivationMode
                                                            .singleTap),
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
                                                          animationDuration:
                                                              200,
                                                          dataSource:
                                                              owner.days,
                                                          color: owner
                                                              .colorMarker
                                                              .withOpacity(0.5),
                                                          xValueMapper: (Day
                                                                      data,
                                                                  _) =>
                                                              "Day ${data.dayNum}",
                                                          yValueMapper: (Day
                                                                      data,
                                                                  _) =>
                                                              data.damageCost,
                                                        ))
                                                    .toList()
                                                : selectedOwners
                                                    .map((selectedOwner) =>
                                                        AreaSeries<Day, String>(
                                                          animationDuration:
                                                              200,
                                                          dataSource:
                                                              selectedOwner
                                                                  .days,
                                                          color: selectedOwner
                                                              .colorMarker
                                                              .withOpacity(0.5),
                                                          xValueMapper: (Day
                                                                      data,
                                                                  _) =>
                                                              "Day ${data.dayNum}",
                                                          yValueMapper: (Day
                                                                      data,
                                                                  _) =>
                                                              data.damageCost,
                                                        ))
                                                    .toList(),
                                            primaryXAxis: CategoryAxis(
                                              labelStyle:
                                                  textStyles.lato_regular(),
                                              edgeLabelPlacement:
                                                  EdgeLabelPlacement.shift,
                                              labelPlacement:
                                                  LabelPlacement.onTicks,
                                            ),
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
                              child: ListView(
                                children: [
                                  Container(
                                    height: 50,
                                    child: Text(
                                      "Estimation History",
                                      style: textStyles.lato_bold(fontSize: 22),
                                    ),
                                  ),
                                  ListView(
                                    shrinkWrap: true,
                                    children: owners
                                        .map((owner) => Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                                onTap: (() {
                                                  showEstimationInfo(owner);
                                                }),
                                                child: Container(
                                                  margin:
                                                      EdgeInsets.only(bottom: 11),
                                                  child: Row(
                                                    
                                                    children: [
                                                      Row(
                                                        
                                                        children: [
                                                          Consumer<
                                                              SampleProvider>(
                                                            builder: (context,
                                                                prov, _) {
                                                              Set<Owner>
                                                                  selectedOwners =
                                                                  prov.selectedOwners;
                                                              return Container(
                                                                child: (!selectedOwners
                                                                        .contains(
                                                                            owner))
                                                                    ? GestureDetector(
                                                                        onTap:
                                                                            (() {
                                                                          prov.addSelectedOwner(
                                                                              owner);
                                                                        }),
                                                                        child: Icon(
                                                                            Icons
                                                                                .visibility_outlined))
                                                                    : GestureDetector(
                                                                        onTap:
                                                                            (() {
                                                                          prov.removeSelectedOwner(
                                                                              owner);
                                                                        }),
                                                                        child: Icon(
                                                                            Icons
                                                                                .visibility)),
                                                              );
                                                            },
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          CircleAvatar(
                                                            radius: 10,
                                                            backgroundColor: owner
                                                                .colorMarker
                                                                .withOpacity(0.5),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: 45,
                                                      ),
                                                      Text(
                                                        owner.ownerName,
                                                        style:
                                                            textStyles.lato_light(
                                                                fontSize: 16),
                                                      ),
                                                      Spacer(),
                                                      Text(
                                                        "${NumberFormat('#,##0.00', 'en_US').format(owner.totalDamageCost)}",
                                                        style:
                                                            textStyles.lato_light(
                                                                fontSize: 16),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                        ))
                                        .toList(),
                                  ),
                                ],
                              )),
                        )
                      ]);
                    } else {
                      return Center(
                        child: Text(
                          "No data.",
                          style: textStyles.lato_bold(fontSize: 22),
                        ),
                      );
                    }
                  },
                );
              } else {
                return Center(
                  child: Text("No data.",
                      style: textStyles.lato_bold(fontSize: 22)),
                );
              }
            }));
  }
}
