import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typhoonista_thesis/entities/Location_.dart';
import 'package:typhoonista_thesis/entities/Typhoon.dart';
import 'package:typhoonista_thesis/entities/TyphoonDay.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:typhoonista_thesis/providers/page_provider.dart';
import 'package:typhoonista_thesis/services/FirestoreService.dart';
import 'package:typhoonista_thesis/services/locations.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';
import 'package:typhoonista_thesis/services/pdfGeneratorService.dart';

class typhoon_live_summary_page extends StatefulWidget {
  const typhoon_live_summary_page({super.key});

  @override
  State<typhoon_live_summary_page> createState() =>
      _typhoon_live_summary_pageState();
}

class _typhoon_live_summary_pageState extends State<typhoon_live_summary_page> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      color: Colors.grey.shade800,
      child: Consumer<page_provider>(
        builder: (context, prov, child) {
          final Typhoon selectedTyphoon = prov.selectedTyphoon!;
          // prov.changeSelectedTyphoon(selectedTyphoon);
          return Stack(children: [
            SingleChildScrollView(
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  padding: EdgeInsets.symmetric(horizontal: 35, vertical: 40),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          style: BorderStyle.solid,
                          color: Colors.grey,
                          width: 1)),
                  child: Column(
                    children: [
                      Container(
                        width: double.maxFinite,
                        // color: Colors.red,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Text(
                                    'Typhoonista',
                                    style: textStyles.lato_bold(fontSize: 16),
                                  ),
                                  Image.asset(
                                    'lib/assets/images/typhoonista_logo.png',
                                    height: 25,
                                    width: 25,
                                  )
                                ],
                              ),
                            ),
                            (selectedTyphoon.status == 'ongoing')
                                ? Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.red,
                                        radius: 6,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Typhoon Live Summary Report",
                                        style:
                                            textStyles.lato_bold(fontSize: 16),
                                      ),
                                    ],
                                  )
                                : Text(
                                    "Typhoon Summary Report",
                                    style: textStyles.lato_bold(fontSize: 16),
                                  ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        color: Colors.grey.shade700,
                      ),
                      Container(
                        width: double.maxFinite,
                        // color: Colors.green.shade200,
                        child: FutureBuilder<Typhoon>(
                            future: FirestoreService()
                                .getTyphoon(selectedTyphoon.id),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final Typhoon typhoon = snapshot.data!;
                                TextStyle titleStyle = textStyles.lato_regular(
                                    color: Colors.grey, fontSize: 14);
                                TextStyle valueStyle = textStyles.lato_regular(
                                    color: Colors.black, fontSize: 14);
                                return Container(
                                  // color: Colors.green,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          //this right here is the first child
                                          padding: EdgeInsets.all(20),
                                          // color: Colors.blue,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Name of Typhoon",
                                                    style: titleStyle,
                                                  ),
                                                  Text(
                                                    "Typhoon ${typhoon.typhoonName}",
                                                    style: valueStyle,
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text("Typhoon Starting Date",
                                                      style: titleStyle),
                                                  Text(
                                                    "${DateTime.parse(typhoon.startDate).month}/${DateTime.parse(typhoon.startDate).day}/${DateTime.parse(typhoon.startDate).year}",
                                                    style: valueStyle,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text("Typhoon Ending Date",
                                                      style: titleStyle),
                                                  Text(
                                                    (typhoon.endDate == "")
                                                        ? "Unknown"
                                                        : "${DateTime.parse(typhoon.endDate).month}/${DateTime.parse(typhoon.endDate).day}/${DateTime.parse(typhoon.endDate).year}",
                                                    style: valueStyle,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          //this right here is the second child
                                          // color: Colors.orange,
                                          padding: EdgeInsets.all(20),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text("Typhoon Status",
                                                      style: titleStyle),
                                                  Text(
                                                    "${typhoon.status}",
                                                    style: valueStyle,
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      "Total Damage To Rice Crops",
                                                      style: titleStyle),
                                                  Text(
                                                    "${typhoon.totalDamageCost} PHP",
                                                    style: valueStyle,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text("Locations",
                                                      style: titleStyle),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: (prov.locations!
                                                            .isEmpty)
                                                        ? [Text('Loading...')]
                                                        : prov.locations!
                                                            .map((loc) => Text(
                                                                  "• ${loc.munName}",
                                                                  style:
                                                                      valueStyle,
                                                                ))
                                                            .toList(),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              } else {
                                return Text("no data");
                              }
                            }),
                      ),
                      Container(
                        width: double.maxFinite,
                        child: FutureBuilder<List<Location_>>(
                          future: FirestoreService().getDistinctLocations(selectedTyphoon.id),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final List<Location_> locations = snapshot.data!;
                              // prov.changeSelectedLocations(locations);
                              return Column(
                                children: locations.map((loc) {
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    // color: Colors.amber.shade200,

                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Location",
                                          style: textStyles.lato_regular(
                                              fontSize: 14, color: Colors.grey),
                                        ),
                                        Text(
                                          "${loc.munName}",
                                          style: textStyles.lato_regular(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          width: double.maxFinite,
                                          child: DataTable(
                                              border: TableBorder.all(
                                                  width: 1,
                                                  color: Color(0xffd4d4d4),
                                                  style: BorderStyle.solid),
                                              columns: const [
                                                DataColumn(
                                                    label: Text("Day No.")),
                                                DataColumn(
                                                    label:Text("Date Recorded")),
                                                DataColumn(
                                                    label: Text("Windspeed")),
                                                DataColumn(
                                                    label: Text("Rainfall (24H)")),
                                                DataColumn(
                                                    label: Text("Rainfall (6H)")),
                                                DataColumn(
                                                    label: Text("Damage Cost")),
                                              ],
                                              rows: loc.days
                                                  .map((day) => DataRow(cells: [
                                                        DataCell(Text(day.day
                                                            .toString())),
                                                        DataCell(Text(
                                                            "${DateTime.parse(day.dateRecorded).month}/${DateTime.parse(day.dateRecorded).day}/${DateTime.parse(day.dateRecorded).year}")),
                                                        DataCell(Text(day
                                                            .windSpeed
                                                            .toString())),
                                                        DataCell(Text(day
                                                            .rainfall24
                                                            .toString())),
                                                        DataCell(Text(day
                                                            .rainfall6
                                                            .toString())),
                                                        DataCell(Text(
                                                            "${day.damageCost.toString()}"))
                                                      ]))
                                                  .toList()),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          children: [
                                            Spacer(),
                                            Text(
                                                "Total Damage Cost: ${loc.totalDamageCost.toString()} PHP")
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              );
                            } else {
                              return Text("no data");
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: InkWell(
                splashFactory: NoSplash.splashFactory,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: (() {
                  pdfGeneratorService(
                          typhoon: prov.selectedTyphoon,
                          locations: prov.locations)
                      .generateSamplePDF();
                }),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blue,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  height: 50,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Download PDF",
                        style: textStyles.lato_regular(
                            color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.download,
                        size: 26,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ]);
        },
      ),
    );
  }

  
}
