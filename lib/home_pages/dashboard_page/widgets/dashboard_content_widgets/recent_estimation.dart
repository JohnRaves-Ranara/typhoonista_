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
                          "RECENT ESTIMATION",
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
                                            "Typhoon ${recentEstimation.typhoonName}    |    ${recentEstimation.location}    |    Day ${recentEstimation.currentDay}",
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
                                            "Estimated Total Damage to Rice Crops",
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
                                                          content: Container(
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20)),
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.7,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.6,
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            40),
                                                                    child:
                                                                        Container(
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Spacer(),
                                                                          Text(
                                                                            "Add Day",
                                                                            style:
                                                                                textStyles.lato_black(fontSize: 35),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                20,
                                                                          ),
                                                                          Container(
                                                                            child:
                                                                                Column(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                TextField(
                                                                                  controller: windspeedCtlr,
                                                                                  decoration: InputDecoration(fillColor: Colors.white, labelStyle: textStyles.lato_light(color: Colors.grey.withOpacity(0.9)), border: OutlineInputBorder(), labelText: "Windspeed"),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 15,
                                                                                ),
                                                                                TextField(
                                                                                  controller: rainfallCtlr,
                                                                                  decoration: InputDecoration(fillColor: Colors.white, labelStyle: textStyles.lato_light(color: Colors.grey.withOpacity(0.9)), border: OutlineInputBorder(), labelText: "Rainfall"),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 15,
                                                                                ),
                                                                                TextField(
                                                                                  controller: locationCtlr,
                                                                                  decoration: InputDecoration(labelStyle: textStyles.lato_light(color: Colors.grey.withOpacity(0.9)), border: OutlineInputBorder(), labelText: "Location"),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                20,
                                                                          ),
                                                                          ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8),
                                                                            child:
                                                                                Material(
                                                                              color: Colors.blue,
                                                                              child: InkWell(
                                                                                borderRadius: BorderRadius.circular(8),
                                                                                onTap: (() async {
                                                                                  FirestoreService().addDay(typhoonName: recentEstimation.typhoonName, windSpeed: double.parse(windspeedCtlr.text.trim()), rainfall: double.parse(rainfallCtlr.text.trim()), location: locationCtlr.text.trim(), isFirstDay: false, typhoonId: recentEstimation.id);
                                                                                  windspeedCtlr.clear();
                                                                                  rainfallCtlr.clear();
                                                                                  locationCtlr.clear();
                                                                                  Navigator.pop(context);
                                                                                }),
                                                                                child: Ink(
                                                                                  padding: EdgeInsets.symmetric(horizontal: 30),
                                                                                  width: double.maxFinite,
                                                                                  height: 55,
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Text(
                                                                                        "Estimate Damage Cost",
                                                                                        style: textStyles.lato_bold(fontSize: 18, color: Colors.white),
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
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          "Information",
                                                                          style:
                                                                              textStyles.lato_black(fontSize: 35),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              20,
                                                                        ),
                                                                        Container(
                                                                          height:
                                                                              MediaQuery.of(context).size.height * 0.3,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius:
                                                                                BorderRadius.circular(20),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              20,
                                                                        ),
                                                                        ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8),
                                                                          child:
                                                                              Material(
                                                                            color:
                                                                                Colors.blue,
                                                                            child:
                                                                                InkWell(
                                                                              borderRadius: BorderRadius.circular(8),
                                                                              onTap: (() {}),
                                                                              child: Ink(
                                                                                padding: EdgeInsets.symmetric(horizontal: 30),
                                                                                width: double.maxFinite,
                                                                                height: 55,
                                                                                child: Row(
                                                                                  children: [
                                                                                    Text(
                                                                                      "Proceed",
                                                                                      style: textStyles.lato_bold(fontSize: 18, color: Colors.white),
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
                                                                ),
                                                              ],
                                                            ),
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
}
