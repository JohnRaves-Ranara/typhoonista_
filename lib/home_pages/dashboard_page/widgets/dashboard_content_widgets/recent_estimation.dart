import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/entities/TyphoonDay.dart';
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
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 55,
      child: Container(
        // color: Colors.purple,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  "RECENT ESTIMATION",
                  style:
                      textStyles.lato_bold(color: Colors.black, fontSize: 15),
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
                            double containerHeight = constraints.maxHeight;
                            double containerWidth = constraints.maxWidth;
                            return StreamBuilder<TyphoonDay>(
                                stream:
                                    FirestoreService().streamRecentEstimation(),
                                builder: (context, snapshot) {
                                  
                                  if (snapshot.hasData) {
                                    TyphoonDay recentEstimation = snapshot.data!;
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
                                            "Typhoon ${recentEstimation.typhoonName}    |    ${recentEstimation.location}    |    Day ${recentEstimation.day}",
                                            style: textStyles.lato_bold(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          Text(
                                            "₱ ${recentEstimation.damageCost.toStringAsFixed(2)}",
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
                                  }else{
                                    return Text("EMPTY");
                                  }
                                });
                          },
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: LayoutBuilder(builder: (context, constraints) {
                          double containerHeight = constraints.maxHeight;
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Material(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xffe50202),
                                    child: Ink(
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(10),
                                        onTap: (() {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  title: Text(
                                                      "Delete confirmation",
                                                      style:
                                                          textStyles.lato_black(
                                                              fontSize: 20)),
                                                  content: Text(
                                                    "Are you sure you want to delete this computation?",
                                                    style:
                                                        textStyles.lato_regular(
                                                            fontSize: 20),
                                                  ),
                                                  actions: [
                                                    Container(
                                                      height: 40,
                                                      child: TextButton(
                                                          style: TextButton.styleFrom(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10))),
                                                          onPressed: (() {
                                                            Navigator.pop(
                                                                context);
                                                          }),
                                                          child: Text("Cancel",
                                                              style: textStyles
                                                                  .lato_regular(
                                                                      fontSize:
                                                                          16))),
                                                    ),
                                                    Container(
                                                      height: 40,
                                                      child: TextButton(
                                                          style: TextButton.styleFrom(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10))),
                                                          onPressed: (() {
                                                            Navigator.pop(
                                                                context);
                                                          }),
                                                          child: Text("Delete",
                                                              style: textStyles
                                                                  .lato_regular(
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
                                            style: textStyles.lato_regular(
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
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    child: Ink(
                                      child: InkWell(
                                        onTap: (() {}),
                                        borderRadius: BorderRadius.circular(10),
                                        child: Center(
                                          child: Text(
                                            "GENERATE REPORT",
                                            style: textStyles.lato_regular(
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
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    child: Ink(
                                      child: InkWell(
                                        onTap: (() {
                                          //todo - tochange
                                          List<DamageCostBar> newDamageCosts = [
                                            DamageCostBar("Gerome", 6942069),
                                            DamageCostBar("Bruh!", 8102934),
                                            DamageCostBar("Hulu", 2187659),
                                            DamageCostBar("Gerome", 6942069),
                                            DamageCostBar("Bruh!", 8102934),
                                            DamageCostBar("Hulu", 2187659)
                                          ];
                                          context
                                              .read<SampleProvider>()
                                              .changeDamageCostBarsList(
                                                  newDamageCosts);
                                          print(context
                                              .read<SampleProvider>()
                                              .damageCostBars);
                                        }),
                                        borderRadius: BorderRadius.circular(10),
                                        child: Center(
                                          child: Text(
                                            "ADD DAY",
                                            style: textStyles.lato_regular(
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
      ),
    );
  }
}
