import 'dart:convert';

import 'package:flutter/material.dart';
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
  final ricePriceCtlr = TextEditingController();
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

  String selectedMunicipalName = "Choose Location";
  String selectedMunicipalCode = "";
  String selectedTyphoonLocation = "Choose Location";
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
      for(Location_ loc in locs){
        if(loc.munCode == selectedMunicipalCode){
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
      setState(() {
        print("prediction nag error: $error");
      });
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
                              showDistrackminOptions();
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
                                  
                                  for (Location_ loc in locs) {
                                    if (loc.munCode == selectedMunicipalCode) {
                                      print("LILUZIVERT");
                                      print(loc);
                                        await sendPredictionRequest();
                                            print("NA SET NA DILI NA NULL");
                                      break;
                                    }
                                  }
                                  print("BRUHHH ${damageCostPredictionFromAPI}");
                                  await FirestoreService().dayAdd(
                                      null,
                                      damageCostPredictionFromAPI.toString(),
                                      typhNameController.text,
                                      windspeedController.text,
                                      rainfall24hController.text,
                                      rainfall6hController.text,
                                      //todo try removing the setstates idk
                                      //todo try if the showdialogs are the error cause
                                      selectedMunicipalName,
                                      selectedMunicipalCode,
                                      true,
                                      ricePriceCtlr.text.trim(),
                                      distrackminfinal
                                      );
                                  
                                  setState(() {
                                    selectedMunicipalName = "Choose Location";
                                    selectedMunicipalCode = "";
                                  });
                                  
                                  // typhNameController.clear();
                                  // windspeedController.clear();
                                  // rainfall24hController.clear();
                                  // rainfall6hController.clear();
                                  // ricePriceCtlr.clear();
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

  bruh({required double num}){
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
            content: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.5,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: (() {
                        showAutomaticDistanceCalculation();
                      }),
                      child: Container(
                        color: Colors.blue,
                        child: Center(
                          child: Text('AUTOMATIC'),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: (() {
                        showManualDistanceCalculation();
                      }),
                      child: Container(
                        color: Colors.red,
                        child: Center(
                          child: Text('MANUAL'),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  showManualDistanceCalculation() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: StatefulBuilder(builder: (context, customState4) {
              return Column(
                children: [
                  Text("Enter distance in km"),
                  TextField(
                    controller: manualDistanceCtrlr,
                  ),
                  ElevatedButton(
                      onPressed: (() {
                        setState(() {
                          distrackminfinal = manualDistanceCtrlr.text.trim();
                        });
                        Navigator.popUntil(context, (route) => route.isFirst);
                      }),
                      child: Text('HEVABI'))
                ],
              );
            }),
          );
        });
  }

  showAutomaticDistanceCalculation() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: StatefulBuilder(builder: (context, customState3) {
              return Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Selected Location"),
                  ),
                  Container(
                    width: double.maxFinite,
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            width: 1,
                            color: Colors.grey.shade600,
                            style: BorderStyle.solid)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        (selectedMunicipalName == "Choose Location")
                            ? 'No municipal location selected'
                            : selectedMunicipalName,
                        style: textStyles.lato_regular(fontSize: 17),
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Select Location of Typhoon"),
                  ),
                  InkWell(
                    onTap: (() {
                      showTyphoonLocationDialog(customState3);
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
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              selectedTyphoonLocation,
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
                  ElevatedButton(
                      onPressed: (() async {
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
                        Navigator.popUntil(context, (route) => route.isFirst);
                      }),
                      child: Text((isSendingCoordinateRequest)
                          ? 'Calculating...'
                          : 'Calculate Distance'))
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
