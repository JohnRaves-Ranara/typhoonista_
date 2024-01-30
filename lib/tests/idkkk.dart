import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:typhoonista_thesis/entities/Location_.dart';
import 'package:typhoonista_thesis/services/locations_.dart';
import 'city.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    // required this.title
  });

  // final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController windspeedController = TextEditingController();
  TextEditingController rainfall24hController = TextEditingController();
  TextEditingController rainfall6hController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController yieldController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  final ctrlr = TextEditingController();
  final manualDistanceCtrlr = TextEditingController();
  bool isSearchLocation = false;
  bool isManualDistrackMin = false;

  List<Location_> locs = Locations_().getLocations();
  List<Location_> suggestions = [];
  // String selectedLocation = "Choose Location";
  // String selectedLocationCode = "";

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
  String prediction = '';
  bool isSendingCoordinateRequest = false;
  bool isSendingPredictionRequest = false;
  String distrackminfinal = 'Enter distrackmin';

  Future<void> sendPredictionRequest({
    required double windspeed,
    required double rainfall24,
    required double rainfall6,
    required double area,
    required double riceYield,
    required double distrackmin,
    required double price,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('https://typhoonista.onrender.com/typhoonista/predict'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'features': [
            windspeed,
            rainfall24,
            rainfall6,
            area,
            riceYield,
            distrackmin,
            price,
          ],
        }),
      );

      if (response.statusCode == 200) {
        print('Nigana');
        setState(() {
          prediction = 'Prediction: ${jsonDecode(response.body)['prediction']}';
        });
      } else {
        print("failed");
        predictionResult = 'Failed to get prediction';
      }
    } catch (error) {
      setState(() {
        print("prediction nag error: $error");
        predictionResult = 'Error: $error';
      });
    }
  }

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

  @override
  void initState() {
    super.initState();
    // loadMunicipalNames();
  }

  // Future<void> loadMunicipalNames() async {
  //   try {
  //     List<String> names = await getMunicipalNames();
  //     setState(() {
  //       municipalNames = names;
  //       print(municipalNames);
  //     });
  //   } catch (e) {
  //     print('Error loading municipal names: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: windspeedController,
            decoration: const InputDecoration(
              labelText: 'Enter Windspeed',
            ),
          ),
          TextField(
            controller: rainfall24hController,
            decoration: const InputDecoration(
              labelText: 'Enter Rainfall (24hrs)',
            ),
          ),
          TextField(
            controller: rainfall6hController,
            decoration: const InputDecoration(
              labelText: 'Enter Rainfall (6hrs)',
            ),
          ),
          TextField(
            controller: areaController,
            decoration: const InputDecoration(
              labelText: 'Area',
            ),
          ),
          TextField(
            controller: yieldController,
            decoration: const InputDecoration(
              labelText: 'Yield',
            ),
          ),
          TextField(
            controller: priceController,
            decoration: const InputDecoration(
              labelText: 'Price',
            ),
          ),
          GestureDetector(
            onTap: ((){
              showDistrackminOptions();
            }),
            child: Container(
              height: 100,
              width: 200,
              child: Text(distrackminfinal),
              decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.black, style: BorderStyle.solid)),
            ),
          ),
          Align(
              alignment: Alignment.centerLeft, child: Text(distancetoTyphoon!)),
          Align(alignment: Alignment.centerLeft, child: Text(predictionResult)),
          ElevatedButton(
              onPressed: () async {
                print(distrackminfinal);
                setState(() {
                  isSendingPredictionRequest = true;
                });
                await sendPredictionRequest(
                  windspeed: double.parse(windspeedController.text.trim()),
                  rainfall24: double.parse(rainfall24hController.text.trim()),
                  rainfall6: double.parse(rainfall6hController.text.trim()),
                  area: double.parse(areaController.text.trim()),
                  riceYield: double.parse(yieldController.text.trim()),
                  distrackmin: double.parse(distrackminfinal),
                  price: double.parse(priceController.text.trim())
                );
                setState(() {
                  isSendingPredictionRequest = false;
                  predictionResult = prediction;
                });
              },
              child: Text((isSendingCoordinateRequest == true)
                  ? 'Calculating coordinates'
                  : (isSendingPredictionRequest == true)
                      ? 'Predicting Cost'
                      : 'Predict'))
        ],
      ),
    );
  }

  showLocationDialog(Function customState3) {
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
                                        customState3(() {
                                          selectedMunicipalName = loc.munName!;
                                          selectedMunicipalCode = loc.munCode!;
                                          for (Location_ locz in locs) {
                                            if (locz.munCode == loc.munCode) {
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
                            : (suggestions.isNotEmpty)
                                ? suggestions
                                    .map((loc) => ListTile(
                                          title: Text(loc.munName!,
                                              style: textStyles.lato_regular(
                                                  fontSize: 14,
                                                  color: Colors.black)),
                                          onTap: (() {
                                            customState3(() {
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

  showDistrackminOptions(){ 
    showDialog(context: context,
    builder: (context){
      return AlertDialog(
        content: Container(
              height: MediaQuery.of(context).size.height*0.5,
              width: MediaQuery.of(context).size.width*0.5,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: ((){
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
                      onTap: ((){
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
    }
    );
  }

  showManualDistanceCalculation(){
    showDialog(context: context,
    builder: (context){
      return AlertDialog(
        content: StatefulBuilder(
          builder: (context, customState4) {
            return Column(
              children: [
                Text("Enter distance in km"),
                TextField(
                  controller: manualDistanceCtrlr,
                ),
                ElevatedButton(onPressed: ((){
                  setState(() {
                    distrackminfinal = manualDistanceCtrlr.text.trim();
                  });
                  Navigator.popUntil(context, (route) => route.isFirst);
                }), child: Text('HEVABI'))
              ],
            );
          }
        ),
      );
    });
  }

  showAutomaticDistanceCalculation() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: StatefulBuilder(
              builder: (context, customState3) {
                return Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Select Location"),
                    ),
                    InkWell(
                      onTap: (() {
                        showLocationDialog(customState3);
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
                                selectedMunicipalName,
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
                    ElevatedButton(onPressed: (()async{
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
                    }), child: Text((isSendingCoordinateRequest) ? 'Calculating...' : 'Calculate Distance'))
                  ],
                );
              }
            ),
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
