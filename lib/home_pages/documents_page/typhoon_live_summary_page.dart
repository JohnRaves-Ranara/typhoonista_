import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typhoonista_thesis/entities/Location.dart';
import 'package:typhoonista_thesis/entities/Typhoon.dart';
import 'package:typhoonista_thesis/entities/TyphoonDay.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:typhoonista_thesis/providers/page_provider.dart';
import 'package:typhoonista_thesis/services/FirestoreService.dart';
import 'package:typhoonista_thesis/services/locations.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';

class typhoon_live_summary_page extends StatefulWidget {
  const typhoon_live_summary_page({super.key});

  @override
  State<typhoon_live_summary_page> createState() =>
      _typhoon_live_summary_pageState();
}

class _typhoon_live_summary_pageState extends State<typhoon_live_summary_page> {
  List<Location> distinctLocations = [];
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      color: Colors.grey.shade800,
      child: Consumer<page_provider>(
        builder: (context, prov, child){
          final Typhoon selectedTyphoon = prov.selectedTyphoon!;
          return SingleChildScrollView(
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              padding: EdgeInsets.symmetric(horizontal: 35, vertical: 40),
              decoration: BoxDecoration(
                color: Colors.white,
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
                        (selectedTyphoon.status == 'ongoing')? 
                        Row(
                          children: [
                        CircleAvatar(backgroundColor: Colors.red, radius: 6 ,),
                        SizedBox(width: 10,),
                            Text(
                          "Typhoon Live Summary Report",
                          style: textStyles.lato_bold(fontSize: 16),
                        ),
                          ],
                        )
                        :
                        Text(
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
                        future: FirestoreService().getTyphoon(selectedTyphoon.id),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final Typhoon typhoon = snapshot.data!;
                            TextStyle titleStyle = textStyles.lato_regular(
                                color: Colors.grey, fontSize: 14);
                            TextStyle valueStyle = textStyles.lato_regular(
                                color: Colors.black, fontSize: 14);
                            return Container(
                              // color: Colors.green,
                              height: 280,
                              child: Row(
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
                                              Text("Total Damage To Rice Crops",
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
                                                    CrossAxisAlignment.start,
                                                children: (distinctLocations
                                                        .isEmpty)
                                                    ? [Text('Loading...')]
                                                    : distinctLocations
                                                        .map((loc) => Text(
                                                              "• ${loc.name}",
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
                            );
                          } else {
                            return Text("no data");
                          }
                        }),
                  ),
                  Container(
                    width: double.maxFinite,
                    child: FutureBuilder<List<Location>>(
                      future: getDistinctLocations(selectedTyphoon.id),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final List<Location> locations = snapshot.data!;
        
                          return Column(
                            children: locations.map((loc) {
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
                                      "${loc.name}",
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
        );
        },
      ),
    );
  }

  Future<List<Location>> getDistinctLocations(String typhoonID) async {
    QuerySnapshot daysSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc('test-user')
        .collection('typhoons')
        .doc(typhoonID)
        .collection('days')
        .orderBy('dateRecorded')
        .get();

    //taking all the locations from firestore
    List<Location> notDistinctLocations = daysSnapshot.docs.map((doc) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Location(code: data['locationCode'], name: data['location']);
    }).toList();

    //to remove duplicates
    Set<Location> distinctLocationsSet = notDistinctLocations.toSet();

    List<Location> distinctLocationsList = distinctLocationsSet.toList();
    List<TyphoonDay> days = daysSnapshot.docs
        .map((doc) => TyphoonDay.fromJson(doc.data() as Map<String, dynamic>))
        .toList();

    //to set the TyphoonDays inside each distinct location
    for (int i = 0; i < days.length; i++) {
      for (Location loc in distinctLocationsList) {
        if (days[i].locationCode == loc.code) {
          loc.days.add(days[i]);
        }
      }
    }

    //for tallying per-location total dmgcost
    for (int i = 0; i < distinctLocationsList.length; i++) {
      double total = 0;
      for (TyphoonDay day in distinctLocationsList[i].days) {
        total += day.damageCost;
      }
      distinctLocationsList[i].totalDamageCost += total;
    }
    setState(() {
      distinctLocations = distinctLocationsList;
    });
    return distinctLocationsList;
  }

  
}