import 'dart:html';

import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/entities/Typhoon.dart';
import 'package:typhoonista_thesis/entities/TyphoonDay.dart';
import 'package:typhoonista_thesis/main.dart';
import 'package:typhoonista_thesis/providers/TyphoonProvider.dart';
import 'package:typhoonista_thesis/services/FirestoreService.dart';
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
  final locationCtlr = TextEditingController();
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
                          "RECENT TYPHOON ESTIMATION",
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
                              color: Color(0xffA31212)),
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
                                          color: Color(0xffe50202)),
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
                                            "₱ ${recentEstimation.totalDamageCost.toStringAsFixed(2)}",
                                            style: textStyles.lato_black(
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
                                            color: Color(0xffe50202),
                                            child: Ink(
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                onTap: (() {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          title: Text(
                                                              "Delete confirmation",
                                                              style: textStyles
                                                                  .lato_black(
                                                                      fontSize:
                                                                          20)),
                                                          content: Text(
                                                            "Are you sure you want to delete this computation?",
                                                            style: textStyles
                                                                .lato_regular(
                                                                    fontSize:
                                                                        20),
                                                          ),
                                                          actions: [
                                                            Container(
                                                              height: 40,
                                                              child: TextButton(
                                                                  style: TextButton.styleFrom(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                              10))),
                                                                  onPressed:
                                                                      (() {
                                                                    Navigator.pop(
                                                                        context);
                                                                  }),
                                                                  child: Text(
                                                                      "Cancel",
                                                                      style: textStyles.lato_regular(
                                                                          fontSize:
                                                                              16))),
                                                            ),
                                                            Container(
                                                              height: 40,
                                                              child: TextButton(
                                                                  style: TextButton.styleFrom(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                              10))),
                                                                  onPressed:
                                                                      (() {
                                                                    Navigator.pop(
                                                                        context);
                                                                  }),
                                                                  child: Text(
                                                                      "Delete",
                                                                      style: textStyles.lato_regular(
                                                                          fontSize:
                                                                              16))),
                                                            )
                                                          ],
                                                        );
                                                      });
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
                                                onTap: (() {}),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Center(
                                                  child: Text(
                                                    "GENERATE REPORT",
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
                                                                    Information(customState)
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
                    TextField(
                      enabled: !haveAdded,
                      controller: locationCtlr,
                      decoration: InputDecoration(
                          labelStyle: textStyles.lato_light(
                              color: Colors.grey.withOpacity(0.9)),
                          border: OutlineInputBorder(),
                          labelText: "Location"),
                    ),
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
                        : (() async{
                            final addDay = await FirestoreService().addDay(
                                typhoonName: recentEstimation.typhoonName,
                                windSpeed:
                                    double.parse(windspeedCtlr.text.trim()),
                                rainfall:
                                    double.parse(rainfallCtlr.text.trim()),
                                location: locationCtlr.text.trim(),
                                isFirstDay: false,
                                typhoonId: recentEstimation.id);
                            windspeedCtlr.clear();
                            rainfallCtlr.clear();
                            locationCtlr.clear();
                            customState(() {
                              haveAdded = true;
                              newlyAddedDayInformation = addDay;
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
              "Information",
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
                  onTap: (haveAdded) ? (() {
                    customState((){
                      haveAdded = false;
                      newlyAddedDayInformation = null;
                    });
                    Navigator.pop(context);
                    
                  }) : null,
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
}
