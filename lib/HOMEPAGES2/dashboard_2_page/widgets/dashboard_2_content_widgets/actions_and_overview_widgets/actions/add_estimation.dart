import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';

class add_estimation extends StatefulWidget {
  const add_estimation({super.key});

  @override
  State<add_estimation> createState() => _add_estimationState();
}

class _add_estimationState extends State<add_estimation> {
  bool haveAdded = false;
  final windspeedCtlr = TextEditingController();
  final rainfall6Ctlr = TextEditingController();
  final rainfall24Ctlr = TextEditingController();
  final ricePriceCtlr = TextEditingController();
  final manualDistanceCtrlr = TextEditingController();
  final riceAreaCtrlr = TextEditingController();
  final yieldCtrlr = TextEditingController();
  final locationCtrlr = TextEditingController();
  final distanceCtrlr = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: InkWell(
      onTap: (() {
        showDialog(
            // barrierDismissible: false,
            //todo barrierdismissable, add close button, and when clost button is clicked, clear selectedloc.
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                content: StatefulBuilder(
                  builder: (context, customState) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            width:
                                // (isEstimationSuccess)
                                //     ? MediaQuery.of(context).size.width * 0.4
                                //     :
                                MediaQuery.of(context).size.width * 0.5,
                            child:
                                // (isFetchingPrediction)
                                //     ? fetchingPrediction()
                                //     : (isAddingTyphoon)
                                //         ? addingToDatabase()
                                //         : (isEstimationError)
                                //             ? estimationError(
                                //                 errorMessage!, customState)
                                //             : (isEstimationSuccess)
                                //                 ? Information(customState)
                                //                 :
                                add_day(
                                    // recentEstimation,
                                    customState)),
                      ],
                    );
                  },
                ),
              );
            });
      }),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                // color: Colors.red,
                child: Image.asset(
              'lib/assets/images/basil_add-outline.png',
              height: 24,
            )),
            Text(
              'Add Estimation',
              style: textStyles.lato_bold(fontSize: 16),
            ),
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: Offset(0, 3),
              blurRadius: 2,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    ));
  }

  Widget add_day(
      // Typhoon recentEstimation,
      Function customState) {
    return Container(
      // color: Colors.amber,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
          ),
          Text(
            "Add Estimation",
            style: textStyles.lato_black(fontSize: 35),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  // color: Colors.purple,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextField(
                        style: textStyles.lato_regular(),
                        enabled: !haveAdded,
                        controller: windspeedCtlr,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
                            fillColor: Colors.white,
                            labelStyle:
                                textStyles.lato_light(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Colors.grey.shade600.withOpacity(0.5),
                                    width: 1,
                                    style: BorderStyle.solid)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade600,
                                    width: 1,
                                    style: BorderStyle.solid)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Colors.grey.shade600.withOpacity(0.5),
                                    width: 1,
                                    style: BorderStyle.solid)),
                            labelText: "Peak Windspeed"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        style: textStyles.lato_regular(),
                        enabled: !haveAdded,
                        controller: rainfall24Ctlr,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
                            fillColor: Colors.white,
                            labelStyle:
                                textStyles.lato_light(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Colors.grey.shade600.withOpacity(0.5),
                                    width: 1,
                                    style: BorderStyle.solid)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade600,
                                    width: 1,
                                    style: BorderStyle.solid)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Colors.grey.shade600.withOpacity(0.5),
                                    width: 1,
                                    style: BorderStyle.solid)),
                            labelText: "Peak Rainfall (24H)"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        style: textStyles.lato_regular(),
                        enabled: !haveAdded,
                        controller: rainfall6Ctlr,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
                            fillColor: Colors.white,
                            labelStyle:
                                textStyles.lato_light(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Colors.grey.shade600.withOpacity(0.5),
                                    width: 1,
                                    style: BorderStyle.solid)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade600,
                                    width: 1,
                                    style: BorderStyle.solid)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Colors.grey.shade600.withOpacity(0.5),
                                    width: 1,
                                    style: BorderStyle.solid)),
                            labelText: "Peak Rainfall (6H)"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        style: textStyles.lato_regular(),
                        enabled: !haveAdded,
                        controller: ricePriceCtlr,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
                            fillColor: Colors.white,
                            labelStyle:
                                textStyles.lato_light(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Colors.grey.shade600.withOpacity(0.5),
                                    width: 1,
                                    style: BorderStyle.solid)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade600,
                                    width: 1,
                                    style: BorderStyle.solid)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Colors.grey.shade600.withOpacity(0.5),
                                    width: 1,
                                    style: BorderStyle.solid)),
                            labelText: "Rice Price (per kilo)"),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Container(
                  child: Column(
                    children: [
                      TextField(
                        style: textStyles.lato_regular(),
                        enabled: !haveAdded,
                        controller: riceAreaCtrlr,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
                            fillColor: Colors.white,
                            labelStyle:
                                textStyles.lato_light(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Colors.grey.shade600.withOpacity(0.5),
                                    width: 1,
                                    style: BorderStyle.solid)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade600,
                                    width: 1,
                                    style: BorderStyle.solid)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Colors.grey.shade600.withOpacity(0.5),
                                    width: 1,
                                    style: BorderStyle.solid)),
                            labelText: "Rice Area (ha)"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        style: textStyles.lato_regular(),
                        enabled: !haveAdded,
                        controller: windspeedCtlr,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
                            fillColor: Colors.white,
                            labelStyle:
                                textStyles.lato_light(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Colors.grey.shade600.withOpacity(0.5),
                                    width: 1,
                                    style: BorderStyle.solid)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade600,
                                    width: 1,
                                    style: BorderStyle.solid)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Colors.grey.shade600.withOpacity(0.5),
                                    width: 1,
                                    style: BorderStyle.solid)),
                            labelText: "Yield (ton/ha)"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: (() {
                          showChooseLocationDialog(
                            customState,
                            // recentEstimation.id
                          );
                        }),
                        child: Container(
                          height: 48,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1,
                                  color: Colors.grey.shade600.withOpacity(0.5),
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Select Location',
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
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: (() {
                          // showDistrackminOptions(customState);
                        }),
                        child: Container(
                          height: 48,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1,
                                  color: Colors.grey.shade600.withOpacity(0.5),
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Distance of Typhoon to Location',
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
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Material(
              color: Colors.blue,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: (() {}),
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
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  showChooseLocationDialog(Function customState) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.3,
            child: Container(color: Colors.white),
            // child: StatefulBuilder(
            //   builder: (context, customState2) {
            //     return Column(
            //       children: [
            //         (isSearchLocation)
            //             ? Container(
            //                 child: Row(
            //                   children: [
            //                     Expanded(
            //                       child: TextField(
            //                         autofocus: true,
            //                         style: textStyles.lato_regular(
            //                             fontSize: 14, color: Colors.black),
            //                         maxLength: 30,
            //                         decoration: InputDecoration(
            //                             border: InputBorder.none,
            //                             hintText: "Search Location...",
            //                             counterText: ""),
            //                         controller: ctrlr,
            //                         onChanged: (value) =>
            //                             searchbook(value.trim(), customState2),
            //                       ),
            //                     ),
            //                     InkWell(
            //                       borderRadius: BorderRadius.circular(50),
            //                       onTap: (() {
            //                         customState2(() {
            //                           isSearchLocation = false;
            //                           ctrlr.clear();
            //                         });
            //                       }),
            //                       child: Container(
            //                         margin: EdgeInsets.all(10),
            //                         decoration: BoxDecoration(
            //                             borderRadius:
            //                                 BorderRadius.circular(50)),
            //                         child: Icon(Icons.close),
            //                       ),
            //                     )
            //                   ],
            //                 ),
            //               )
            //             : Container(
            //                 child: Row(
            //                   crossAxisAlignment: CrossAxisAlignment.center,
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   children: [
            //                     Container(
            //                       child: Row(
            //                         children: [
            //                           Text(
            //                             'Select Typhoon Municipality',
            //                             style:
            //                                 textStyles.lato_bold(fontSize: 16),
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                     InkWell(
            //                       borderRadius: BorderRadius.circular(50),
            //                       onTap: (() {
            //                         customState2(() {
            //                           isSearchLocation = true;
            //                         });
            //                       }),
            //                       child: Container(
            //                         margin: EdgeInsets.all(10),
            //                         decoration: BoxDecoration(
            //                             borderRadius:
            //                                 BorderRadius.circular(50)),
            //                         child: Icon(Icons.search),
            //                       ),
            //                     )
            //                   ],
            //                 ),
            //               ),
            //         Divider(
            //           color: Colors.grey.shade700,
            //         ),
            //         Expanded(
            //           child: ListView(
            //             primary: false,
            //             children: (ctrlr.text.trim() == "")
            //                 ? locs
            //                     .map((loc) => ListTile(
            //                           title: Text(loc.munName!,
            //                               style: textStyles.lato_regular(
            //                                   fontSize: 14,
            //                                   color: Colors.black)),
            //                           onTap: (() {
            //                             setState(() {
            //                               selectedMunicipalName = loc.munName!;
            //                               selectedMunicipalCode = loc.munCode!;
            //                               for (Location_ locz in locs) {
            //                                 if (locz.munCode == loc.munCode) {
            //                                   selectedLocationProvname =
            //                                       locz.provName!;
            //                                 }
            //                               }
            //                             });
            //                             print(selectedMunicipalCode);
            //                             print(selectedLocationProvname);
            //                             Navigator.pop(context);
            //                           }),
            //                         ))
            //                     .toList()
            //                 : (suggestions.isNotEmpty)
            //                     ? suggestions
            //                         .map((loc) => ListTile(
            //                               title: Text(loc.munName!,
            //                                   style: textStyles.lato_regular(
            //                                       fontSize: 14,
            //                                       color: Colors.black)),
            //                               onTap: (() {
            //                                 setState(() {
            //                                   selectedMunicipalName =
            //                                       loc.munName!;
            //                                   selectedMunicipalCode =
            //                                       loc.munCode!;
            //                                   for (Location_ locz in locs) {
            //                                     if (locz.munCode ==
            //                                         loc.munCode) {
            //                                       selectedLocationProvname =
            //                                           locz.provName!;
            //                                     }
            //                                   }
            //                                   // }
            //                                 });
            //                                 print(selectedMunicipalCode);
            //                                 print(selectedLocationProvname);
            //                                 Navigator.pop(context);
            //                               }),
            //                             ))
            //                         .toList()
            //                     : [
            //                         Center(
            //                           child: Text(
            //                             '${ctrlr.text.trim()} does not exist.',
            //                           ),
            //                         )
            //                       ],
            //           ),
            //         ),
            //       ],
            //     );
            //   },
            // ),
          ),
        );
      },
    );
  }
}
