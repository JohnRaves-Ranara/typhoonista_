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
    selectedOption = options[1];
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
          child: (selectedOption == 'Municipal')
              ? StreamBuilder<Typhoon>(
                stream: FirestoreService2().streamOngoingTyphoon(),
                builder: (context,snapshot){
                  
                  if(snapshot.hasData){
                    print("YES NAAY ONGOING NGA TYPHOON DARA OH");
                    print(snapshot.data!.typhoonName);
                    return StreamBuilder<List<Municipality>>(
                    stream: FirestoreService2().streamAllMunicipalities(snapshot.data!),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Municipality> municipalities = snapshot.data!;
                        List<double> damagePercentages =
                            municipalConvertToPercentages(municipalities);
                        for (int i = 0; i < municipalities.length; i++) {
                          municipalities[i].damageCostInPercentage =
                              double.parse(damagePercentages[i].toStringAsFixed(0));
                        }
                        return Row(children: [
                          Expanded(
                            flex: 60,
                            child: Container(
                              child: SfCircularChart(
                                tooltipBehavior: TooltipBehavior(
                                    enable: true,
                                    activationMode: ActivationMode.longPress,
                                    animationDuration: 100),
                                series: <CircularSeries>[
                                  DoughnutSeries<Municipality, String>(
                                    dataLabelSettings: DataLabelSettings(
                                      textStyle:
                                          textStyles.lato_regular(fontSize: 12),
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
                                    dataLabelMapper: (Municipality data, _) =>
                                        "₱ ${NumberFormat('#,##0.00', 'en_US').format(data.totalDamageCost)}",
                                    pointColorMapper: (Municipality data, _) =>
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
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        'Total Damage Cost\nto Rice Crops',
                                        textAlign: TextAlign.center,
                                        style: textStyles.lato_bold(fontSize: 18),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: 30,
                                        width: 130,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color:
                                                    Colors.black.withOpacity(0.2),
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
                                    ],
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Expanded(
                                    child: ListView(
                                      children: municipalities
                                          .map((municipality) => Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 7),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 8,
                                                      backgroundColor:
                                                          municipality
                                                              .colorMarker,
                                                    ),
                                                    SizedBox(
                                                      width: 11,
                                                    ),
                                                    Text(
                                                      municipality.munName,
                                                      textAlign: TextAlign.start,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          textStyles.lato_light(
                                                              fontSize: 14),
                                                    ),
                                                    Spacer(),
                                                    Text(
                                                      '${municipality.damageCostInPercentage}%',
                                                      style:
                                                          textStyles.lato_light(
                                                              fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                              ))
                                          .toList(),
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
                  );
                  }else{
                    return Center(child: Text("No data"),);
                  }
                },
              )
              : StreamBuilder<Typhoon>(
                stream: FirestoreService2().streamOngoingTyphoon(),
                builder: (context,snapshot){
                  if(snapshot.hasData){
                    return StreamBuilder<List<Province>>(
                    stream: FirestoreService2().streamAllProvinces(snapshot.data!),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && !snapshot.data!.isEmpty) {
                        List<Province> provinces = snapshot.data!;
                        print(provinces.isEmpty);
                        print("XAXAXAXA ${provinces}");
                        List<double> damagePercentages =
                            provincialConvertToPercentages(provinces);
                        for (int i = 0; i < provinces.length; i++) {
                          provinces[i].damageCostInPercentage =
                              double.parse(damagePercentages[i].toStringAsFixed(0));
                        }
                        return Row(children: [
                          Expanded(
                            flex: 60,
                            child: Container(
                              child: SfCircularChart(
                                tooltipBehavior: TooltipBehavior(
                                    enable: true,
                                    activationMode: ActivationMode.longPress,
                                    animationDuration: 100),
                                series: <CircularSeries>[
                                  DoughnutSeries<Province, String>(
                                    dataLabelSettings: DataLabelSettings(
                                      textStyle:
                                          textStyles.lato_regular(fontSize: 12),
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
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Total Damage Cost\nto Rice Crops',
                                    textAlign: TextAlign.center,
                                    style: textStyles.lato_bold(fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height: 30,
                                    width: 130,
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
                                        iconStyleData:
                                            IconStyleData(iconSize: 20),
                                        items: options
                                            .map(
                                                (opt) => DropdownMenuItem<String>(
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
                                    height: 25,
                                  ),
                                  Expanded(
                                    child: ListView(
                                      children: provinces
                                          .map((provinces) => Container(
                                                padding: EdgeInsets.symmetric(),
                                                margin: const EdgeInsets.only(
                                                    bottom: 7),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 8,
                                                      backgroundColor:
                                                          provinces.colorMarker,
                                                    ),
                                                    SizedBox(
                                                      width: 11,
                                                    ),
                                                    Text(
                                                      provinces.provName,
                                                      textAlign: TextAlign.start,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          textStyles.lato_light(
                                                              fontSize: 14),
                                                    ),
                                                    Spacer(),
                                                    Text(
                                                      '${provinces.damageCostInPercentage}%',
                                                      style:
                                                          textStyles.lato_light(
                                                              fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ]);
                      } else {
                        return Center(child: Text("No data.", style: textStyles.lato_bold(fontSize: 22),),);
                      }
                    },
                  );
                  }else{
                    return Center(child: Text("No data.", style: textStyles.lato_bold(fontSize: 22),),);
                  }
                }
                
                 
              ),
        ));
  }

  List<double> municipalConvertToPercentages(List<Municipality> municipalities) {
    double dmgCosts = municipalities.map((mun) => mun.totalDamageCost).fold(0, (a, b) => a + b);
    List<double> percentages = municipalities.map((mun) => (mun.totalDamageCost / dmgCosts) * 100).toList();
    return percentages;
  }

  List<double> provincialConvertToPercentages(List<Province> provinces) {
    double dmgCosts = provinces.map((prov) => prov.totalDamageCost).fold(0, (a, b) => a + b);
    List<double> percentages = provinces.map((prov) => (prov.totalDamageCost / dmgCosts) * 100).toList();
    return percentages;
  }
}
