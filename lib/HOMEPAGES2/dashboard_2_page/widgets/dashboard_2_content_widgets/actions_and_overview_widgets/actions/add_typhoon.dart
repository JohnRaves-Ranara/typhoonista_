import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/services/FirestoreService2.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';

class add_typhoon extends StatefulWidget {
  const add_typhoon({super.key});

  @override
  State<add_typhoon> createState() => _add_typhoonState();
}

class _add_typhoonState extends State<add_typhoon> {
  bool haveAdded = false;
  final typhoonNameCtrlr = TextEditingController();
  

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
                                add_typhoon(
                                    // recentEstimation,
                                    )),
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
              'Add Typhoon',
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

  Widget add_typhoon(
      // Typhoon recentEstimation,
      ) {
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
            "Add Typhoon",
            style: textStyles.lato_black(fontSize: 35),
          ),
          SizedBox(
            height: 30,
          ),
          TextField(
            style: textStyles.lato_regular(),
            controller: typhoonNameCtrlr,
            decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                fillColor: Colors.white,
                labelStyle: textStyles.lato_light(color: Colors.black),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.grey.shade600.withOpacity(0.5),
                        width: 1,
                        style: BorderStyle.solid)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.grey.shade600,
                        width: 1,
                        style: BorderStyle.solid)),
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.grey.shade600.withOpacity(0.5),
                        width: 1,
                        style: BorderStyle.solid)),
                labelText: "Typhoon Name"),
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
                onTap: (() async{
                  await FirestoreService2().addTyphoon(typhoonNameCtrlr.text.trim());
                  typhoonNameCtrlr.clear();
                  Navigator.pop(context);
                }),
                child: Ink(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  width: double.maxFinite,
                  height: 55,
                  child: Row(
                    children: [
                      Text(
                        "Confirm",
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
