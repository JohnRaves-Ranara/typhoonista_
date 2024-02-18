import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/entities2/new/Municipality.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/entities2/new/Province.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/entities2/new/Typhoon.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/services2/FirestoreService2.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class typhoon_donutchart extends StatefulWidget {
  const typhoon_donutchart({super.key});

  @override
  State<typhoon_donutchart> createState() => _typhoon_donutchartState();
}

class _typhoon_donutchartState extends State<typhoon_donutchart> {
  List<String> options = ['Municipal', 'Provincial'];
  late String selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = options[0];
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 40,
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: Offset(0, 3),
                  blurRadius: 2,
                  spreadRadius: 1,
                ),
              ]),
          child: Stack(
            children: [
              (selectedOption == 'Municipal')
                  ? StreamBuilder<List<Municipality>>(
                      stream: FirestoreService2().streamAllMunicipalities(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Municipality> municipalities = snapshot.data!;
                          List<int> damagePercentages =
                              municipalConvertToPercentages(municipalities);
                          for (int i = 0; i < municipalities.length; i++) {
                            municipalities[i].damageCostInPercentage =
                                damagePercentages[i];
                          }
                          return Row(
                                children: [
                                Expanded(
                                  flex: 60,
                                  child: Container(
                                    child: SfCircularChart(
                                      tooltipBehavior: TooltipBehavior(
                                          enable: true,
                                          activationMode:
                                              ActivationMode.longPress,
                                          animationDuration: 100),
                                      series: <CircularSeries>[
                                        DoughnutSeries<Municipality, String>(
                                          dataLabelSettings: DataLabelSettings(
                                            textStyle: textStyles.lato_regular(
                                                fontSize: 12),
                                            isVisible: true,
                                            margin: EdgeInsets.zero,
                                            // connectorLineSettings:
                                            //     ConnectorLineSettings(
                                            //         length: '20%',
                                            //         type:
                                            //             ConnectorType.curve),
                                            labelPosition:
                                                ChartDataLabelPosition.outside,
                                            overflowMode: OverflowMode.shift,
                                            labelIntersectAction:
                                                LabelIntersectAction.shift,
                                          ),
                                          dataLabelMapper: (Municipality data,
                                                  _) =>
                                              "₱ ${NumberFormat('#,##0.00', 'en_US').format(data.totalDamageCost)}",
                                          pointColorMapper:
                                              (Municipality data, _) =>
                                                  data.colorMarker,
                                          dataSource: municipalities,
                                          xValueMapper: (Municipality data, _) =>
                                              data.munName,
                                          yValueMapper: (Municipality data, _) =>
                                              data.totalDamageCost,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 40,
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Total Damage Cost\nto Rice Crops',
                                          textAlign: TextAlign.center,
                                          style:
                                              textStyles.lato_bold(fontSize: 18),
                                        ),
                                        SizedBox(height: 10,),
                                        Container(
                                          height: 30,
                                          width: 130,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  offset: Offset(0, 3),
                                                  blurRadius: 2,
                                                  spreadRadius: 1,
                                                ),
                                              ]),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton2<String>(
                                              isExpanded: true,
                                              iconStyleData:
                                                  IconStyleData(iconSize: 20),
                                              items: options
                                                  .map((opt) =>
                                                      DropdownMenuItem<String>(
                                                        child: Text(
                                                          opt,
                                                          style: textStyles
                                                              .lato_regular(
                                                                  fontSize: 13),
                                                        ),
                                                        value: opt,
                                                      ))
                                                  .toList(),
                                              value: selectedOption,
                                              onChanged: (newOption) {
                                                setState(() {
                                                  selectedOption = newOption!;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Container(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: municipalities
                                                      .map(
                                                          (municipality) => Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        bottom: 5),
                                                                child: Row(
                                                                  children: [
                                                                    CircleAvatar(
                                                                      radius: 8,
                                                                      backgroundColor:
                                                                          municipality
                                                                              .colorMarker,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Text(
                                                                      municipality
                                                                          .munName,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      style: textStyles
                                                                          .lato_light(
                                                                              fontSize:
                                                                                  14),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ))
                                                      .toList(),
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: municipalities
                                                      .map(
                                                          (municipality) => Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        bottom: 5),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      '${municipality.damageCostInPercentage}%',
                                                                      style: textStyles
                                                                          .lato_light(
                                                                              fontSize:
                                                                                  14),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ))
                                                      .toList(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ]);
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    )
                  : StreamBuilder<List<Province>>(
                      stream: FirestoreService2().streamAllProvinces(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Province> provinces = snapshot.data!;
                          List<int> damagePercentages =
                              provincialConvertToPercentages(provinces);
                          for (int i = 0; i < provinces.length; i++) {
                            provinces[i].damageCostInPercentage =
                                damagePercentages[i];
                          }
                          return Row(
                              children: [
                                Expanded(
                                  flex: 60,
                                  child: Container(
                                    child: SfCircularChart(
                                      tooltipBehavior: TooltipBehavior(
                                          enable: true,
                                          activationMode:
                                              ActivationMode.longPress,
                                          animationDuration: 100),
                                      series: <CircularSeries>[
                                        DoughnutSeries<Province, String>(
                                          dataLabelSettings: DataLabelSettings(
                                            textStyle: textStyles.lato_regular(
                                                fontSize: 12),
                                            isVisible: true,
                                            margin: EdgeInsets.zero,
                                            // connectorLineSettings:
                                            //     ConnectorLineSettings(
                                            //         length: '20%',
                                            //         type:
                                            //             ConnectorType.curve),
                                            labelPosition:
                                                ChartDataLabelPosition.outside,
                                            overflowMode: OverflowMode.shift,
                                            labelIntersectAction:
                                                LabelIntersectAction.shift,
                                          ),
                                          dataLabelMapper: (Province data, _) =>
                                              "₱ ${NumberFormat('#,##0.00', 'en_US').format(data.totalDamageCost)}",
                                          pointColorMapper: (Province data, _) =>
                                              data.colorMarker,
                                          dataSource: provinces,
                                          xValueMapper: (Province data, _) =>
                                              data.provName,
                                          yValueMapper: (Province data, _) =>
                                              data.totalDamageCost,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 40,
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Total Damage Cost\nto Rice Crops',
                                          textAlign: TextAlign.center,
                                          style:
                                              textStyles.lato_bold(fontSize: 18),
                                        ),
                                        SizedBox(height: 10,),
                                        Container(
                                          height: 30,
                                          width: 130,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  offset: Offset(0, 3),
                                                  blurRadius: 2,
                                                  spreadRadius: 1,
                                                ),
                                              ]),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton2<String>(
                                              isExpanded: true,
                                              iconStyleData:
                                                  IconStyleData(iconSize: 20),
                                              items: options
                                                  .map((opt) =>
                                                      DropdownMenuItem<String>(
                                                        child: Text(
                                                          opt,
                                                          style: textStyles
                                                              .lato_regular(
                                                                  fontSize: 13),
                                                        ),
                                                        value: opt,
                                                      ))
                                                  .toList(),
                                              value: selectedOption,
                                              onChanged: (newOption) {
                                                setState(() {
                                                  selectedOption = newOption!;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Container(
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: provinces
                                                      .map((prov) => Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom: 5),
                                                            child: Row(
                                                              children: [
                                                                CircleAvatar(
                                                                  radius: 8,
                                                                  backgroundColor:
                                                                      prov.colorMarker,
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text(
                                                                  prov.provName,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: textStyles
                                                                      .lato_light(
                                                                          fontSize:
                                                                              14),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                              ],
                                                            ),
                                                          ))
                                                      .toList(),
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: provinces
                                                      .map((prov) => Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom: 5),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  '${prov.damageCostInPercentage}%',
                                                                  style: textStyles
                                                                      .lato_light(
                                                                          fontSize:
                                                                              14),
                                                                ),
                                                              ],
                                                            ),
                                                          ))
                                                      .toList(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ]);
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
              // Positioned(
              //   top: 0,
              //   left: 0,
              //   child:
              //   Container(
              //     height: 30,
              //     width: 130,
              //     decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(5),
              //         color: Colors.white,
              //         boxShadow: [
              //           BoxShadow(
              //             color: Colors.black.withOpacity(0.2),
              //             offset: Offset(0, 3),
              //             blurRadius: 2,
              //             spreadRadius: 1,
              //           ),
              //         ]),
              //     child: DropdownButtonHideUnderline(
              //       child: DropdownButton2<String>(
              //         isExpanded: true,
              //         iconStyleData: IconStyleData(iconSize: 20),
              //         items: options
              //             .map((opt) => DropdownMenuItem<String>(
              //                   child: Text(
              //                     opt,
              //                     style: textStyles.lato_regular(fontSize: 13),
              //                   ),
              //                   value: opt,
              //                 ))
              //             .toList(),
              //         value: selectedOption,
              //         onChanged: (newOption) {
              //           setState(() {
              //             selectedOption = newOption!;
              //           });
              //         },
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ));
  }

  List<int> municipalConvertToPercentages(List<Municipality> municipalities) {
    List<double> damageCosts =
        municipalities.map((mun) => mun.totalDamageCost).toList();
    double sum = damageCosts.reduce((value, element) => value + element);
    List<int> percentages =
        damageCosts.map((number) => (number * 100) ~/ sum).toList();

    return percentages;
  }

  List<int> provincialConvertToPercentages(List<Province> provinces) {
    List<double> damageCosts =
        provinces.map((mun) => mun.totalDamageCost).toList();
    double sum = damageCosts.reduce((value, element) => value + element);
    List<int> percentages =
        damageCosts.map((number) => (number * 100) ~/ sum).toList();

    return percentages;
  }
}
