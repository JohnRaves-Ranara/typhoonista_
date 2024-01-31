import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';
import 'package:typhoonista_thesis/entities/Location_.dart';
import 'package:typhoonista_thesis/entities/TyphoonDay.dart';
import 'package:typhoonista_thesis/services/FirestoreService.dart';
import 'package:typhoonista_thesis/services/estimatorModel.dart';
import 'package:typhoonista_thesis/services/locations.dart';
import 'package:typhoonista_thesis/services/locations_.dart';
import 'package:http/http.dart' as http;

class estimator_page extends StatefulWidget {
  const estimator_page({super.key});

  @override
  State<estimator_page> createState() => _estimator_pageState();
}

class _estimator_pageState extends State<estimator_page> {
  TextEditingController windspeedController = TextEditingController();
  TextEditingController rainfall24hController = TextEditingController();
  TextEditingController rainfall6hController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController yieldController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  final typhNameController = TextEditingController();
  final ctrlr = TextEditingController();
  List<Location_> locs = Locations_().getLocations();
  List<Location_> suggestions = [];

  bool isSearchLocation = false;
  final manualDistanceCtrlr = TextEditingController();
  // bool isManualDistrackMin = false;

  String selectedMunicipalName = "Select Location";
  String selectedMunicipalCode = "";
  String selectedTyphoonLocation = "Select Location";
  String selectedTyphoonCode = "";
  String selectedTyphoonProvname = "";
  String selectedLocationProvname = "";
  String? distancetoTyphoon = '';
  String coordinates1 = '';
  String distance = '';
  String predictionResult = '';
  double? prediction;
  double? damageCostPredictionFromAPI;
  bool isSendingCoordinateRequest = false;
  bool isSendingPredictionRequest = false;
  String distrackminfinal = 'Enter distrackmin...';
  bool isFetchingPrediction = false;
  bool isAddingTyphoon = false;
  double? test_area;
  double? test_yield;

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
      print(windspeedController.text.trim());
      print(rainfall24hController.text.trim());
      print(rainfall6hController.text.trim());
      print(test_area);
      print(test_yield);
      print(distrackminfinal.trim());
      print(priceController.text.trim());
      final response = await http.post(
        Uri.parse('https://typhoonista.onrender.com/typhoonista/predict'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'features': [
            double.parse(windspeedController.text.trim()),
            double.parse(rainfall24hController.text.trim()),
            double.parse(rainfall6hController.text.trim()),
            test_area,
            test_yield,
            double.parse(distrackminfinal.trim()),
            double.parse(priceController.text.trim()),
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

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 70, vertical: 50),
        child: Column(
          children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Damage Cost Estimator",
                    style: textStyles.lato_black(fontSize: 32),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "The impact of the industrial revolution has began to uprise in terms of the rice and skermberlu it ornare accumsan. Justo vulputate in pretium integer vulputate vitae proin congue etiam. Sollicitudin egestas est in ultrices molestie lacus iaculis risus. Velit habitasse felis auctor at.",
                    style: textStyles.lato_light(fontSize: 18),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Divider(
              thickness: 1,
            ),
            Expanded(
                flex: 80,
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      // color: Colors.green,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Add New Typhoon",
                            style: textStyles.lato_black(fontSize: 30),
                          ),
                          TextField(
                            controller: typhNameController,
                            decoration: InputDecoration(
                                labelStyle: textStyles.lato_light(
                                    color: Colors.grey.withOpacity(0.9)),
                                border: OutlineInputBorder(),
                                labelText: "Name"),
                          ),
                          TextField(
                            controller: windspeedController,
                            decoration: InputDecoration(
                                labelStyle: textStyles.lato_light(
                                    color: Colors.grey.withOpacity(0.9)),
                                border: OutlineInputBorder(),
                                labelText: "Windspeed"),
                          ),
                          TextField(
                            controller: rainfall24hController,
                            decoration: InputDecoration(
                                labelStyle: textStyles.lato_light(
                                    color: Colors.grey.withOpacity(0.9)),
                                border: OutlineInputBorder(),
                                labelText: "Rainfall (24 hour)"),
                          ),
                          TextField(
                            controller: rainfall6hController,
                            decoration: InputDecoration(
                                labelStyle: textStyles.lato_light(
                                    color: Colors.grey.withOpacity(0.9)),
                                border: OutlineInputBorder(),
                                labelText: "Rainfall (6 hour)"),
                          ),
                          TextField(
                            controller: priceController,
                            decoration: InputDecoration(
                                labelStyle: textStyles.lato_light(
                                    color: Colors.grey.withOpacity(0.9)),
                                border: OutlineInputBorder(),
                                labelText: "Rice Price (per kilo)"),
                          ),
                          InkWell(
                            onTap: (() {
                              showLocationDialog();
                            }),
                            child: Container(
                              width: double.maxFinite,
                              height: 30,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey.shade600,
                                      width: 1,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Text(selectedMunicipalName,
                                  style: textStyles.lato_light(
                                    color: Colors.grey.withOpacity(0.9),
                                  )),
                            ),
                          ),
                          InkWell(
                            onTap: (() {
                              if(selectedMunicipalName=='Select Location') {
                                showDialog(
                                  context: context,
                                  builder: (context){
                                    return AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('Please provide your location first.'),
                                        ],
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          child: Text('OK'),
                                          onPressed: ((){
                                            Navigator.pop(context);
                                          }),
                                        )
                                      ],
                                    );
                                  }
                                );
                              }
                              else{
                                showDistrackminOptions();
                              }
                            }),
                            child: Container(
                              width: double.maxFinite,
                              height: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      width: 1,
                                      color: Colors.grey.shade600,
                                      style: BorderStyle.solid)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      distrackminfinal,
                                      style:
                                          textStyles.lato_regular(fontSize: 17),
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
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Material(
                              color: Colors.blue,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: (() async {
                                  setState(() {
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
                                  setState(() {
                                    print("beat the ");
                                    isFetchingPrediction = false;
                                    print("koto nai");
                                  });
                                  print(
                                      "BRUHHH ${damageCostPredictionFromAPI}");
                                  try {
                                    setState(() {
                                      isAddingTyphoon = true;
                                    });
                                    await FirestoreService().addDay(
                                        damageCost: double.parse(
                                            damageCostPredictionFromAPI!
                                                .toStringAsFixed(2)),
                                        windSpeed: double.parse(
                                            windspeedController.text.trim()),
                                        rainfall24: double.parse(
                                            rainfall24hController.text.trim()),
                                        rainfall6: double.parse(
                                            rainfall6hController.text.trim()),
                                        disTrackMin:
                                            double.parse(distrackminfinal),
                                        location: selectedMunicipalName,
                                        locationCode: selectedMunicipalCode,
                                        typhoonName:
                                            typhNameController.text.trim(),
                                        isFirstDay: true,
                                        price: double.parse(
                                            priceController.text.trim()));
                                  } catch (e) {
                                    print("ERROR SA DB OH: $e");
                                  }
                                  print("HUMANA OG ADD SA DB");
                                  setState(() {
                                    print("pssy");
                                    isAddingTyphoon = false;
                                    print("drake");
                                  });

                                  setState(() {
                                    print("resetting");
                                    selectedMunicipalName = "Choose Location";
                                    selectedMunicipalCode = "";
                                    distrackminfinal = "Enter distrackmin...";
                                    print("resetted");
                                  });

                                  typhNameController.clear();
                                  windspeedController.clear();
                                  rainfall24hController.clear();
                                  rainfall6hController.clear();
                                  priceController.clear();
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
                                            fontSize: 20, color: Colors.white),
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
                          )
                        ],
                      ),
                    )),
                    Expanded(
                        child: Container(
                      child: Center(
                        child: Text((isFetchingPrediction)
                            ? 'Fetching Damage Cost Prediction...'
                            : (isAddingTyphoon)
                                ? 'Adding typhoon to database...'
                                : 'hello world'),
                      ),
                      color: Colors.blue,
                    ))
                  ],
                )),
          ],
        ));
  }

  bruh({required double num}) {
    print('Bdsadasdasd');
  }

  showLocationDialog() {
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
                                        'Select Typhoon Municipality',
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
                                        setState(() {
                                          selectedMunicipalName = loc.munName!;
                                          selectedMunicipalCode = loc.munCode!;
                                          for (Location_ locz in locs) {
                                            if (locz.munCode == loc.munCode) {
                                              selectedLocationProvname =
                                                  locz.provName!;
                                            }
                                          }
                                        });
                                        print(selectedMunicipalCode);
                                        print(selectedLocationProvname);
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
                                            setState(() {
                                              selectedMunicipalName =
                                                  loc.munName!;
                                              selectedMunicipalCode =
                                                  loc.munCode!;
                                              for (Location_ locz in locs) {
                                                if (locz.munCode ==
                                                    loc.munCode) {
                                                  selectedLocationProvname =
                                                      locz.provName!;
                                                }
                                              }
                                              // }
                                            });
                                            print(selectedMunicipalCode);
                                            print(selectedLocationProvname);
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

  showDistrackminOptions() {
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
                              onTap: (() {
                                showAutomaticDistanceCalculation();
                              }),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        style: BorderStyle.solid,
                                        color: Colors.grey.shade600),
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
                              onTap: (() {
                                showManualDistanceCalculation();
                              }),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        style: BorderStyle.solid,
                                        color: Colors.grey.shade600),
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

  showManualDistanceCalculation() {
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
                    setState(() {
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

  showAutomaticDistanceCalculation() {
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
                      customState3(() {
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

  searchbook(String query, Function customState) {
    customState(() {
      suggestions = locs.where((loc) {
        final munName = loc.munName!.toLowerCase();
        final input = query.toLowerCase();
        return munName.contains(input);
      }).toList();
    });
  }
}
