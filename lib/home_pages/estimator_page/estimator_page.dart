import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';
import 'package:typhoonista_thesis/entities/Location_.dart';
import 'package:typhoonista_thesis/entities/TyphoonDay.dart';
import 'package:typhoonista_thesis/services/FirestoreService.dart';
import 'package:typhoonista_thesis/services/locations.dart';
import 'package:typhoonista_thesis/services/locations_.dart';

class estimator_page extends StatefulWidget {
  const estimator_page({super.key});

  @override
  State<estimator_page> createState() => _estimator_pageState();
}

class _estimator_pageState extends State<estimator_page> {
  final typhoonNameCtlr = TextEditingController();
  final windspeedCtlr = TextEditingController();
  final rainfallCtlr = TextEditingController();
  final locationCtlr = TextEditingController();
  final ctrlr = TextEditingController();
  List<Location_> locs = Locations_().getLocations();
  List<Location_> suggestions = [];

  String selectedLocation = "Choose Location";
  String selectedLocationCode = "";
  bool isSearchLocation = false;
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
                          SizedBox(
                            height: 25,
                          ),
                          TextField(
                            controller: typhoonNameCtlr,
                            decoration: InputDecoration(
                                labelStyle: textStyles.lato_light(
                                    color: Colors.grey.withOpacity(0.9)),
                                border: OutlineInputBorder(),
                                labelText: "Name"),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: windspeedCtlr,
                            decoration: InputDecoration(
                                labelStyle: textStyles.lato_light(
                                    color: Colors.grey.withOpacity(0.9)),
                                border: OutlineInputBorder(),
                                labelText: "Peak Windspeed"),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: rainfallCtlr,
                            decoration: InputDecoration(
                                labelStyle: textStyles.lato_light(
                                    color: Colors.grey.withOpacity(0.9)),
                                border: OutlineInputBorder(),
                                labelText: "Peak Rainfall"),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: (() {
                              showSampleDialog();
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
                                      selectedLocation,
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
                          SizedBox(
                            height: 20,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Material(
                              color: Colors.blue,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: (() {
                                  FirestoreService().addDay(
                                      typhoonId: null,
                                      typhoonName: typhoonNameCtlr.text.trim(),
                                      windSpeed: double.parse(
                                          windspeedCtlr.text.trim()),
                                      rainfall: double.parse(
                                          rainfallCtlr.text.trim()),
                                      location: selectedLocation,
                                      locationCode: selectedLocationCode,
                                      isFirstDay: true);
                                  setState(() {
                                    selectedLocation = "Choose Location";
                                    selectedLocationCode = "";
                                  });
                                  typhoonNameCtlr.clear();
                                  windspeedCtlr.clear();
                                  rainfallCtlr.clear();
                                  locationCtlr.clear();
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
                      color: Colors.blue,
                    ))
                  ],
                )),
          ],
        ));
  }

  showSampleDialog() {
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
                                        'Select Municipality',
                                        style:
                                            textStyles.lato_bold(fontSize: 16),
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
                                          selectedLocation = loc.munName!;
                                          selectedLocationCode = loc.munCode!;
                                        });
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
                                              selectedLocation = loc.munName!;
                                              selectedLocationCode =
                                                  loc.munCode!;
                                            });
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
