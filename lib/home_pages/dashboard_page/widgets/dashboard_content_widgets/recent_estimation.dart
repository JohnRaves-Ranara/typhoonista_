import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:typhoonista_thesis/entities/Location.dart';
import 'package:typhoonista_thesis/entities/Typhoon.dart';
import 'package:typhoonista_thesis/entities/TyphoonDay.dart';
import 'package:typhoonista_thesis/main.dart';
import 'package:typhoonista_thesis/providers/TyphoonProvider.dart';
import 'package:typhoonista_thesis/services/FirestoreService.dart';
import 'package:typhoonista_thesis/services/locations.dart';
import 'package:typhoonista_thesis/services/pdfGeneratorService.dart';
import '../../../../providers/sample_provider.dart';
import 'package:provider/provider.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';
import 'package:typhoonista_thesis/entities/DamageCostBar.dart';

class recent_estimation extends StatefulWidget {
  const recent_estimation({super.key});

  @override
  State<recent_estimation> createState() => _recent_estimationState();
}

class _recent_estimationState extends State<recent_estimation> {
  final windspeedCtlr = TextEditingController();
  final rainfallCtlr = TextEditingController();
  String selectedLocation = "Choose Location";
  String selectedLocationCode = "";
  TyphoonDay? newlyAddedDayInformation;
  bool haveAdded = false;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 55,
      child: StreamBuilder<Typhoon>(
          stream: FirestoreService().streamRecentEstimation(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Typhoon recentEstimation = snapshot.data!;
              return Container(
                // color: Colors.purple,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          "ONGOING TYPHOON ESTIMATION",
                          style: textStyles.lato_bold(
                              color: Colors.black, fontSize: 15),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(26),
                              color: Color(0xff0690d7)),
                          child: Column(
                            children: [
                              Expanded(
                                flex: 7,
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    double containerHeight =
                                        constraints.maxHeight;
                                    double containerWidth =
                                        constraints.maxWidth;
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: containerWidth * 0.04,
                                          vertical: containerHeight * 0.15),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(26),
                                          color: Color(0xff02a0f1)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Typhoon ${recentEstimation.typhoonName}    |    Day ${recentEstimation.currentDay}",
                                            style: textStyles.lato_bold(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          Text(
                                            "₱ ${NumberFormat('#,##0.00', 'en_US').format(recentEstimation.totalDamageCost)}",
                                            style: textStyles.lato_bold(
                                                color: Colors.white,
                                                fontSize: 45),
                                          ),
                                          Text(
                                            "Estimated Total Damage to Rice Crops in the Philippines",
                                            style: textStyles.lato_light(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: LayoutBuilder(
                                    builder: (context, constraints) {
                                  double containerHeight =
                                      constraints.maxHeight;
                                  double containerWidth = constraints.maxWidth;
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: containerHeight * 0.2,
                                        horizontal: containerWidth * 0.04),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(26),
                                          bottomRight: Radius.circular(26)),
                                      // color: Colors.blue
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Material(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Color(0xffd60000),
                                            child: Ink(
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                onTap: (() {
                                                  showDeleteComputationDialog();
                                                }),
                                                child: Center(
                                                  child: Text(
                                                    "DELETE COMPUTATION",
                                                    style:
                                                        textStyles.lato_regular(
                                                            color: Colors.white,
                                                            fontSize: 10),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                          child: Material(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.white,
                                            child: Ink(
                                              child: InkWell(
                                                onTap: (() {
                                                  showGenerateReportDialog(
                                                      recentEstimation.id);
                                                }),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Center(
                                                  child: Text(
                                                    "MARK AS FINISHED",
                                                    style:
                                                        textStyles.lato_regular(
                                                            color: Colors.black,
                                                            fontSize: 10),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                          child: Material(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.white,
                                            child: Ink(
                                              child: InkWell(
                                                onTap: (() {
                                                  showDialog(
                                                    // barrierDismissible: false,
                                                    //todo barrierdismissable, add close button, and when clost button is clicked, clear selectedloc.
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          content:
                                                              StatefulBuilder(
                                                            builder: (context,
                                                                customState) {
                                                              return Container(
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20)),
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.8,
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.6,
                                                                child: Row(
                                                                  children: [
                                                                    add_day(
                                                                        recentEstimation,
                                                                        customState),
                                                                    Information(
                                                                        customState)
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      });
                                                }),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Center(
                                                  child: Text(
                                                    "ADD DAY",
                                                    style:
                                                        textStyles.lato_regular(
                                                            color: Colors.black,
                                                            fontSize: 10),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              )
                            ],
                          )),
                    )
                  ],
                ),
              );
            } else {
              return Text("EMPTY");
            }
          }),
    );
  }

  showDeleteComputationDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actionsPadding: EdgeInsets.only(left: 30, right: 30, bottom: 30),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.1,
              height: MediaQuery.of(context).size.height * 0.2,
              child: Center(
                  child: RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                    text: "Deleting a computation ",
                    style: textStyles.lato_regular(
                        fontSize: 20, color: Color(0xffAD0000)),
                    children: [
                      TextSpan(
                          text:
                              "will erase all of its estimations. Do you wish to proceed? ",
                          style: textStyles.lato_regular(color: Colors.black)),
                      TextSpan(
                          text: "(If the Typhoon is finished, you can choose 'Mark as Finished' instead)",
                          style:
                              textStyles.lato_regular(color: Color(0xffAD0000)))
                    ]),
              )),
            ),
            actions: [
              ButtonBar(
                children: [
                  InkWell(
                    onTap: (() {
                      Navigator.pop(context);
                    }),
                    child: Container(
                      height: 60,
                      width: 185,
                      color: Color(0xff00109F),
                      child: Center(
                        child: Text(
                          "Cancel",
                          style: textStyles.lato_regular(
                              fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: (() async {
                      await FirestoreService().deleteTyphoon();
                      Navigator.pop(context);
                    }),
                    child: Container(
                      height: 60,
                      width: 185,
                      color: Color(0xffAD0000),
                      child: Center(
                        child: Text(
                          "Delete",
                          style: textStyles.lato_regular(
                              fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  showGenerateReportDialog(String typhoonID) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actionsPadding: EdgeInsets.only(left: 30, right: 30, bottom: 30),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.1,
              height: MediaQuery.of(context).size.height * 0.2,
              child: Center(
                  child: RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                    text: "This will ",
                    style: textStyles.lato_regular(
                        fontSize: 20, color: Colors.black),
                    children: [
                      TextSpan(
                          text:
                              "mark this typhoon as 'Finished'. ",
                          style: textStyles.lato_regular(color: Color(0xffAD0000))),
                      TextSpan(
                          text:
                              "Would you like to continue? ",
                          style:
                              textStyles.lato_regular(color: Colors.black)),
                      TextSpan(
                          text:
                              "(Please note that this action is irreversible and will remove this typhoon from the ongoing typhoon estimation)",
                          style:
                              textStyles.lato_regular(color: Color(0xffAD0000)))
                    ]),
              )),
            ),
            actions: [
              ButtonBar(
                children: [
                  InkWell(
                    onTap: (() {
                      Navigator.pop(context);
                    }),
                    child: Container(
                      height: 60,
                      width: 185,
                      color: Color(0xff00109F),
                      child: Center(
                        child: Text(
                          "Cancel",
                          style: textStyles.lato_regular(
                              fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: (() async {
                      // pdfGeneratorService().generateSamplePDF();
                      FirestoreService()
                          .updateTyphoonStatusAsFinished(typhoonID);
                      Navigator.pop(context);
                    }),
                    child: Container(
                      height: 60,
                      width: 185,
                      color: Color(0xffAD0000),
                      child: Center(
                        child: Text(
                          "Generate",
                          style: textStyles.lato_regular(
                              fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  Widget add_day(Typhoon recentEstimation, Function customState) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(),
              Text(
                "Add Day",
                style: textStyles.lato_black(fontSize: 35),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                // color: Colors.purple,
                height: MediaQuery.of(context).size.height * 0.28,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextField(
                      enabled: !haveAdded,
                      controller: windspeedCtlr,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          labelStyle: textStyles.lato_light(
                              color: Colors.grey.withOpacity(0.9)),
                          border: OutlineInputBorder(),
                          labelText: "Windspeed"),
                    ),
                    TextField(
                      enabled: !haveAdded,
                      controller: rainfallCtlr,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          labelStyle: textStyles.lato_light(
                              color: Colors.grey.withOpacity(0.9)),
                          border: OutlineInputBorder(),
                          labelText: "Rainfall"),
                    ),
                    InkWell(
                      onTap: !haveAdded
                          ? (() {
                              showChooseLocationDialog(recentEstimation.id, customState);
                            })
                          : null,
                      child: Container(
                        height: 60,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: Colors.grey.shade600,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                selectedLocation,
                                style: textStyles.lato_regular(fontSize: 17),
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                size: 22,
                                color: Colors.black,
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Material(
                  color: (haveAdded) ? Colors.grey : Colors.blue,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: (haveAdded)
                        ? null
                        : (() async {
                            final addDay = await FirestoreService().addDay(
                                typhoonName: recentEstimation.typhoonName,
                                windSpeed:
                                    double.parse(windspeedCtlr.text.trim()),
                                rainfall:
                                    double.parse(rainfallCtlr.text.trim()),
                                location: selectedLocation,
                                locationCode: selectedLocationCode,
                                isFirstDay: false,
                                typhoonId: recentEstimation.id);
                            windspeedCtlr.clear();
                            rainfallCtlr.clear();
                            customState(() {
                              haveAdded = true;
                              newlyAddedDayInformation = addDay;
                              selectedLocation = "Choose Location";
                              selectedLocationCode = "";
                            });
                          }),
                    child: Ink(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      width: double.maxFinite,
                      height: 55,
                      child: Row(
                        children: [
                          Text(
                            "Estimate Damage Cost",
                            style: textStyles.lato_bold(
                                fontSize: 18, color: Colors.white),
                          ),
                          Spacer(),
                          Icon(
                            Icons.arrow_right_alt_sharp,
                            size: 40,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Spacer()
            ],
          ),
        ),
      ),
    );
  }

  Widget Information(Function customState) {
    return Expanded(
      child: Container(
        // constraints: BoxConstraints(minHeight: 100),
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Estimation",
              style: textStyles.lato_black(fontSize: 35),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.28),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: (haveAdded)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Typhoon Name::',
                            style: textStyles.lato_light(fontSize: 12),
                          ),
                          Text(
                            '${newlyAddedDayInformation!.typhoonName}',
                            style: textStyles.lato_black(fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Predicted Damage Cost:',
                            style: textStyles.lato_light(fontSize: 12),
                          ),
                          Text(
                            '${newlyAddedDayInformation!.damageCost}',
                            style: textStyles.lato_black(fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Day:',
                            style: textStyles.lato_light(fontSize: 12),
                          ),
                          Text(
                            '${newlyAddedDayInformation!.day}',
                            style: textStyles.lato_black(fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Date Recorded:',
                            style: textStyles.lato_light(fontSize: 12),
                          ),
                          Text(
                            '${newlyAddedDayInformation!.dateRecorded}',
                            style: textStyles.lato_black(fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Windspeed:',
                            style: textStyles.lato_light(fontSize: 12),
                          ),
                          Text(
                            '${newlyAddedDayInformation!.windSpeed}',
                            style: textStyles.lato_black(fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Rainfall:',
                            style: textStyles.lato_light(fontSize: 12),
                          ),
                          Text(
                            '${newlyAddedDayInformation!.rainfall}',
                            style: textStyles.lato_black(fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Location:',
                            style: textStyles.lato_light(fontSize: 12),
                          ),
                          Text(
                            '${newlyAddedDayInformation!.location}',
                            style: textStyles.lato_black(fontSize: 16),
                          ),
                        ],
                      )
                    : SizedBox()),
            SizedBox(
              height: 20,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Material(
                color: (haveAdded) ? Colors.blue : Colors.grey,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: (haveAdded)
                      ? (() {
                          customState(() {
                            haveAdded = false;
                            newlyAddedDayInformation = null;
                          });
                          Navigator.pop(context);
                        })
                      : null,
                  child: Ink(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    width: double.maxFinite,
                    height: 55,
                    child: Row(
                      children: [
                        Text(
                          "Proceed",
                          style: textStyles.lato_bold(
                              fontSize: 18, color: Colors.white),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_right_alt_sharp,
                          size: 40,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showChooseLocationDialog(String typhoonID, Function customState ) async{
    showDialog(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height*0.2,
            width: MediaQuery.of(context).size.width*0.2,
            child: AlertDialog(
                content: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc('test-user')
                  .collection('typhoons')
                  .doc(typhoonID)
                  .collection('days')
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<TyphoonDay> days = snapshot.data!.docs
                      .map((doc) =>
                          TyphoonDay.fromJson(doc.data() as Map<String, dynamic>))
                      .toList();
                // List locationsInFirestore = days.map((day) => day.location).toList();
                List<Location> locationsLocal = Locations().locationsJson;
            
                List<Location> unavailableLocations = [];
                for(TyphoonDay day in days){
                  DateTime current = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
                  DateTime dateRecorded = DateTime(DateTime.parse(day.dateRecorded).year, DateTime.parse(day.dateRecorded).month, DateTime.parse(day.dateRecorded).day);
                  if(dateRecorded.isAtSameMomentAs(current)){
                    Location loc = Location(name: day.location, code: day.locationCode!);
                    unavailableLocations.add(loc);
                  }
                }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(locationsLocal.length, (index) {
                      bool isTheLocationUnavailable = false;
                      for(Location i in unavailableLocations){
                        if(i.code==locationsLocal[index].code){
                          isTheLocationUnavailable = true;
                        }
                      }
                      if(isTheLocationUnavailable==true){
                        return ListTile(
                          title: Text(locationsLocal[index].name!),
                          tileColor: Colors.grey,
                          onTap: null,
                        );
                      }
                      else{
                        return ListTile(
                          title: Text(locationsLocal[index].name!),
                          tileColor: Colors.green,
                          onTap: ((){
                            customState(() {
                              selectedLocation = locationsLocal[index].name!;
                              selectedLocationCode = locationsLocal[index].code!;
                            });
                            Navigator.pop(context);
                          }),
                        );
                      }
                    })

                  );
                }
                else{
                  return  Text("no data");
                }
              },
            )),
          );
        });
  }
}
