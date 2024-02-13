import 'dart:convert';
import 'package:http/http.dart' as http;
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
import 'package:typhoonista_thesis/entities/Location_.dart';
import 'package:typhoonista_thesis/services/locations_.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class recent_estimation extends StatefulWidget {
  const recent_estimation({super.key});

  @override
  State<recent_estimation> createState() => _recent_estimationState();
}

class _recent_estimationState extends State<recent_estimation> {
  final windspeedCtlr = TextEditingController();
  final rainfall6Ctlr = TextEditingController();
  final rainfall24Ctlr = TextEditingController();
  final ricePriceCtlr = TextEditingController();
  String selectedMunicipalName = "Select Location";
  String selectedMunicipalCode = "";
  String selectedLocationProvname = "";
  TyphoonDay? newlyAddedDayInformation;
  bool haveAdded = false;
  List<Location_> locs = Locations_().getLocations();
  List<Location_> suggestions = [];
  bool isSearchLocation = false;
  final ctrlr = TextEditingController();

  final manualDistanceCtrlr = TextEditingController();
  // bool isManualDistrackMin = false;

  String selectedTyphoonLocation = "Choose Location";
  String selectedTyphoonCode = "";
  String selectedTyphoonProvname = "";
  String? distancetoTyphoon = '';
  String coordinates1 = '';
  String distance = '';
  String predictionResult = '';
  double? prediction;
  double? damageCostPredictionFromAPI;
  bool isSendingCoordinateRequest = false;
  bool isSendingPredictionRequest = false;
  String distrackminfinal = 'Distance of Typhoon to Location';
  bool isFetchingPrediction = false;
  bool isAddingTyphoon = false;
  double? test_area;
  double? test_yield;
  bool isEstimationSuccess = false;
  bool isEstimationError = false;
  String? errorMessage;

  @override
  Future<void> sendCoordinatesRequest() async {
    try {
      final response = await http.post(
        Uri.parse('https://typhoonista.onrender.com/get_coordinates'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'predictionLocation':
              "$selectedMunicipalName, $selectedLocationProvname,  Philippines",
          'typhoonLocation':
              "$selectedTyphoonLocation, $selectedTyphoonProvname, Philippines",
        }),
      );

      if (response.statusCode == 200) {
        print('Nigana');
        setState(() {
          coordinates1 = jsonDecode(response.body)['distance'].toString();
          coordinates1 = coordinates1.replaceAll(" km", "");
          print(coordinates1);
        });
      } else {
        print("failed");
        print(selectedMunicipalName);
        print(coordinates1);
        coordinates1 = 'Failed to get coordinates';
      }
    } catch (error) {
      setState(() {
        print("coordinates nag error: $error");
        coordinates1 = 'Error: $error';
      });
    }
  }

  Future<void> sendPredictionRequest() async {
    try {
      for (Location_ loc in locs) {
        if (loc.munCode == selectedMunicipalCode) {
          setState(() {
            test_area = loc.riceArea;
            test_yield = loc.riceYield;
          });
        }
      }
      print(windspeedCtlr.text.trim());
      print(rainfall24Ctlr.text.trim());
      print(rainfall6Ctlr.text.trim());
      print(test_area);
      print(test_yield);
      print(distrackminfinal.trim());
      print(ricePriceCtlr.text.trim());
      final response = await http.post(
        Uri.parse('https://typhoonista.onrender.com/typhoonista/predict'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'features': [
            double.parse(windspeedCtlr.text.trim()),
            double.parse(rainfall24Ctlr.text.trim()),
            double.parse(rainfall6Ctlr.text.trim()),
            test_area,
            test_yield,
            double.parse(distrackminfinal.trim()),
            double.parse(ricePriceCtlr.text.trim()),
          ],
        }),
      );

      if (response.statusCode == 200) {
        print('Nigana ang send prediction');
        setState(() {
          prediction = jsonDecode(response.body);
          damageCostPredictionFromAPI = prediction;
        });
      } else {
        print("failed");
      }
    } catch (error) {
      print("prediction nag error: $error");
    }
  }

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
                                                          backgroundColor:
                                                              Colors.white,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          content:
                                                              StatefulBuilder(
                                                            builder: (context,
                                                                customState) {
                                                              return Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                              // color: Colors.teal,
                                                                              borderRadius: BorderRadius.circular(
                                                                                  20)),
                                                                      // height: MediaQuery.of(
                                                                      //             context)
                                                                      //         .size
                                                                      //         .height *
                                                                      //     0.8,
                                                                      width: (isEstimationSuccess)
                                                                          ? MediaQuery.of(context).size.width *
                                                                              0.4
                                                                          : MediaQuery.of(context).size.width *
                                                                              0.25,
                                                                      child: (isFetchingPrediction)
                                                                          ? fetchingPrediction()
                                                                          : (isAddingTyphoon)
                                                                              ? addingToDatabase()
                                                                              : (isEstimationError)
                                                                                  ? estimationError(errorMessage!, customState)
                                                                                  : (isEstimationSuccess)
                                                                                      ? Information(customState)
                                                                                      : add_day(recentEstimation, customState)),
                                                                ],
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      }
                                                      );
                                                }),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Center(
                                                  child: Text(
                                                    "ADD DAILY ESTIMATION",
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
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "No Data Available",
                                            style: textStyles.lato_regular(
                                                color: Colors.white.withOpacity(0.2),
                                                fontSize: 35),
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
                                            color: Colors.white.withOpacity(0.2),
                                            child: Ink(
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                onTap: null,
                                                child: Center(
                                                  child: Text(
                                                    "DELETE COMPUTATION",
                                                    style:
                                                        textStyles.lato_regular(
                                                            color: Colors.white.withOpacity(0.2),
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
                                            color: Colors.white.withOpacity(0.2),
                                            child: Ink(
                                              child: InkWell(
                                                onTap: null,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Center(
                                                  child: Text(
                                                    "MARK AS FINISHED",
                                                    style:
                                                        textStyles.lato_regular(
                                                            color: Colors.white.withOpacity(0.2),
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
                                            color: Colors.white.withOpacity(0.2),
                                            child: Ink(
                                              child: InkWell(
                                                onTap: null,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Center(
                                                  child: Text(
                                                    "ADD DAILY ESTIMATION",
                                                    style:
                                                        textStyles.lato_regular(
                                                            color: Colors.white.withOpacity(0.2),
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

              // return Center(
              //     child: SpinKitSpinningLines(
              //         size: 50, lineWidth: 3.5, color: Colors.blue));
            }
          }),
    );
  }

  Widget estimationError(String err, Function customState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.error,
          size: 130,
          color: Colors.red,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'ERROR: $err',
          style: textStyles.lato_bold(fontSize: 22),
        ),
        SizedBox(
          height: 34,
        ),
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: (() {}),
          child: Container(
            height: 40,
            width: 100,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Text(
                'OK',
                style: textStyles.lato_bold(fontSize: 24, color: Colors.white),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget fetchingPrediction() {
    return Column(
      children: [
        SizedBox(
          height: 60,
        ),
        const SpinKitSpinningLines(lineWidth: 4, size: 100, color: Colors.blue),
        SizedBox(height: 60),
        Text(
          'Estimating.',
          style: textStyles.lato_bold(
              fontSize: 18, color: Colors.black.withOpacity(0.4)),
        ),
        Text(
          'This may take a while...',
          style: textStyles.lato_bold(
              fontSize: 18, color: Colors.black.withOpacity(0.4)),
        ),
        SizedBox(
          height: 80,
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'lib/assets/images/typhoonista_logo.png',
                height: 20,
                color: Color(0xff0090D9).withOpacity(0.3),
              ),
              SizedBox(width: 5),
              Text('TYPHOONISTA - ${DateTime.now().year}',
                  style: textStyles.lato_bold(
                      fontSize: 12, color: Color(0xff0090D9).withOpacity(0.3)))
            ]),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }

  Widget addingToDatabase() {
    return Column(
      children: [
        SizedBox(
          height: 60,
        ),
        const SpinKitSpinningLines(lineWidth: 4, size: 100, color: Colors.blue),
        SizedBox(height: 60),
        Text(
          'Adding Estimation to',
          style: textStyles.lato_bold(
              fontSize: 18, color: Colors.black.withOpacity(0.4)),
        ),
        Text(
          'Database...',
          style: textStyles.lato_bold(
              fontSize: 18, color: Colors.black.withOpacity(0.4)),
        ),
        SizedBox(
          height: 80,
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'lib/assets/images/typhoonista_logo.png',
                height: 20,
                color: Color(0xff0090D9).withOpacity(0.3),
              ),
              SizedBox(width: 5),
              Text('TYPHOONISTA - ${DateTime.now().year}',
                  style: textStyles.lato_bold(
                      fontSize: 12, color: Color(0xff0090D9).withOpacity(0.3)))
            ]),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }

  showDeleteComputationDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actionsPadding: EdgeInsets.only(left: 15, right: 15, bottom: 30),
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
                        text:
                            "(If the Typhoon is finished, you can choose 'Mark as Finished' instead)",
                        style:
                            textStyles.lato_regular(color: Color(0xffAD0000)))
                  ]),
                              ),
              ),
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
            actionsPadding: EdgeInsets.only(left: 15, right: 15, bottom: 30),
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
                          text: "mark this typhoon as 'Finished'. ",
                          style: textStyles.lato_regular(
                              color: Color(0xffAD0000))),
                      TextSpan(
                          text: "Would you like to continue? ",
                          style: textStyles.lato_regular(color: Colors.black)),
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
                          "Mark Finished",
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
            "Add Daily Estimation",
            style: textStyles.lato_black(fontSize: 35),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            // color: Colors.purple,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextField(
                  style: textStyles.lato_regular(),
                  enabled: !haveAdded,
                  controller: windspeedCtlr,
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
                      labelText: "Rice Price (per kilo)"),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: !haveAdded
                      ? (() {
                          // showChooseLocationDialog(recentEstimation.id, customState);
                          showChooseLocationDialog(
                              customState, recentEstimation.id);
                        })
                      : null,
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
                            selectedMunicipalName,
                            style: (selectedMunicipalName == 'Select Location')
                                ? textStyles.lato_light(fontSize: 17)
                                : textStyles.lato_regular(fontSize: 17),
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
                  onTap: (!haveAdded)
                      ? (selectedMunicipalName == 'Select Location')
                          ? null
                          : (() {
                              showDistrackminOptions(customState);
                            })
                      : null,
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
                            distrackminfinal,
                            style: (distrackminfinal ==
                                    'Distance of Typhoon to Location')
                                ? textStyles.lato_light(fontSize: 17)
                                : textStyles.lato_regular(fontSize: 17),
                          ),
                          (selectedMunicipalName == 'Select Location')
                              ? Tooltip(
                                  message:
                                      "Please provide your location first.",
                                  child: Icon(
                                    Icons.info,
                                    size: 16,
                                    color: Colors.blue,
                                  ),
                                )
                              : Icon(
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
            height: 30,
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
                        TyphoonDay? addDay;
                        try {
                          customState(() {
                            isFetchingPrediction = true;
                          });
                          for (Location_ loc in locs) {
                            if (loc.munCode == selectedMunicipalCode) {
                              print("LILUZIVERT");
                              print(loc);
                              await sendPredictionRequest();
                              print("NA SET NA DILI NA NULL");
                              break;
                            }
                          }
                          customState(() {
                            isFetchingPrediction = false;
                          });
                          print("BRUHHH ${damageCostPredictionFromAPI}");
                          customState(() {
                            isAddingTyphoon = true;
                          });
                          addDay = await FirestoreService().addDay(
                              typhoonId: recentEstimation.id,
                              damageCost: double.parse(
                                  damageCostPredictionFromAPI!
                                      .toStringAsFixed(2)),
                              windSpeed:
                                  double.parse(windspeedCtlr.text.trim()),
                              rainfall24:
                                  double.parse(rainfall24Ctlr.text.trim()),
                              rainfall6:
                                  double.parse(rainfall6Ctlr.text.trim()),
                              disTrackMin: double.parse(distrackminfinal),
                              location: selectedMunicipalName,
                              locationCode: selectedMunicipalCode,
                              typhoonName: recentEstimation.typhoonName,
                              isFirstDay: false,
                              price: double.parse(ricePriceCtlr.text.trim()));
                          customState(() {
                            isAddingTyphoon = false;
                            haveAdded = true;
                            try {
                              newlyAddedDayInformation = addDay;
                            } catch (e) {
                              print("ERROR SA NEWLYADDEDDAY: ${e}");
                            }
                            isEstimationSuccess = true;
                          });
                        } catch (e) {
                          customState(() {
                            isAddingTyphoon = false;
                            isFetchingPrediction = false;
                            isEstimationError = true;
                            errorMessage = e.toString();
                          });
                        }
                        customState(() {
                          print("resetting");
                          selectedMunicipalName = "Choose Location";
                          selectedMunicipalCode = "";
                          selectedTyphoonLocation = "Choose Location";
                          selectedTyphoonCode = "";
                          selectedLocationProvname = "";
                          distrackminfinal = "Distance of Typhoon to Location";
                          windspeedCtlr.clear();
                          rainfall24Ctlr.clear();
                          rainfall6Ctlr.clear();
                          ricePriceCtlr.clear();
                          print("resetted");
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
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  Widget Information(Function customState) {
    // var newlyAddedDayInformation = TyphoonDay(
    //     price: 19.23,
    //     distrackmin: 250,
    //     rainfall24: 12,
    //     rainfall6: 6.121,
    //     windSpeed: 21,
    //     id: '12331',
    //     typhoonID: '12313',
    //     location: 'Arakan',
    //     locationCode: 'bruh',
    //     dateRecorded: '2020-14-12 18:23',
    //     typhoonName: 'Pasilyo',
    //     damageCost: 1234567.12,
    //     day: 3);
    return Container(
      // color: ,
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40),
          Container(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.28),
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: (haveAdded)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          "Estimation",
                          style: textStyles.lato_black(fontSize: 30),
                        ),
                        Divider(),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: 20),
                            Expanded(
                              flex: 60,
                              child: Container(
                                // color: Colors.blue,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Typhoon Name:',
                                      style:
                                          textStyles.lato_light(fontSize: 12),
                                    ),
                                    Text(
                                      '${newlyAddedDayInformation!.typhoonName}',
                                      style:
                                          textStyles.lato_black(fontSize: 16),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Predicted Damage Cost:',
                                      style:
                                          textStyles.lato_light(fontSize: 12),
                                    ),
                                    Text(
                                      '₱ ${NumberFormat('#,##0.00', 'en_US').format(newlyAddedDayInformation!.damageCost)}',
                                      style:
                                          textStyles.lato_black(fontSize: 16),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Day:',
                                      style:
                                          textStyles.lato_light(fontSize: 12),
                                    ),
                                    Text(
                                      '${newlyAddedDayInformation!.day}',
                                      style:
                                          textStyles.lato_black(fontSize: 16),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Date Recorded:',
                                      style:
                                          textStyles.lato_light(fontSize: 12),
                                    ),
                                    Text(
                                      '${DateTime.parse(newlyAddedDayInformation!.dateRecorded).year}-${DateTime.parse(newlyAddedDayInformation!.dateRecorded).month}-${DateTime.parse(newlyAddedDayInformation!.dateRecorded).day} ${DateTime.parse(newlyAddedDayInformation!.dateRecorded).hour}:${DateTime.parse(newlyAddedDayInformation!.dateRecorded).minute}',
                                      style:
                                          textStyles.lato_black(fontSize: 16),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Peak Windspeed:',
                                      style:
                                          textStyles.lato_light(fontSize: 12),
                                    ),
                                    Text(
                                      '${newlyAddedDayInformation!.windSpeed} kph',
                                      style:
                                          textStyles.lato_black(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 40,
                              child: Container(
                                // color: Colors.red,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Peak Rainfall (24H):',
                                      style:
                                          textStyles.lato_light(fontSize: 12),
                                    ),
                                    Text(
                                      '${newlyAddedDayInformation!.rainfall24} mm',
                                      style:
                                          textStyles.lato_black(fontSize: 16),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Peak Rainfall (6H):',
                                      style:
                                          textStyles.lato_light(fontSize: 12),
                                    ),
                                    Text(
                                      '${newlyAddedDayInformation!.rainfall6} mm',
                                      style:
                                          textStyles.lato_black(fontSize: 16),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Location:',
                                      style:
                                          textStyles.lato_light(fontSize: 12),
                                    ),
                                    Text(
                                      '${newlyAddedDayInformation!.location}',
                                      style:
                                          textStyles.lato_black(fontSize: 16),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Typhoon to Location Distance:',
                                      style:
                                          textStyles.lato_light(fontSize: 12),
                                    ),
                                    Text(
                                      '${newlyAddedDayInformation!.distrackmin} km',
                                      style:
                                          textStyles.lato_black(fontSize: 16),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Rice Price (per kilo):',
                                      style:
                                          textStyles.lato_light(fontSize: 12),
                                    ),
                                    Text(
                                      '${newlyAddedDayInformation!.price}',
                                      style:
                                          textStyles.lato_black(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 20),
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
                          isEstimationSuccess = false;
                        });
                        Navigator.pop(context);
                      })
                    : null,
                child: Ink(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: double.maxFinite,
                  height: 55,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Proceed",
                        style: textStyles.lato_bold(
                            fontSize: 18, color: Colors.white),
                      ),
                      Icon(
                        Icons.arrow_right,
                        size: 30,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  showDistrackminOptions(Function customState) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Select a Method',
                            style: textStyles.lato_bold(fontSize: 24),
                          ),
                          Spacer(),
                          Image.asset(
                            'lib/assets/images/typhoonista_logo.png',
                            height: 55,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: (() {
                                showAutomaticDistanceCalculation(customState);
                              }),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      style: BorderStyle.solid,
                                      color:
                                          Colors.grey.shade600.withOpacity(0.5),
                                    ),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Container(
                                  margin: EdgeInsets.all(25),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Automatic',
                                        style:
                                            textStyles.lato_bold(fontSize: 28),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        'This option utilizes an API that lets you compute for the distance of the typhoon from the location that you are predicting from automatically.',
                                        style:
                                            textStyles.lato_light(fontSize: 17),
                                      ),
                                      SizedBox(height: 25),
                                      Row(
                                        children: [
                                          Container(
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 8,
                                                  backgroundColor: Colors.red,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  'Less Accurate',
                                                  style:
                                                      textStyles.lato_regular(
                                                          fontSize: 15),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Container(
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 8,
                                                  backgroundColor: Colors.green,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  'Less Time Consumption',
                                                  style:
                                                      textStyles.lato_regular(
                                                          fontSize: 15),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: (() {
                                showManualDistanceCalculation(customState);
                              }),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      style: BorderStyle.solid,
                                      color:
                                          Colors.grey.shade600.withOpacity(0.5),
                                    ),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Container(
                                  margin: EdgeInsets.all(25),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Manual',
                                        style:
                                            textStyles.lato_bold(fontSize: 28),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        'This option lets you input your desired distance from your own computation. This option is suggested if you want more accurate predictions.',
                                        style:
                                            textStyles.lato_light(fontSize: 17),
                                      ),
                                      SizedBox(height: 25),
                                      Row(
                                        children: [
                                          Container(
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 8,
                                                  backgroundColor: Colors.green,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  'More Accurate',
                                                  style:
                                                      textStyles.lato_regular(
                                                          fontSize: 15),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Container(
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 8,
                                                  backgroundColor: Colors.red,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  'Time Consuming',
                                                  style:
                                                      textStyles.lato_regular(
                                                          fontSize: 15),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  // showManualDistanceCalculation(Function customState) {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           content: Column(
  //               children: [
  //                 Text("Enter distance in km"),
  //                 TextField(
  //                   controller: manualDistanceCtrlr,
  //                 ),
  //                 ElevatedButton(
  //                     onPressed: (() {
  //                       customState(() {
  //                         distrackminfinal = manualDistanceCtrlr.text.trim();
  //                       });
  //                       Navigator.pop(context);
  //                       Navigator.pop(context);
  //                     }),
  //                     child: Text('HEVABI'))
  //               ],
  //             ),
  //         );
  //       });
  // }

  showManualDistanceCalculation(Function customState) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      'Manual',
                      style: textStyles.lato_bold(fontSize: 28),
                    ),
                    Spacer(),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: Text(
                        'This option lets you input your desired distance from your own computation. This option is suggested if you want more accurate predictions.',
                        style: textStyles.lato_light(fontSize: 17),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                  ],
                ),
                SizedBox(
                  height: 35,
                ),
                TextField(
                  style: textStyles.lato_regular(fontSize: 22),
                  controller: manualDistanceCtrlr,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                      labelStyle: textStyles.lato_light(
                          color: Colors.grey.withOpacity(0.9), fontSize: 18),
                      label: Text(
                        'Distance of Typhoon and Location (in km)',
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              width: 1,
                              color: Colors.grey.shade400,
                              style: BorderStyle.solid))),
                ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: (() {
                    customState(() {
                      distrackminfinal = manualDistanceCtrlr.text.trim();
                      manualDistanceCtrlr.clear();
                    });

                    Navigator.pop(context);
                    Navigator.pop(context);
                  }),
                  child: Container(
                    height: 65,
                    width: MediaQuery.of(context).size.width * 0.6,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(children: [
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        'Confirm',
                        style: textStyles.lato_bold(
                            color: Colors.white, fontSize: 20),
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_right_alt,
                        size: 45,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 30,
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          );
        });
  }

  // showAutomaticDistanceCalculation(Function customState) {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           content: StatefulBuilder(builder: (context, customState3) {
  //             return Column(
  //               children: [
  //                 const Align(
  //                   alignment: Alignment.centerLeft,
  //                   child: Text("Selected Location"),
  //                 ),
  //                 Container(
  //                   width: double.maxFinite,
  //                   height: 60,
  //                   decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(5),
  //                       border: Border.all(
  //                           width: 1,
  //                           color: Colors.grey.shade600,
  //                           style: BorderStyle.solid)),
  //                   child: Padding(
  //                     padding: const EdgeInsets.symmetric(horizontal: 20),
  //                     child: Text(
  //                       (selectedMunicipalName == "Choose Location")
  //                           ? 'No municipal location selected'
  //                           : selectedMunicipalName,
  //                       style: textStyles.lato_regular(fontSize: 17),
  //                     ),
  //                   ),
  //                 ),
  //                 const Align(
  //                   alignment: Alignment.centerLeft,
  //                   child: Text("Select Location of Typhoon"),
  //                 ),
  //                 InkWell(
  //                   onTap: (() {
  //                     showTyphoonLocationDialog(customState3);
  //                   }),
  //                   child: Container(
  //                     width: double.maxFinite,
  //                     height: 60,
  //                     decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(5),
  //                         border: Border.all(
  //                             width: 1,
  //                             color: Colors.grey.shade600,
  //                             style: BorderStyle.solid)),
  //                     child: Padding(
  //                       padding: const EdgeInsets.symmetric(horizontal: 20),
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         crossAxisAlignment: CrossAxisAlignment.center,
  //                         children: [
  //                           Text(
  //                             selectedTyphoonLocation,
  //                             style: textStyles.lato_regular(fontSize: 17),
  //                           ),
  //                           Icon(
  //                             Icons.arrow_drop_down,
  //                             size: 22,
  //                             color: Colors.black,
  //                           )
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 ElevatedButton(
  //                     onPressed: (() async {
  //                       customState3(() {
  //                         isSendingCoordinateRequest = true;
  //                       });
  //                       await sendCoordinatesRequest();
  //                       customState(() {
  //                         isSendingCoordinateRequest = false;
  //                         distancetoTyphoon = coordinates1.trim();
  //                         distance = distancetoTyphoon!;
  //                         distrackminfinal = distance;
  //                       });
  //                       Navigator.pop(context);
  //                       Navigator.pop(context);
  //                     }),
  //                     child: Text((isSendingCoordinateRequest)
  //                         ? 'Calculating...'
  //                         : 'Calculate Distance'))
  //               ],
  //             );
  //           }),
  //         );
  //       });
  // }
  showAutomaticDistanceCalculation(Function customState) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
            content: StatefulBuilder(builder: (context, customState3) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        'Automatic',
                        style: textStyles.lato_bold(fontSize: 28),
                      ),
                      Spacer(),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: Text(
                          'This option utilizes an API that lets you compute for the distance of the typhoon from the location that you are predicting from automatically.',
                          style: textStyles.lato_light(fontSize: 17),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Location',
                              style: textStyles.lato_regular(fontSize: 14),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.grey.shade400,
                                      style: BorderStyle.solid,
                                      width: 1),
                                  color: Colors.grey.shade300),
                              height: 70,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    selectedMunicipalName,
                                    style: textStyles.lato_bold(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Typhoon Location',
                              style: textStyles.lato_regular(fontSize: 14),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: (() {
                                showTyphoonLocationDialog(customState3);
                              }),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.grey.shade400,
                                      style: BorderStyle.solid,
                                      width: 1),
                                ),
                                height: 70,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      selectedTyphoonLocation,
                                      style: textStyles.lato_bold(fontSize: 20),
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      size: 22,
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: (() async {
                      customState3(() {
                        isSendingCoordinateRequest = true;
                      });
                      await sendCoordinatesRequest();
                      customState(() {
                        isSendingCoordinateRequest = false;
                        distancetoTyphoon = coordinates1.trim();
                        distance = distancetoTyphoon!;
                        distrackminfinal = distance;
                      });
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }),
                    child: Container(
                      height: 65,
                      width: MediaQuery.of(context).size.width * 0.6,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(children: [
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          (isSendingCoordinateRequest)
                              ? 'Calculating Distance...'
                              : 'Calculate Distance',
                          style: textStyles.lato_bold(
                              color: Colors.white, fontSize: 20),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_right_alt,
                          size: 45,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                      ]),
                    ),
                  ),
                ],
              );
            }),
          );
        });
  }

  showTyphoonLocationDialog(Function customState3) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.3,
            child: StatefulBuilder(
              builder: (context, customState2) {
                return Column(
                  children: [
                    (isSearchLocation)
                        ? Container(
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    autofocus: true,
                                    style: textStyles.lato_regular(
                                        fontSize: 14, color: Colors.black),
                                    maxLength: 30,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Search Location...",
                                        counterText: ""),
                                    controller: ctrlr,
                                    onChanged: (value) =>
                                        searchbook(value.trim(), customState2),
                                  ),
                                ),
                                InkWell(
                                  borderRadius: BorderRadius.circular(50),
                                  onTap: (() {
                                    customState2(() {
                                      isSearchLocation = false;
                                      ctrlr.clear();
                                    });
                                  }),
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Icon(Icons.close),
                                  ),
                                )
                              ],
                            ),
                          )
                        : Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Text(
                                        'Select Typhoon Location Municipality',
                                        style:
                                            textStyles.lato_bold(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  borderRadius: BorderRadius.circular(50),
                                  onTap: (() {
                                    customState2(() {
                                      isSearchLocation = true;
                                    });
                                  }),
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Icon(Icons.search),
                                  ),
                                )
                              ],
                            ),
                          ),
                    Divider(
                      color: Colors.grey.shade700,
                    ),
                    Expanded(
                      child: ListView(
                        primary: false,
                        children: (ctrlr.text.trim() == "")
                            ? locs
                                .map((loc) => ListTile(
                                      title: Text(loc.munName!,
                                          style: textStyles.lato_regular(
                                              fontSize: 14,
                                              color: Colors.black)),
                                      onTap: (() {
                                        customState3(() {
                                          selectedTyphoonLocation =
                                              loc.munName!;
                                          selectedTyphoonCode = loc.munCode!;
                                          for (Location_ locz in locs) {
                                            if (locz.munCode == loc.munCode) {
                                              selectedTyphoonProvname =
                                                  locz.provName!;
                                            }
                                          }
                                          // }
                                        });
                                        print(selectedTyphoonCode);
                                        print(selectedTyphoonProvname);
                                        Navigator.pop(context);
                                      }),
                                    ))
                                .toList()
                            : (suggestions.isNotEmpty)
                                ? suggestions
                                    .map((loc) => ListTile(
                                          title: Text(loc.munName!,
                                              style: textStyles.lato_regular(
                                                  fontSize: 14,
                                                  color: Colors.black)),
                                          onTap: (() {
                                            customState3(() {
                                              selectedTyphoonLocation =
                                                  loc.munName!;
                                              selectedTyphoonCode =
                                                  loc.munCode!;
                                              for (Location_ locz in locs) {
                                                if (locz.munCode ==
                                                    loc.munCode) {
                                                  selectedTyphoonProvname =
                                                      locz.provName!;
                                                }
                                              }
                                              // }
                                            });
                                            print(selectedTyphoonCode);
                                            print(selectedTyphoonProvname);
                                            Navigator.pop(context);
                                          }),
                                        ))
                                    .toList()
                                : [
                                    Center(
                                      child: Text(
                                        '${ctrlr.text.trim()} does not exist.',
                                      ),
                                    )
                                  ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  showChooseLocationDialog(Function customState, String typhoonID) {
    bool isSearchLocation = false;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.3,
            child: StatefulBuilder(
              builder: (context, customState2) {
                return FutureBuilder(
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
                            .map((doc) => TyphoonDay.fromJson(
                                doc.data() as Map<String, dynamic>))
                            .toList();
                        List<Location_> unavailableLocations = [];
                        for (TyphoonDay day in days) {
                          DateTime current = DateTime(DateTime.now().year,
                              DateTime.now().month, DateTime.now().day);
                          DateTime dateRecorded = DateTime(
                              DateTime.parse(day.dateRecorded).year,
                              DateTime.parse(day.dateRecorded).month,
                              DateTime.parse(day.dateRecorded).day);
                          if (dateRecorded.isAtSameMomentAs(current)) {
                            Location_ loc = Location_(
                                munName: day.location,
                                munCode: day.locationCode!);
                            unavailableLocations.add(loc);
                          }
                        }
                        print("UNAVAILABLE LOCATIONS: ${unavailableLocations}");
                        return Column(
                          children: [
                            (isSearchLocation)
                                ? Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            autofocus: true,
                                            style: textStyles.lato_regular(
                                                fontSize: 14,
                                                color: Colors.black),
                                            maxLength: 30,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: "Search Location...",
                                                counterText: ""),
                                            controller: ctrlr,
                                            onChanged: (value) => searchbook(
                                                value.trim(), customState2),
                                          ),
                                        ),
                                        InkWell(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          onTap: (() {
                                            customState2(() {
                                              isSearchLocation = false;
                                              ctrlr.clear();
                                            });
                                          }),
                                          child: Container(
                                            margin: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            child: Icon(Icons.close),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Row(
                                            children: [
                                              Text(
                                                'Select Municipality',
                                                style: textStyles.lato_bold(
                                                    fontSize: 16),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Tooltip(
                                                message:
                                                    "You are not allowed to estimate the same location per day.\nThe location you have previously selected will be \ntemporarily unavailable until tomorrow.",
                                                child: Icon(
                                                  Icons.info,
                                                  size: 16,
                                                  color: Colors.blue,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          onTap: (() {
                                            customState2(() {
                                              isSearchLocation = true;
                                            });
                                          }),
                                          child: Container(
                                            margin: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            child: Icon(Icons.search),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                            Divider(
                              color: Colors.grey.shade700,
                            ),
                            Expanded(
                              child: ListView(
                                  primary: false,
                                  children: (ctrlr.text.trim() == "")
                                      ? List.generate(locs.length, (index) {
                                          bool isTheLocationUnavailable = false;
                                          for (Location_ i
                                              in unavailableLocations) {
                                            if (i.munCode ==
                                                locs[index].munCode) {
                                              isTheLocationUnavailable = true;
                                            }
                                          }
                                          if (isTheLocationUnavailable ==
                                              true) {
                                            return ListTile(
                                              title: Text(locs[index].munName!,
                                                  style:
                                                      textStyles.lato_regular(
                                                          fontSize: 14,
                                                          color: Colors.grey)),
                                              onTap: null,
                                              trailing: Tooltip(
                                                //todo add 'this location already has prediction for [date last recorded]
                                                message:
                                                    "This location already has prediction for today. Please try again tomorrow.",
                                                child: Icon(
                                                  Icons.info,
                                                  size: 16,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            );
                                          } else {
                                            return ListTile(
                                              title: Text(locs[index].munName!,
                                                  style:
                                                      textStyles.lato_regular(
                                                          fontSize: 14,
                                                          color: Colors.black)),
                                              onTap: (() {
                                                customState(() {
                                                  selectedMunicipalName =
                                                      locs[index].munName!;
                                                  selectedMunicipalCode =
                                                      locs[index].munCode!;
                                                  for (Location_ locz in locs) {
                                                    if (locz.munCode ==
                                                        locs[index].munCode) {
                                                      selectedLocationProvname =
                                                          locz.provName!;
                                                    }
                                                  }
                                                });
                                                Navigator.pop(context);
                                              }),
                                            );
                                          }
                                        })
                                      : (suggestions.isNotEmpty)
                                          ? List.generate(suggestions.length,
                                              (index) {
                                              bool isTheLocationUnavailable =
                                                  false;
                                              for (Location_ i
                                                  in unavailableLocations) {
                                                if (i.munCode ==
                                                    suggestions[index]
                                                        .munCode) {
                                                  isTheLocationUnavailable =
                                                      true;
                                                }
                                              }
                                              if (isTheLocationUnavailable ==
                                                  true) {
                                                return ListTile(
                                                  title: Text(
                                                      suggestions[index]
                                                          .munName!,
                                                      style: textStyles
                                                          .lato_regular(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.grey)),
                                                  onTap: null,
                                                  trailing: Tooltip(
                                                //todo add 'this location already has prediction for [date last recorded]
                                                message:
                                                    "This location already has prediction for today. Please try again tomorrow.",
                                                child: Icon(
                                                  Icons.info,
                                                  size: 16,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                                );
                                              } else {
                                                return ListTile(
                                                  title: Text(
                                                      suggestions[index]
                                                          .munName!,
                                                      style: textStyles
                                                          .lato_regular(
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .black)),
                                                  onTap: (() {
                                                    customState(() {
                                                      selectedMunicipalName =
                                                          suggestions[index]
                                                              .munName!;
                                                      selectedMunicipalCode =
                                                          suggestions[index]
                                                              .munCode!;
                                                      for (Location_ locz
                                                          in locs) {
                                                        if (locz.munCode ==
                                                            suggestions[index]
                                                                .munCode) {
                                                          selectedLocationProvname =
                                                              locz.provName!;
                                                        }
                                                      }
                                                    });
                                                    Navigator.pop(context);
                                                  }),
                                                );
                                              }
                                            })
                                          : [
                                              Center(
                                                child: Text(
                                                  '${ctrlr.text.trim()} does not exist.',
                                                  style:
                                                      textStyles.lato_regular(),
                                                ),
                                              )
                                            ]),
                            ),
                          ],
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    });
              },
            ),
          ),
        );
      },
    );
  }

  searchbook(String query, Function customState2) {
    customState2(() {
      suggestions = locs.where((loc) {
        final munName = loc.munName!.toLowerCase();
        final input = query.toLowerCase();
        return munName.contains(input);
      }).toList();
    });
  }
}
