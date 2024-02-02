import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';
import 'package:typhoonista_thesis/entities/Location_.dart';
import 'package:typhoonista_thesis/entities/TyphoonDay.dart';
import 'package:typhoonista_thesis/home_pages/sidebar_widgets/logo.dart';
import 'package:typhoonista_thesis/providers/page_provider.dart';
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
  bool haveAdded = false;

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
  String distrackminfinal = 'Distance of Typhoon to Location';
  bool isFetchingPrediction = false;
  bool isAddingTyphoon = false;
  double? test_area;
  double? test_yield;
  bool isEstimationError = false;
  bool isEstimationSuccess = false;
  TyphoonDay? newlyAddedDayInformation;
  String? errorMessage;

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
        // padding: EdgeInsets.only(left: 70),
        child: Column(
      children: [
        Expanded(
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
                    height: 30,
                  ),
                  TextField(
                    enabled: !haveAdded,
                    style: textStyles.lato_regular(),
                    controller: typhNameController,
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 10),
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
                        labelText: "Name"),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    enabled: !haveAdded,
                    style: textStyles.lato_regular(),
                    controller: windspeedController,
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 10),
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
                    height: 15,
                  ),
                  TextField(
                    enabled: !haveAdded,
                    style: textStyles.lato_regular(),
                    controller: rainfall24hController,
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 10),
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
                        labelText: "Peak Rainfall (24 hour)"),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    enabled: !haveAdded,
                    style: textStyles.lato_regular(),
                    controller: rainfall6hController,
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 10),
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
                        labelText: "Peak Rainfall (6 hour)"),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    enabled: !haveAdded,
                    style: textStyles.lato_regular(),
                    controller: priceController,
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 10),
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
                    height: 15,
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(5),
                    onTap: (haveAdded) ? null : ((){showLocationDialog();}),
                    child: Container(
                      width: double.maxFinite,
                      height: 48,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: (haveAdded) ? Colors.grey.shade300 : Colors.grey.shade600.withOpacity(0.5),
                              width: 1,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              selectedMunicipalName,
                              style:
                                  (selectedMunicipalName == 'Select Location' || haveAdded)
                                      ? textStyles.lato_light(fontSize: 17)
                                      : textStyles.lato_regular(fontSize: 17),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              size: 22,
                              color: (haveAdded) ? Colors.grey.shade300 : Colors.grey.shade600.withOpacity(0.5),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(5),
                    onTap: (selectedMunicipalName == 'Select Location' || haveAdded == true)
                        ? null
                        : (() {
                            showDistrackminOptions();
                          }),
                    child: Container(
                      width: double.maxFinite,
                      height: 48,
                      decoration: BoxDecoration(
                          color: (selectedMunicipalName == 'Select Location') ? Colors.grey.shade300 : Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              width: 1,
                              color: (haveAdded) ? Colors.grey.shade300 : Colors.grey.shade600.withOpacity(0.5),
                              style: BorderStyle.solid)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              distrackminfinal,
                              style: (distrackminfinal ==
                                      'Distance of Typhoon to Location' || haveAdded)
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
                                : 
                                Icon(
                                    Icons.arrow_drop_down,
                                    size: 22,
                                    color: (haveAdded) ? Colors.grey.shade300 : Colors.grey.shade600.withOpacity(0.5),
                                  )
                          ],
                        ),
                      ),
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
                        onTap: (haveAdded) ? null : (() async {
                          TyphoonDay? addDay;
                        try {
                          setState(() {
                            haveAdded = true;
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
                            isFetchingPrediction = false;
                          });
                          print("BRUHHH ${damageCostPredictionFromAPI}");
                          setState(() {
                            isAddingTyphoon = true;
                          });
                          addDay = await FirestoreService().addDay(
                              damageCost: double.parse(
                                  damageCostPredictionFromAPI!
                                      .toStringAsFixed(2)),
                              windSpeed:
                                  double.parse(windspeedController.text.trim()),
                              rainfall24:
                                  double.parse(rainfall24hController.text.trim()),
                              rainfall6:
                                  double.parse(rainfall6hController.text.trim()),
                              disTrackMin: double.parse(distrackminfinal),
                              location: selectedMunicipalName,
                              locationCode: selectedMunicipalCode,
                              typhoonName: typhNameController.text.trim(),
                              isFirstDay: true,
                              price: double.parse(priceController.text.trim()));
                          setState(() {
                            isAddingTyphoon = false;
                            
                            try {
                              newlyAddedDayInformation = addDay;
                            } catch (e) {
                              print("ERROR SA NEWLYADDEDDAY: ${e}");
                            }
                            isEstimationSuccess = true;
                          });
                        } catch (e) {
                          setState(() {
                            isAddingTyphoon = false;
                            isFetchingPrediction = false;
                            isEstimationError = true;
                            errorMessage = e.toString();
                          });
                        }
                        setState(() {
                          print("resetting");
                          selectedMunicipalName = "Choose Location";
                          selectedMunicipalCode = "";
                          selectedTyphoonLocation = "Choose Location";
                          selectedTyphoonCode = "";
                          selectedLocationProvname = "";
                          distrackminfinal = "Distance of Typhoon to Location";
                          typhNameController.clear();
                          windspeedController.clear();
                          rainfall24hController.clear();
                          rainfall6hController.clear();
                          priceController.clear();
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
              // color: Colors.red,
              child: 
              (isAddingTyphoon) 
              ?  
              addingToDatabase()
              :
              (isFetchingPrediction)
              ?
              fetchingPrediction()
              :
              (isEstimationError)
              ?
              estimationError(errorMessage!)
              :
              (isEstimationSuccess)
              ?
              Information()
              :
              logoLarge()
            ))
          ],
        )),
      ],
    ));
  }

  Widget logoLarge(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Image.asset('lib/assets/images/largevector.png', height: MediaQuery.of(context).size.height,)
      ],
    );
  }

  Widget Information() {
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
      // color: Colors.red,
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40),
          Container(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.66),
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              width: double.maxFinite,
              decoration: BoxDecoration(
                boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: (haveAdded)
                  ? Container(
                    // color: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // SizedBox(height: 20),
                          Text(
                            "Estimation",
                            style: textStyles.lato_black(fontSize: 30),
                          ),
                          Divider(),
                          SizedBox(height: 30,),
                          Container(
                            // color: Colors.yellow,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                              textStyles.lato_light(fontSize: 14),
                                        ),
                                        Text(
                                          '${newlyAddedDayInformation!.typhoonName}',
                                          style:
                                              textStyles.lato_black(fontSize: 20),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Predicted Damage Cost:',
                                          style:
                                              textStyles.lato_light(fontSize: 14),
                                        ),
                                        Text(
                                          '₱ ${NumberFormat('#,##0.00', 'en_US').format(newlyAddedDayInformation!.damageCost)}',
                                          style:
                                              textStyles.lato_black(fontSize: 20),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Day:',
                                          style:
                                              textStyles.lato_light(fontSize: 14),
                                        ),
                                        Text(
                                          '${newlyAddedDayInformation!.day}',
                                          style:
                                              textStyles.lato_black(fontSize: 20),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Date Recorded:',
                                          style:
                                              textStyles.lato_light(fontSize: 14),
                                        ),
                                        Text(
                                          '${DateTime.parse(newlyAddedDayInformation!.dateRecorded).year}-${DateTime.parse(newlyAddedDayInformation!.dateRecorded).month}-${DateTime.parse(newlyAddedDayInformation!.dateRecorded).day} ${DateTime.parse(newlyAddedDayInformation!.dateRecorded).hour}:${DateTime.parse(newlyAddedDayInformation!.dateRecorded).minute}',
                                          style:
                                              textStyles.lato_black(fontSize: 20),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Peak Windspeed:',
                                          style:
                                              textStyles.lato_light(fontSize: 14),
                                        ),
                                        Text(
                                          '${newlyAddedDayInformation!.windSpeed} kph',
                                          style:
                                              textStyles.lato_black(fontSize: 20),
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
                                              textStyles.lato_light(fontSize: 14),
                                        ),
                                        Text(
                                          '${newlyAddedDayInformation!.rainfall24} mm',
                                          style:
                                              textStyles.lato_black(fontSize: 20),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Peak Rainfall (6H):',
                                          style:
                                              textStyles.lato_light(fontSize: 14),
                                        ),
                                        Text(
                                          '${newlyAddedDayInformation!.rainfall6} mm',
                                          style:
                                              textStyles.lato_black(fontSize: 20),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Location:',
                                          style:
                                              textStyles.lato_light(fontSize: 14),
                                        ),
                                        Text(
                                          '${newlyAddedDayInformation!.location}',
                                          style:
                                              textStyles.lato_black(fontSize: 20),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Typhoon to Location Distance:',
                                          style:
                                              textStyles.lato_light(fontSize: 14),
                                        ),
                                        Text(
                                          '${newlyAddedDayInformation!.distrackmin} km',
                                          style:
                                              textStyles.lato_black(fontSize: 20),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Rice Price (per kilo):',
                                          style:
                                              textStyles.lato_light(fontSize: 14),
                                        ),
                                        Text(
                                          '${newlyAddedDayInformation!.price}',
                                          style:
                                              textStyles.lato_black(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
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
                        setState(() {
                          haveAdded = false;
                          newlyAddedDayInformation = null;
                          isEstimationSuccess = false;
                        });
                        context.read<page_provider>().changePage(1);
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
                        "Proceed to Dashboard",
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

  Widget estimationError(String err) {
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
          height: 30,
        ),
        Text(
          'ERROR: $err',
          style: textStyles.lato_bold(fontSize: 22),
        ),
      ],
    );
  }


  Widget fetchingPrediction(){
    return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  const SpinKitSpinningLines(
                      lineWidth: 4, size: 150, color: Colors.blue),
                  SizedBox(height: 60),
                  Text(
                    'Estimating.',
                    style: textStyles.lato_bold(
                        fontSize: 22, color: Colors.black.withOpacity(0.4)),
                  ),
                  Text(
                    'This may take a while...',
                    style: textStyles.lato_bold(
                        fontSize: 22, color: Colors.black.withOpacity(0.4)),
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
                          height: 22,
                          color: Color(0xff0090D9).withOpacity(0.3),
                        ),
                        SizedBox(width: 5),
                        Text('TYPHOONISTA',
                            style: textStyles.lato_bold(
                                fontSize: 14,
                                color: Color(0xff0090D9).withOpacity(0.3)))
                      ]),
                  SizedBox(
                    height: 30,
                  ),
                ],
    );
  }


  Widget addingToDatabase(){
    return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  const SpinKitSpinningLines(
                      lineWidth: 4, size: 150, color: Colors.blue),
                  SizedBox(height: 60),
                  Text(
                    'Adding Estimation to',
                    style: textStyles.lato_bold(
                        fontSize: 22, color: Colors.black.withOpacity(0.4)),
                  ),
                  Text(
                    'Database...',
                    style: textStyles.lato_bold(
                        fontSize: 22, color: Colors.black.withOpacity(0.4)),
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
                          height: 22,
                          color: Color(0xff0090D9).withOpacity(0.3),
                        ),
                        SizedBox(width: 5),
                        Text('TYPHOONISTA - ${DateTime.now().year}',
                            style: textStyles.lato_bold(
                                fontSize: 14,
                                color: Color(0xff0090D9).withOpacity(0.3)))
                      ]),
                  SizedBox(
                    height: 30,
                  ),
                ],
    );
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
                              borderRadius: BorderRadius.circular(15),
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
                              borderRadius: BorderRadius.circular(15),
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
