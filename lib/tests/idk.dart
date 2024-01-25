import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/entities/Location_.dart';
import 'package:typhoonista_thesis/entities/Typhoon.dart';
import 'package:typhoonista_thesis/entities/TyphoonDay.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';
import 'package:typhoonista_thesis/services/pdfGeneratorService.dart';
import 'package:typhoonista_thesis/services/locations_.dart';

class idk extends StatefulWidget {
  const idk({super.key});

  @override
  State<idk> createState() => _idkState();
}

class _idkState extends State<idk> {
  final Typhoon dummyTyphoon = Typhoon(
    id: '123',
    typhoonName: 'Meshi',
    peakWindspeed: 56,
    peakRainfall: 76,
    startDate: '2024-01-19 18:34:17.016',
    endDate: '',
    status: 'ongoing',
    totalDamageCost: 56328950,
    currentDay: 2,
  );


  List<Location_> locs = [

  ];
  TextStyle titleStyle =
      textStyles.lato_regular(color: Colors.grey, fontSize: 14);
  TextStyle valueStyle =
      textStyles.lato_regular(color: Colors.black, fontSize: 14);

  @override
  void initState() {
    super.initState();
    List<Location_> locsFromJson = Locations_().getLocations();
    locs = [
      locsFromJson[0],
      locsFromJson[1],
      locsFromJson[2],
      locsFromJson[3]
    ];
    locs[0].days = [
      TyphoonDay(
          damageCost: 10899700,
          dateRecorded: "2024-01-19 21:44:04.774",
          day: 2,
          id: "Cg9VWOFnZUsVN5JeaQpk",
          location: "Davao",
          locationCode: "dav1",
          rainfall: 55,
          typhoonID: "P6BYfSK9l8aDq1MY9AVV",
          typhoonName: "pakunoda",
          windSpeed: 78),
      TyphoonDay(
          damageCost: 11920660,
          dateRecorded: "2024-01-18 20:16:39.779",
          day: 2,
          id: "Cg9VWOFnZUsVN5JeaQpk",
          location: "Davao",
          locationCode: "dav1",
          rainfall: 65,
          typhoonID: "P6BYfSK9l8aDq1MY9AVV",
          typhoonName: "pakunoda",
          windSpeed: 78),
    ];

    locs[1].days = [
      TyphoonDay(
          damageCost: 11304970,
          dateRecorded: "2024-01-19 19:16:52.865",
          day: 1,
          id: "Cg9VWOFnZUsVN5JeaQpk",
          location: "Cebu",
          locationCode: "ceb2",
          rainfall: 65,
          typhoonID: "P6BYfSK9l8aDq1MY9AVV",
          typhoonName: "pakunoda",
          windSpeed: 78),
    ];

    locs[2].days = [
      TyphoonDay(
          damageCost: 11102390,
          dateRecorded: "2024-01-19 18:34:17.016",
          day: 1,
          id: "Cg9VWOFnZUsVN5JeaQpk",
          location: "Arakan",
          locationCode: "arak3",
          rainfall: 65,
          typhoonID: "P6BYfSK9l8aDq1MY9AVV",
          typhoonName: "pakunoda",
          windSpeed: 78),
    ];

    locs[3].days = [
      TyphoonDay(
          damageCost: 11101230,
          dateRecorded: "2024-01-21 00:51:33.839",
          day: 2,
          id: "Cg9VWOFnZUsVN5JeaQpk",
          location: "Surigao",
          locationCode: "sur4",
          rainfall: 65,
          typhoonID: "P6BYfSK9l8aDq1MY9AVV",
          typhoonName: "pakunoda",
          windSpeed: 78),
    ];

    for (int i = 0; i < locs.length; i++) {
      double total = 0;
      for (TyphoonDay day in locs[i].days) {
        total += day.damageCost;
      }
      locs[i].totalDamageCost += total;
    }

    print(locs.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: InkWell(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: (() {
            pdfGeneratorService(
              typhoon: dummyTyphoon,
              locations: locs
            ).generateSamplePDF();
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
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              padding: EdgeInsets.symmetric(horizontal: 35, vertical: 40),
              decoration: BoxDecoration(
                  border: Border.all(
                      style: BorderStyle.solid, color: Colors.grey, width: 1)),
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
                        Text(
                          "Typhoon Live Summary Report",
                          style: textStyles.lato_bold(fontSize: 16),
                        )
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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            //this right here is the first child
                            padding: EdgeInsets.all(20),
                            // color: Colors.blue,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Name of Typhoon",
                                      style: titleStyle,
                                    ),
                                    Text(
                                      "Typhoon ${dummyTyphoon.typhoonName}",
                                      style: valueStyle,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text("Typhoon Starting Date",
                                        style: titleStyle),
                                    Text(
                                      "${DateTime.parse(dummyTyphoon.startDate).month}/${DateTime.parse(dummyTyphoon.startDate).day}/${DateTime.parse(dummyTyphoon.startDate).year}",
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
                                    Text("Typhoon Ending Date",
                                        style: titleStyle),
                                    Text(
                                      (dummyTyphoon.endDate == "")
                                          ? "Unknown"
                                          : "${DateTime.parse(dummyTyphoon.endDate).month}/${DateTime.parse(dummyTyphoon.endDate).day}/${DateTime.parse(dummyTyphoon.endDate).year}",
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text("Typhoon Status", style: titleStyle),
                                    Text(
                                      "${dummyTyphoon.status}",
                                      style: valueStyle,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text("Total Damage To Rice Crops",
                                        style: titleStyle),
                                    Text(
                                      "${dummyTyphoon.totalDamageCost} PHP",
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
                                    Text("Locations", style: titleStyle),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: (locs.isEmpty)
                                          ? [Text('Loading...')]
                                          : locs
                                              .map((loc) => Text(
                                                    "• ${loc.munName}",
                                                    style: valueStyle,
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
                  ),
                  Container(
                      width: double.maxFinite,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: locs.length,
                          itemBuilder: (context, index) {
                            Location_ loc = locs[index];
                            return Container(
                              margin: EdgeInsets.only(bottom: 20),
                              // color: Colors.amber.shade200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Location",
                                    style: textStyles.lato_regular(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                  Text(
                                    "${loc.munName}",
                                    style: textStyles.lato_regular(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: double.maxFinite,
                                    child: DataTable(
                                        border: TableBorder.all(
                                            width: 1,
                                            color: Colors.grey.shade500,
                                            style: BorderStyle.solid),
                                        columns: const [
                                          DataColumn(label: Text("Day No.")),
                                          DataColumn(
                                              label: Text("Date Recorded")),
                                          DataColumn(label: Text("Windspeed")),
                                          DataColumn(label: Text("Rainfall")),
                                          DataColumn(
                                              label: Text("Damage Cost")),
                                        ],
                                        rows: loc.days
                                            .map((day) => DataRow(cells: [
                                                  DataCell(
                                                      Text(day.day.toString())),
                                                  DataCell(Text(
                                                      "${DateTime.parse(day.dateRecorded).month}/${DateTime.parse(day.dateRecorded).day}/${DateTime.parse(day.dateRecorded).year}")),
                                                  DataCell(Text(day.windSpeed
                                                      .toString())),
                                                  DataCell(Text(
                                                      day.rainfall.toString())),
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
                          }))
                ],
              ),
            ),
          ),
        ));
  }

  // Future<Typhoon> getTyphoon(String typhoonID) async {
  //   DocumentSnapshot v = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc('test-user')
  //       .collection('typhoons')
  //       .doc(typhoonID)
  //       .get();
  //   return Typhoon.fromJson(v.data() as Map<String, dynamic>);
  // }

  // Future<List<Location>> getDistinctLocations(String typhoonID) async {
  //   QuerySnapshot v = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc('test-user')
  //       .collection('typhoons')
  //       .doc(typhoonID)
  //       .collection('days')
  //       .orderBy('dateRecorded')
  //       .get();

  //   List<Location> notDistinctLocations = v.docs.map((doc) {
  //     final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  //     return Location(code: data['locationCode'], name: data['location']);
  //   }).toList();

  //   Set<Location> distinctLocationsSet = notDistinctLocations.toSet();

  //   List<Location> distinctLocationsList = distinctLocationsSet.toList();
  //   List<TyphoonDay> days = v.docs
  //       .map((doc) => TyphoonDay.fromJson(doc.data() as Map<String, dynamic>))
  //       .toList();

  //   for (int i = 0; i < days.length; i++) {
  //     for (Location loc in distinctLocationsList) {
  //       if (days[i].locationCode == loc.code) {
  //         loc.days.add(days[i]);
  //       }
  //     }
  //   }

  //   for (int i = 0; i < distinctLocationsList.length; i++) {
  //     double total = 0;
  //     for (TyphoonDay day in distinctLocationsList[i].days) {
  //       total += day.damageCost;
  //     }
  //     distinctLocationsList[i].totalDamageCost += total;
  //   }
  //   setState(() {
  //     // distinctLocations = distinctLocationsList;
  //   });
  //   return distinctLocationsList;
  // }
}
