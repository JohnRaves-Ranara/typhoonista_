import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/entities2/new/Day.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/entities2/new/GetLocations.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/entities2/new/Location.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/entities2/new/Owner.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/entities2/new/Province.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/entities2/new/Typhoon.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/services2/FirestoreService2.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';

class edit_params extends StatefulWidget {
  const edit_params({super.key});

  @override
  State<edit_params> createState() => _edit_paramsState();
}

class _edit_paramsState extends State<edit_params> {
  final windspeedCtlr = TextEditingController();
  final rainfall6Ctlr = TextEditingController();
  final rainfall24Ctlr = TextEditingController();
  final ricePriceCtlr = TextEditingController();
  final manualDistanceCtrlr = TextEditingController();
  final riceAreaCtrlr = TextEditingController();
  final yieldCtrlr = TextEditingController();
  String? distrackminfinal;
  bool isFetchingPrediction = false;
  final daysCountCtrlr = TextEditingController();
  Owner? selectedOwner;

  //FOR SELECTING LOCATION
  final provinceController = TextEditingController();
  bool isSearchLocationProvince = false;
  List<Location> provinces = [];
  List<Location> municipalities = [];
  List<Location> provinceSuggestions = [];
  List<Location> municipalitySuggestions = [];
  Location? selectedProvince;
  bool isLoadingProvinces = false;
  Location? selectedMunicipality;
  bool isLoadingMunicipalities = false;
  bool isSearchLocationMunicipality = false;
  final municipalityController = TextEditingController();
  bool isSettingSelectedOwner = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<Typhoon>(
        stream: FirestoreService2().streamOngoingTyphoon(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return InkWell(
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
                                  width: (isFetchingPrediction == true)
                                      ? MediaQuery.of(context).size.width * 0.4
                                      : MediaQuery.of(context).size.width * 0.7,
                                  child: (isFetchingPrediction == true)
                                      ? fetchingPrediction()
                                      //     : (isAddingTyphoon)
                                      //         ? addingToDatabase()
                                      //         : (isEstimationError)
                                      //             ? estimationError(
                                      //                 errorMessage!, customState)
                                      // : (isEstimationSuccess)
                                      //     ? Information(customState)
                                      //                 :
                                      : add_day(
                                          // recentEstimation,
                                          customState, snapshot.data!)),
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
                      child: Image.asset('lib/assets/images/Vector (1).png',
                          height: 20)),
                  Text(
                    'Edit Parameters',
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
          );
          }else{
            return InkWell(
            onTap: null,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      // color: Colors.red,
                      child: Image.asset('lib/assets/images/Vector (1).png',
                          height: 20)),
                  Text(
                    'Edit Parameters',
                    style: textStyles.lato_bold(fontSize: 16),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[300],
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
          );
          }
        }
      ),
    );
  }

  Widget fetchingPrediction() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 60,
        ),
        const SpinKitSpinningLines(lineWidth: 4, size: 150, color: Colors.blue),
        SizedBox(height: 60),
        Text(
          'Updating Estimation.',
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
                      fontSize: 14, color: Color(0xff0090D9).withOpacity(0.3)))
            ]),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }

  Future<void> _setSelectedOwner(Function customState, Owner owner) async {
    //SET SELECTEDOWNER, SET INPUTS TO SELECTEDOWNER'S ATTRIBUTES
    customState(() {
      isSettingSelectedOwner = true;
    });
    selectedOwner = owner;
    List<Day> allDaysOfSelectedOwner = await FirestoreService2().getAllDays(
        owner.typhoonID!, owner.provinceID!, owner.municipalityID!, owner.id);
    Day selectedOwnerDay1 =
        allDaysOfSelectedOwner.firstWhere((day) => day.dayNum == 1);

    //DAY
    windspeedCtlr.text = selectedOwnerDay1.windSpeed.toString();
    rainfall24Ctlr.text = selectedOwnerDay1.rainfall24.toString();
    rainfall6Ctlr.text = selectedOwnerDay1.rainfall6.toString();
    ricePriceCtlr.text = selectedOwnerDay1.ricePrice.toString();
    riceAreaCtrlr.text = selectedOwnerDay1.riceArea.toString();
    yieldCtrlr.text = selectedOwnerDay1.riceYield.toString();
    distrackminfinal = selectedOwnerDay1.distance.toString();
    manualDistanceCtrlr.text = distrackminfinal!;

    //OWNER
    int totalNumberOfDays = allDaysOfSelectedOwner.length;
    daysCountCtrlr.text = totalNumberOfDays.toString();
    selectedProvince = Location(
        provID: owner.provinceID,
        provName: owner.provName,
        munID: owner.municipalityID,
        munName: owner.munName);
    selectedMunicipality = Location(
        provID: owner.provinceID,
        provName: owner.provName,
        munID: owner.municipalityID,
        munName: owner.munName);

    customState(() {
      isSettingSelectedOwner = false;
    });
  }

  showAllOwners(Function customState, Typhoon ongoingTyphoonID) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              width: MediaQuery.of(context).size.width * 0.53,
              padding: EdgeInsets.all(10),
              child: StreamBuilder<List<Owner>>(
                stream: FirestoreService2().streamAllOwners(ongoingTyphoonID),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Owner> allOwners = snapshot.data!;

                    allOwners.sort((a, b) => DateTime.parse(b.dateRecorded!)
                        .compareTo(DateTime.parse(a.dateRecorded!)));
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text(
                          "Your Estimations",
                          style: textStyles.lato_black(fontSize: 25),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        (isSettingSelectedOwner == true)
                            ? Expanded(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : SingleChildScrollView(
                                child: Container(
                                  width: double.maxFinite,
                                  child: DataTable(
                                      showCheckboxColumn: false,
                                      columns: [
                                        DataColumn(
                                            label: Text(
                                          'Name',
                                          style: textStyles.lato_bold(),
                                        )),
                                        DataColumn(
                                            label: Text(
                                          'Date Recorded',
                                          style: textStyles.lato_bold(),
                                        )),
                                        DataColumn(
                                            label: Text(
                                          'Time Recorded',
                                          style: textStyles.lato_bold(),
                                        )),
                                        DataColumn(
                                            label: Text(
                                          'Total Damage Cost',
                                          style: textStyles.lato_bold(),
                                        ))
                                      ],
                                      rows: allOwners
                                          .map((owner) => DataRow(
                                                  onSelectChanged:
                                                      (isSelected) {
                                                    customState(() {
                                                      _setSelectedOwner(
                                                          customState, owner);
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  cells: [
                                                    DataCell(Text(
                                                        owner.ownerName,
                                                        style: textStyles
                                                            .lato_regular())),
                                                    DataCell(Text(
                                                        "${DateTime.parse(owner.dateRecorded!).month}/${DateTime.parse(owner.dateRecorded!).day}/${DateTime.parse(owner.dateRecorded!).year}",
                                                        style: textStyles
                                                            .lato_regular())),
                                                    DataCell(Text(
                                                        "${DateTime.parse(owner.dateRecorded!).hour.toString().padLeft(2, '0')}:${DateTime.parse(owner.dateRecorded!).minute.toString().padLeft(2, '0')}:${DateTime.parse(owner.dateRecorded!).second.toString().padLeft(2, '0')}",
                                                        style: textStyles
                                                            .lato_regular())),
                                                    DataCell(Text(
                                                        owner.totalDamageCost
                                                            .toString(),
                                                        style: textStyles
                                                            .lato_regular()))
                                                  ]))
                                          .toList()),
                                ),
                              )
                      ],
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          );
        });
  }

  Widget add_day(
      // Typhoon recentEstimation,
      Function customState, Typhoon ongoingTyphoon) {
    return Container(
      // color: Colors.amber,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
          ),
          Container(
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Edit an Estimation",
                    style: textStyles.lato_black(fontSize: 35),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: (() {
                      showAllOwners(customState, ongoingTyphoon);
                    }),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1,
                              color: Colors.grey.shade600.withOpacity(0.5),
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              selectedOwner?.ownerName ??
                                  "Select Estimation to Edit",
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
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          (selectedOwner == null)
              ? Container(
                  height: 300,
                  child: Center(
                    child: Text(
                      "No selected Estimation",
                      style: textStyles.lato_regular(fontSize: 20),
                    ),
                  ),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        // color: Colors.purple,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextField(
                              style: textStyles.lato_regular(),
                              enabled: selectedOwner != null,
                              controller: windspeedCtlr,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                  fillColor: Colors.white,
                                  labelStyle: textStyles.lato_light(
                                      color: Colors.black),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade600
                                              .withOpacity(0.5),
                                          width: 1,
                                          style: BorderStyle.solid)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade600,
                                          width: 1,
                                          style: BorderStyle.solid)),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade600
                                              .withOpacity(0.5),
                                          width: 1,
                                          style: BorderStyle.solid)),
                                  labelText: "Windspeed"),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              style: textStyles.lato_regular(),
                              enabled: selectedOwner != null,
                              controller: rainfall24Ctlr,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                  fillColor: Colors.white,
                                  labelStyle: textStyles.lato_light(
                                      color: Colors.black),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade600
                                              .withOpacity(0.5),
                                          width: 1,
                                          style: BorderStyle.solid)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade600,
                                          width: 1,
                                          style: BorderStyle.solid)),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade600
                                              .withOpacity(0.5),
                                          width: 1,
                                          style: BorderStyle.solid)),
                                  labelText: "Rainfall (24H)"),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              style: textStyles.lato_regular(),
                              enabled: selectedOwner != null,
                              controller: rainfall6Ctlr,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                  fillColor: Colors.white,
                                  labelStyle: textStyles.lato_light(
                                      color: Colors.black),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade600
                                              .withOpacity(0.5),
                                          width: 1,
                                          style: BorderStyle.solid)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade600,
                                          width: 1,
                                          style: BorderStyle.solid)),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade600
                                              .withOpacity(0.5),
                                          width: 1,
                                          style: BorderStyle.solid)),
                                  labelText: "Rainfall (6H)"),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              style: textStyles.lato_regular(),
                              enabled: selectedOwner != null,
                              controller: ricePriceCtlr,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                  fillColor: Colors.white,
                                  labelStyle: textStyles.lato_light(
                                      color: Colors.black),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade600
                                              .withOpacity(0.5),
                                          width: 1,
                                          style: BorderStyle.solid)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade600,
                                          width: 1,
                                          style: BorderStyle.solid)),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade600
                                              .withOpacity(0.5),
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextField(
                              style: textStyles.lato_regular(),
                              enabled: selectedOwner != null,
                              controller: riceAreaCtrlr,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                  fillColor: Colors.white,
                                  labelStyle: textStyles.lato_light(
                                      color: Colors.black),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade600
                                              .withOpacity(0.5),
                                          width: 1,
                                          style: BorderStyle.solid)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade600,
                                          width: 1,
                                          style: BorderStyle.solid)),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade600
                                              .withOpacity(0.5),
                                          width: 1,
                                          style: BorderStyle.solid)),
                                  labelText: "Rice Area (ha)"),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              style: textStyles.lato_regular(),
                              enabled: selectedOwner != null,
                              controller: yieldCtrlr,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                  fillColor: Colors.white,
                                  labelStyle: textStyles.lato_light(
                                      color: Colors.black),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade600
                                              .withOpacity(0.5),
                                          width: 1,
                                          style: BorderStyle.solid)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade600,
                                          width: 1,
                                          style: BorderStyle.solid)),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade600
                                              .withOpacity(0.5),
                                          width: 1,
                                          style: BorderStyle.solid)),
                                  labelText: "Yield (ton/ha)"),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: (selectedOwner != null)
                                  ? (() {
                                      showDistrackminOptions(customState);
                                    })
                                  : null,
                              child: Container(
                                height: 48,
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        color: Colors.grey.shade600
                                            .withOpacity(0.5),
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Distance of Typhoon to Location',
                                        style: textStyles.lato_regular(
                                            fontSize: 17),
                                      ),
                                      (distrackminfinal == null)
                                          ? Icon(
                                              Icons.arrow_drop_down,
                                              size: 22,
                                              color: Colors.black,
                                            )
                                          : Text(
                                              '${distrackminfinal} km/h',
                                              style: textStyles.lato_regular(
                                                  fontSize: 17),
                                            )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              style: textStyles.lato_regular(),
                              enabled: selectedOwner != null,
                              controller: daysCountCtrlr,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                  fillColor: Colors.white,
                                  labelStyle: textStyles.lato_light(
                                      color: Colors.black),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade600
                                              .withOpacity(0.5),
                                          width: 1,
                                          style: BorderStyle.solid)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade600,
                                          width: 1,
                                          style: BorderStyle.solid)),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade600
                                              .withOpacity(0.5),
                                          width: 1,
                                          style: BorderStyle.solid)),
                                  labelText: "Day Count"),
                            ),
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
                onTap: (selectedOwner != null)
                    ? (() async {
                        customState(() {
                          isFetchingPrediction = true;
                        });

                        await FirestoreService2().addOwner(
                            ongoingTyphoon.id,
                            selectedOwner,
                            selectedProvince!.provName,
                            selectedMunicipality!.munName,
                            double.parse(windspeedCtlr.text.trim()),
                            double.parse(rainfall24Ctlr.text.trim()),
                            double.parse(rainfall6Ctlr.text.trim()),
                            double.parse(ricePriceCtlr.text.trim()),
                            double.parse(riceAreaCtrlr.text.trim()),
                            double.parse(yieldCtrlr.text.trim()),
                            double.parse(distrackminfinal!),
                            int.parse(daysCountCtrlr.text.trim()));
                        customState(() {
                          isFetchingPrediction = false;
                        });
                        Navigator.pop(context);
                      })
                    : null,
                child: Ink(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  width: double.maxFinite,
                  height: 55,
                  child: Row(
                    children: [
                      Text(
                        "Confirm Changes",
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
                              onTap: null,
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
                                showManualDistanceCalculation(customState);
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

  showSelectProvinceDialog(Function customState1) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: (isLoadingProvinces == true)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: StatefulBuilder(
                      builder: (context, customState) {
                        return Column(
                          children: [
                            (isSearchLocationProvince)
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
                                              decoration: const InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText:
                                                      "Search Location...",
                                                  counterText: ""),
                                              controller: provinceController,
                                              onChanged: (value) {
                                                searchProvince(
                                                    value.trim(), customState);
                                              }),
                                        ),
                                        InkWell(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          onTap: (() {
                                            customState(() {
                                              isSearchLocationProvince = false;
                                              provinceController.clear();
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
                                                'Select Province',
                                                style: textStyles.lato_bold(
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          onTap: (() {
                                            customState(() {
                                              isSearchLocationProvince = true;
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
                              children: (provinceController.text.trim() == "")
                                  ? provinces
                                      .map((province) => ListTile(
                                            title: Text(province.provName!,
                                                style: textStyles.lato_regular(
                                                    fontSize: 14,
                                                    color: Colors.black)),
                                            onTap: (() {
                                              customState1(() {
                                                selectedProvince = province;
                                                selectedMunicipality = null;
                                                Navigator.pop(context);
                                              });
                                            }),
                                          ))
                                      .toList()
                                  : (provinceSuggestions.isNotEmpty)
                                      ? provinceSuggestions
                                          .map((province) => ListTile(
                                                title: Text(province.provName!,
                                                    style:
                                                        textStyles.lato_regular(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black)),
                                                onTap: (() {
                                                  customState1(() {
                                                    selectedProvince = province;
                                                    selectedMunicipality = null;
                                                    Navigator.pop(context);
                                                  });
                                                }),
                                              ))
                                          .toList()
                                      : [
                                          Center(
                                            child: Text(
                                              '${provinceController.text.trim()} does not exist.',
                                            ),
                                          )
                                        ],
                            ))
                          ],
                        );
                      },
                    ),
                  ),
          );
        });
  }

  showSelectMunicipalityDialog(Function customState1) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: (isLoadingMunicipalities == true)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: StatefulBuilder(
                      builder: (context, customState) {
                        return Column(
                          children: [
                            (isSearchLocationMunicipality)
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
                                              decoration: const InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText:
                                                      "Search Municipality...",
                                                  counterText: ""),
                                              controller:
                                                  municipalityController,
                                              onChanged: (value) {
                                                searchMunicipality(
                                                    value.trim(), customState);
                                              }),
                                        ),
                                        InkWell(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          onTap: (() {
                                            customState(() {
                                              isSearchLocationMunicipality =
                                                  false;
                                              municipalityController.clear();
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
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          onTap: (() {
                                            customState(() {
                                              isSearchLocationMunicipality =
                                                  true;
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
                              children: (municipalityController.text.trim() ==
                                      "")
                                  ? municipalities
                                      .map((municipality) => ListTile(
                                            title: Text(municipality.munName!,
                                                style: textStyles.lato_regular(
                                                    fontSize: 14,
                                                    color: Colors.black)),
                                            onTap: (() {
                                              customState1(() {
                                                selectedMunicipality =
                                                    municipality;
                                                Navigator.pop(context);
                                              });
                                            }),
                                          ))
                                      .toList()
                                  : (municipalitySuggestions.isNotEmpty)
                                      ? municipalitySuggestions
                                          .map((municipality) => ListTile(
                                                title: Text(
                                                    municipality.munName!,
                                                    style:
                                                        textStyles.lato_regular(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black)),
                                                onTap: (() {
                                                  customState1(() {
                                                    municipality = municipality;
                                                    Navigator.pop(context);
                                                  });
                                                }),
                                              ))
                                          .toList()
                                      : [
                                          Center(
                                            child: Text(
                                              '${municipalityController.text.trim()} does not exist.',
                                            ),
                                          )
                                        ],
                            ))
                          ],
                        );
                      },
                    ),
                  ),
          );
        });
  }

  searchProvince(String query, Function customState) {
    customState(() {
      provinceSuggestions = provinces.where((province) {
        final provName = province.provName!.toLowerCase();
        final input = query.toLowerCase();
        return provName.contains(input);
      }).toList();
    });
  }

  searchMunicipality(String query, Function customState) {
    customState(() {
      municipalitySuggestions = municipalities.where((municipality) {
        final munName = municipality.munName!.toLowerCase();
        final input = query.toLowerCase();
        return munName.contains(input);
      }).toList();
    });
  }
}
