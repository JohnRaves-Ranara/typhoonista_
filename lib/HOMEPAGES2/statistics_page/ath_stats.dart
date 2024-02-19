import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/entities2/new/Day.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/services2/FirestoreService2.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/entities2/new/Province.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/entities2/new/Municipality.dart';
import 'package:intl/intl.dart';

class ath_stats extends StatefulWidget {
  const ath_stats({super.key});

  @override
  State<ath_stats> createState() => _ath_statsState();
}

class _ath_statsState extends State<ath_stats> {
  List<String> options = ['Provincial', 'Municipal'];
  List<String> graphOptions = ['Highest', 'Average'];

  String selectedOption = 'Provincial';
  String selectedGraphOption = 'Highest';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Additional Graphs", style: textStyles.lato_black(fontSize: 26),),
              Row(
                children: [
                  Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: Offset(0, 3),
                        blurRadius: 2,
                        spreadRadius: 1,
                      ),
                    ]),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    iconStyleData: IconStyleData(iconSize: 20),
                    items: graphOptions
                        .map((opt) => DropdownMenuItem<String>(
                              child: Text(
                                opt,
                                style: textStyles.lato_regular(fontSize: 16),
                              ),
                              value: opt,
                            ))
                        .toList(),
                    value: selectedGraphOption,
                    onChanged: (newOption) {
                      setState(() {
                        selectedGraphOption = newOption!;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(width: 20,),
                  Container(
                    height: 50,
                    width: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: Offset(0, 3),
                            blurRadius: 2,
                            spreadRadius: 1,
                          ),
                        ]),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        iconStyleData: IconStyleData(iconSize: 20),
                        items: options
                            .map((opt) => DropdownMenuItem<String>(
                                  child: Text(
                                    opt,
                                    style: textStyles.lato_regular(fontSize: 16),
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
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                child: Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
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
                          child: (selectedOption=='Provincial')
                          ?
                          StreamBuilder<List<Province>>(
                              stream: FirestoreService2().streamAllProvinces2(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final List<Province> provinces =
                                      snapshot.data!;
                                  return SfCartesianChart(
                                    trackballBehavior: TrackballBehavior(
                                      activationMode: ActivationMode.singleTap,
                                      enable: true,
                                      tooltipSettings: InteractiveTooltip(
                                        format:
                                            'point.y', // Display the Y-axis value in the tooltip
                                      ),
                                    ),
                                    title: ChartTitle(
                                        text: "Total Damage Costs",
                                        textStyle: textStyles.lato_bold()),
                                    primaryXAxis: CategoryAxis(
                                      labelStyle: textStyles.lato_regular(),
                                    ),
                                    primaryYAxis: NumericAxis(
                                      labelStyle: textStyles.lato_regular(),
                                      numberFormat: NumberFormat.compact(),
                                    ),
                                    series: [
                                      ColumnSeries<Province, String>(
                                        animationDuration: 300,
                                        dataSource: provinces,
                                        xValueMapper: (Province province, _) =>
                                            province.provName,
                                        yValueMapper: (Province province, _) =>
                                            province.totalDamageCost,
                                        pointColorMapper: (Province prov, _) =>
                                            prov.colorMarker,
                                      ),
                                    ],
                                  );
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              })
                              :
                              StreamBuilder<List<Municipality>>(
                              stream: FirestoreService2().streamAllMunicipalities2(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final List<Municipality> muns =
                                      snapshot.data!;
                                  return SfCartesianChart(
                                    trackballBehavior: TrackballBehavior(
                                      activationMode: ActivationMode.singleTap,
                                      enable: true,
                                      tooltipSettings: InteractiveTooltip(
                                        format:
                                            'point.y', // Display the Y-axis value in the tooltip
                                      ),
                                    ),
                                    title: ChartTitle(
                                        text: "Total Damage Costs",
                                        textStyle: textStyles.lato_bold()),
                                    primaryXAxis: CategoryAxis(
                                      labelStyle: textStyles.lato_regular(),
                                    ),
                                    primaryYAxis: NumericAxis(
                                      labelStyle: textStyles.lato_regular(),
                                      numberFormat: NumberFormat.compact(),
                                    ),
                                    series: [
                                      ColumnSeries<Municipality, String>(
                                        animationDuration: 300,
                                        dataSource: muns,
                                        xValueMapper: (Municipality mun, _) =>
                                            mun.munName,
                                        yValueMapper: (Municipality mun, _) =>
                                            mun.totalDamageCost,
                                        pointColorMapper: (Municipality prov, _) =>
                                            prov.colorMarker,
                                      ),
                                    ],
                                  );
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              }),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
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
                          child: (selectedOption=='Provincial')
                          
                          ?
                          FutureBuilder(
                              future: FirestoreService2().futureAllProvinces(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final List<Province> provinces =
                                      snapshot.data!;

                                  return 
                                  (selectedGraphOption == 'Highest')
                                  ?
                                  FutureBuilder(
                                      future: FirestoreService2()
                                          .setProvincesHighestAtts(provinces),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final provinces = snapshot.data!;
                                          return SfCartesianChart(
                                            trackballBehavior:
                                                TrackballBehavior(
                                              activationMode:
                                                  ActivationMode.singleTap,
                                              enable: true,
                                              tooltipSettings:
                                                  InteractiveTooltip(
                                                format:
                                                    'point.y', // Display the Y-axis value in the tooltip
                                              ),
                                            ),
                                            title: ChartTitle(
                                                text:
                                                    "Highest Recorded Windspeed",
                                                textStyle:
                                                    textStyles.lato_bold()),
                                            primaryXAxis: CategoryAxis(
                                              labelStyle:
                                                  textStyles.lato_regular(),
                                            ),
                                            primaryYAxis: NumericAxis(
                                              labelStyle:
                                                  textStyles.lato_regular(),
                                              numberFormat:
                                                  NumberFormat.compact(),
                                            ),
                                            series: [
                                              ColumnSeries<Province, String>(
                                                animationDuration: 300,
                                                dataSource: provinces,
                                                xValueMapper:
                                                    (Province province, _) =>
                                                        province.provName,
                                                yValueMapper:
                                                    (Province province, _) =>
                                                        province.highestWs,
                                                pointColorMapper:
                                                    (Province prov, _) =>
                                                        prov.colorMarker,
                                              ),
                                            ],
                                          );
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      })
                                      :
                                      FutureBuilder(
                                      future: FirestoreService2()
                                          .setProvincesAvgAtts(provinces),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final provinces = snapshot.data!;
                                          return SfCartesianChart(
                                            trackballBehavior:
                                                TrackballBehavior(
                                              activationMode:
                                                  ActivationMode.singleTap,
                                              enable: true,
                                              tooltipSettings:
                                                  InteractiveTooltip(
                                                format:
                                                    'point.y', // Display the Y-axis value in the tooltip
                                              ),
                                            ),
                                            title: ChartTitle(
                                                text:
                                                    "Average Windspeed",
                                                textStyle:
                                                    textStyles.lato_bold()),
                                            primaryXAxis: CategoryAxis(
                                              labelStyle:
                                                  textStyles.lato_regular(),
                                            ),
                                            primaryYAxis: NumericAxis(
                                              labelStyle:
                                                  textStyles.lato_regular(),
                                              numberFormat:
                                                  NumberFormat.compact(),
                                            ),
                                            series: [
                                              ColumnSeries<Province, String>(
                                                animationDuration: 300,
                                                dataSource: provinces,
                                                xValueMapper:
                                                    (Province province, _) =>
                                                        province.provName,
                                                yValueMapper:
                                                    (Province province, _) =>
                                                        province.avgWs,
                                                pointColorMapper:
                                                    (Province prov, _) =>
                                                        prov.colorMarker,
                                              ),
                                            ],
                                          );
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      });
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              })
                              :
                              FutureBuilder(
                              future: FirestoreService2().futureAllMunicipality(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final List<Municipality> municipalities =
                                      snapshot.data!;

                                  return (selectedGraphOption == 'Highest')
                                  ?
                                  FutureBuilder(
                                      future: FirestoreService2()
                                          .setMunicipalitiesHighestAtts(municipalities),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final municipalities = snapshot.data!;
                                          return SfCartesianChart(
                                            trackballBehavior:
                                                TrackballBehavior(
                                              activationMode:
                                                  ActivationMode.singleTap,
                                              enable: true,
                                              tooltipSettings:
                                                  InteractiveTooltip(
                                                format:
                                                    'point.y', // Display the Y-axis value in the tooltip
                                              ),
                                            ),
                                            title: ChartTitle(
                                                text:
                                                    "Highest Recorded Windspeed",
                                                textStyle:
                                                    textStyles.lato_bold()),
                                            primaryXAxis: CategoryAxis(
                                              labelStyle:
                                                  textStyles.lato_regular(),
                                            ),
                                            primaryYAxis: NumericAxis(
                                              labelStyle:
                                                  textStyles.lato_regular(),
                                              numberFormat:
                                                  NumberFormat.compact(),
                                            ),
                                            series: [
                                              ColumnSeries<Municipality, String>(
                                                animationDuration: 300,
                                                dataSource: municipalities,
                                                xValueMapper:
                                                    (Municipality mun, _) =>
                                                        mun.munName,
                                                yValueMapper:
                                                    (Municipality mun, _) =>
                                                        mun.highestWs,
                                                pointColorMapper:
                                                    (Municipality mun, _) =>
                                                        mun.colorMarker,
                                              ),
                                            ],
                                          );
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      })
                                      :
                                      FutureBuilder(
                                      future: FirestoreService2()
                                          .setMunicipalitiesAvgAtts(municipalities),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final municipalities = snapshot.data!;
                                          return SfCartesianChart(
                                            trackballBehavior:
                                                TrackballBehavior(
                                              activationMode:
                                                  ActivationMode.singleTap,
                                              enable: true,
                                              tooltipSettings:
                                                  InteractiveTooltip(
                                                format:
                                                    'point.y', // Display the Y-axis value in the tooltip
                                              ),
                                            ),
                                            title: ChartTitle(
                                                text:
                                                    "Average Windspeed",
                                                textStyle:
                                                    textStyles.lato_bold()),
                                            primaryXAxis: CategoryAxis(
                                              labelStyle:
                                                  textStyles.lato_regular(),
                                            ),
                                            primaryYAxis: NumericAxis(
                                              labelStyle:
                                                  textStyles.lato_regular(),
                                              numberFormat:
                                                  NumberFormat.compact(),
                                            ),
                                            series: [
                                              ColumnSeries<Municipality, String>(
                                                animationDuration: 300,
                                                dataSource: municipalities,
                                                xValueMapper:
                                                    (Municipality mun, _) =>
                                                        mun.munName,
                                                yValueMapper:
                                                    (Municipality mun, _) =>
                                                        mun.avgWs,
                                                pointColorMapper:
                                                    (Municipality mun, _) =>
                                                        mun.colorMarker,
                                              ),
                                            ],
                                          );
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      })
                                      ;
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              })
                          ,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Container(
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
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
                        child: (selectedOption=='Provincial')
                          
                          ?
                          FutureBuilder(
                              future: FirestoreService2().futureAllProvinces(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final List<Province> provinces =
                                      snapshot.data!;

                                  return (selectedGraphOption=='Highest')
                                  ?
                                  FutureBuilder(
                                      future: FirestoreService2()
                                          .setProvincesHighestAtts(provinces),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final provinces = snapshot.data!;
                                          return SfCartesianChart(
                                            trackballBehavior:
                                                TrackballBehavior(
                                              activationMode:
                                                  ActivationMode.singleTap,
                                              enable: true,
                                              tooltipSettings:
                                                  InteractiveTooltip(
                                                format:
                                                    'point.y', // Display the Y-axis value in the tooltip
                                              ),
                                            ),
                                            title: ChartTitle(
                                                text:
                                                    "Highest Recorded Rainfall (24H)",
                                                textStyle:
                                                    textStyles.lato_bold()),
                                            primaryXAxis: CategoryAxis(
                                              labelStyle:
                                                  textStyles.lato_regular(),
                                            ),
                                            primaryYAxis: NumericAxis(
                                              labelStyle:
                                                  textStyles.lato_regular(),
                                              numberFormat:
                                                  NumberFormat.compact(),
                                            ),
                                            series: [
                                              ColumnSeries<Province, String>(
                                                animationDuration: 300,
                                                dataSource: provinces,
                                                xValueMapper:
                                                    (Province province, _) =>
                                                        province.provName,
                                                yValueMapper:
                                                    (Province province, _) =>
                                                        province.highestRf24,
                                                pointColorMapper:
                                                    (Province prov, _) =>
                                                        prov.colorMarker,
                                              ),
                                            ],
                                          );
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      })
                                      :
                                      FutureBuilder(
                                      future: FirestoreService2()
                                          .setProvincesAvgAtts(provinces),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final provinces = snapshot.data!;
                                          return SfCartesianChart(
                                            trackballBehavior:
                                                TrackballBehavior(
                                              activationMode:
                                                  ActivationMode.singleTap,
                                              enable: true,
                                              tooltipSettings:
                                                  InteractiveTooltip(
                                                format:
                                                    'point.y', // Display the Y-axis value in the tooltip
                                              ),
                                            ),
                                            title: ChartTitle(
                                                text:
                                                    "Average Rainfall (24H)",
                                                textStyle:
                                                    textStyles.lato_bold()),
                                            primaryXAxis: CategoryAxis(
                                              labelStyle:
                                                  textStyles.lato_regular(),
                                            ),
                                            primaryYAxis: NumericAxis(
                                              labelStyle:
                                                  textStyles.lato_regular(),
                                              numberFormat:
                                                  NumberFormat.compact(),
                                            ),
                                            series: [
                                              ColumnSeries<Province, String>(
                                                animationDuration: 300,
                                                dataSource: provinces,
                                                xValueMapper:
                                                    (Province province, _) =>
                                                        province.provName,
                                                yValueMapper:
                                                    (Province province, _) =>
                                                        province.avgRf24,
                                                pointColorMapper:
                                                    (Province prov, _) =>
                                                        prov.colorMarker,
                                              ),
                                            ],
                                          );
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      })
                                  ;
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              })
                              :
                              FutureBuilder(
                              future: FirestoreService2().futureAllMunicipality(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final List<Municipality> municipalities =
                                      snapshot.data!;

                                  return (selectedGraphOption=='Highest')
                                  ?
                                  FutureBuilder(
                                      future: FirestoreService2()
                                          .setMunicipalitiesHighestAtts(municipalities),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final municipalities = snapshot.data!;
                                          return SfCartesianChart(
                                            trackballBehavior:
                                                TrackballBehavior(
                                              activationMode:
                                                  ActivationMode.singleTap,
                                              enable: true,
                                              tooltipSettings:
                                                  InteractiveTooltip(
                                                format:
                                                    'point.y', // Display the Y-axis value in the tooltip
                                              ),
                                            ),
                                            title: ChartTitle(
                                                text:
                                                    "Highest Recorded Rainfall (24H)",
                                                textStyle:
                                                    textStyles.lato_bold()),
                                            primaryXAxis: CategoryAxis(
                                              labelStyle:
                                                  textStyles.lato_regular(),
                                            ),
                                            primaryYAxis: NumericAxis(
                                              labelStyle:
                                                  textStyles.lato_regular(),
                                              numberFormat:
                                                  NumberFormat.compact(),
                                            ),
                                            series: [
                                              ColumnSeries<Municipality, String>(
                                                animationDuration: 300,
                                                dataSource: municipalities,
                                                xValueMapper:
                                                    (Municipality mun, _) =>
                                                        mun.munName,
                                                yValueMapper:
                                                    (Municipality mun, _) =>
                                                        mun.highestRf24,
                                                pointColorMapper:
                                                    (Municipality mun, _) =>
                                                        mun.colorMarker,
                                              ),
                                            ],
                                          );
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      })
                                      :
                                      FutureBuilder(
                                      future: FirestoreService2()
                                          .setMunicipalitiesAvgAtts(municipalities),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final municipalities = snapshot.data!;
                                          return SfCartesianChart(
                                            trackballBehavior:
                                                TrackballBehavior(
                                              activationMode:
                                                  ActivationMode.singleTap,
                                              enable: true,
                                              tooltipSettings:
                                                  InteractiveTooltip(
                                                format:
                                                    'point.y', // Display the Y-axis value in the tooltip
                                              ),
                                            ),
                                            title: ChartTitle(
                                                text:
                                                    "Average Recorded Rainfall (24H)",
                                                textStyle:
                                                    textStyles.lato_bold()),
                                            primaryXAxis: CategoryAxis(
                                              labelStyle:
                                                  textStyles.lato_regular(),
                                            ),
                                            primaryYAxis: NumericAxis(
                                              labelStyle:
                                                  textStyles.lato_regular(),
                                              numberFormat:
                                                  NumberFormat.compact(),
                                            ),
                                            series: [
                                              ColumnSeries<Municipality, String>(
                                                animationDuration: 300,
                                                dataSource: municipalities,
                                                xValueMapper:
                                                    (Municipality mun, _) =>
                                                        mun.munName,
                                                yValueMapper:
                                                    (Municipality mun, _) =>
                                                        mun.avgRf24,
                                                pointColorMapper:
                                                    (Municipality mun, _) =>
                                                        mun.colorMarker,
                                              ),
                                            ],
                                          );
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      })
                                  ;
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              }),
                      )
                      ),
                      Expanded(
                          child: Container(
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
                        child: (selectedOption=='Provincial')
                          
                          ?
                          FutureBuilder(
                              future: FirestoreService2().futureAllProvinces(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final List<Province> provinces =
                                      snapshot.data!;

                                  return (selectedGraphOption=='Highest')
                                  ?
                                  FutureBuilder(
                                      future: FirestoreService2()
                                          .setProvincesHighestAtts(provinces),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final provinces = snapshot.data!;
                                          return SfCartesianChart(
                                            trackballBehavior:
                                                TrackballBehavior(
                                              activationMode:
                                                  ActivationMode.singleTap,
                                              enable: true,
                                              tooltipSettings:
                                                  InteractiveTooltip(
                                                format:
                                                    'point.y', // Display the Y-axis value in the tooltip
                                              ),
                                            ),
                                            title: ChartTitle(
                                                text:
                                                    "Highest Recorded Rainfall (6H)",
                                                textStyle:
                                                    textStyles.lato_bold()),
                                            primaryXAxis: CategoryAxis(
                                              labelStyle:
                                                  textStyles.lato_regular(),
                                            ),
                                            primaryYAxis: NumericAxis(
                                              labelStyle:
                                                  textStyles.lato_regular(),
                                              numberFormat:
                                                  NumberFormat.compact(),
                                            ),
                                            series: [
                                              ColumnSeries<Province, String>(
                                                animationDuration: 300,
                                                dataSource: provinces,
                                                xValueMapper:
                                                    (Province province, _) =>
                                                        province.provName,
                                                yValueMapper:
                                                    (Province province, _) =>
                                                        province.highestRf6,
                                                pointColorMapper:
                                                    (Province prov, _) =>
                                                        prov.colorMarker,
                                              ),
                                            ],
                                          );
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      })
                                      :
                                      FutureBuilder(
                                      future: FirestoreService2()
                                          .setProvincesAvgAtts(provinces),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final provinces = snapshot.data!;
                                          return SfCartesianChart(
                                            trackballBehavior:
                                                TrackballBehavior(
                                              activationMode:
                                                  ActivationMode.singleTap,
                                              enable: true,
                                              tooltipSettings:
                                                  InteractiveTooltip(
                                                format:
                                                    'point.y', // Display the Y-axis value in the tooltip
                                              ),
                                            ),
                                            title: ChartTitle(
                                                text:
                                                    "Average Rainfall (6H)",
                                                textStyle:
                                                    textStyles.lato_bold()),
                                            primaryXAxis: CategoryAxis(
                                              labelStyle:
                                                  textStyles.lato_regular(),
                                            ),
                                            primaryYAxis: NumericAxis(
                                              labelStyle:
                                                  textStyles.lato_regular(),
                                              numberFormat:
                                                  NumberFormat.compact(),
                                            ),
                                            series: [
                                              ColumnSeries<Province, String>(
                                                animationDuration: 300,
                                                dataSource: provinces,
                                                xValueMapper:
                                                    (Province province, _) =>
                                                        province.provName,
                                                yValueMapper:
                                                    (Province province, _) =>
                                                        province.avgRf6,
                                                pointColorMapper:
                                                    (Province prov, _) =>
                                                        prov.colorMarker,
                                              ),
                                            ],
                                          );
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      })
                                  ;
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              })
                              :
                              FutureBuilder(
                              future: FirestoreService2().futureAllMunicipality(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final List<Municipality> municipalities =
                                      snapshot.data!;

                                  return (selectedGraphOption=='Highest')
                                  ?
                                  FutureBuilder(
                                      future: FirestoreService2()
                                          .setMunicipalitiesHighestAtts(municipalities),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final municipalities = snapshot.data!;
                                          return SfCartesianChart(
                                            trackballBehavior:
                                                TrackballBehavior(
                                              activationMode:
                                                  ActivationMode.singleTap,
                                              enable: true,
                                              tooltipSettings:
                                                  InteractiveTooltip(
                                                format:
                                                    'point.y', // Display the Y-axis value in the tooltip
                                              ),
                                            ),
                                            title: ChartTitle(
                                                text:
                                                    "Highest Recorded Rainfall (6H)",
                                                textStyle:
                                                    textStyles.lato_bold()),
                                            primaryXAxis: CategoryAxis(
                                              labelStyle:
                                                  textStyles.lato_regular(),
                                            ),
                                            primaryYAxis: NumericAxis(
                                              labelStyle:
                                                  textStyles.lato_regular(),
                                              numberFormat:
                                                  NumberFormat.compact(),
                                            ),
                                            series: [
                                              ColumnSeries<Municipality, String>(
                                                animationDuration: 300,
                                                dataSource: municipalities,
                                                xValueMapper:
                                                    (Municipality mun, _) =>
                                                        mun.munName,
                                                yValueMapper:
                                                    (Municipality mun, _) =>
                                                        mun.highestRf6,
                                                pointColorMapper:
                                                    (Municipality mun, _) =>
                                                        mun.colorMarker,
                                              ),
                                            ],
                                          );
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      })
                                      :
                                      FutureBuilder(
                                      future: FirestoreService2()
                                          .setMunicipalitiesAvgAtts(municipalities),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final municipalities = snapshot.data!;
                                          return SfCartesianChart(
                                            trackballBehavior:
                                                TrackballBehavior(
                                              activationMode:
                                                  ActivationMode.singleTap,
                                              enable: true,
                                              tooltipSettings:
                                                  InteractiveTooltip(
                                                format:
                                                    'point.y', // Display the Y-axis value in the tooltip
                                              ),
                                            ),
                                            title: ChartTitle(
                                                text:
                                                    "Average Rainfall (6H)",
                                                textStyle:
                                                    textStyles.lato_bold()),
                                            primaryXAxis: CategoryAxis(
                                              labelStyle:
                                                  textStyles.lato_regular(),
                                            ),
                                            primaryYAxis: NumericAxis(
                                              labelStyle:
                                                  textStyles.lato_regular(),
                                              numberFormat:
                                                  NumberFormat.compact(),
                                            ),
                                            series: [
                                              ColumnSeries<Municipality, String>(
                                                animationDuration: 300,
                                                dataSource: municipalities,
                                                xValueMapper:
                                                    (Municipality mun, _) =>
                                                        mun.munName,
                                                yValueMapper:
                                                    (Municipality mun, _) =>
                                                        mun.avgRf24,
                                                pointColorMapper:
                                                    (Municipality mun, _) =>
                                                        mun.colorMarker,
                                              ),
                                            ],
                                          );
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      })
                                  ;
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              }),
                      )
                      )
                    ],
                  ),
                ),
              )
            ]),
          ),
        ),
      ],
    );
  }

  // Future<void> setHighestWs(Province prov) async {
  //   List<Day> allDays =
  //       await FirestoreService2().getAllDaysBasedOnProvinceID(prov.id);
  //   Day dayWithHighestWs = allDays.reduce((currentMax, day) {
  //     return day.windSpeed! > currentMax.windSpeed! ? day : currentMax;
  //   });
  //   prov.highestWs = dayWithHighestWs.windSpeed;
  // }
}
