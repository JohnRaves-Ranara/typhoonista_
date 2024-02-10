import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';

class typhoon_forecast extends StatefulWidget {
  const typhoon_forecast({super.key});

  @override
  State<typhoon_forecast> createState() => _typhoon_forecastState();
}

class _typhoon_forecastState extends State<typhoon_forecast> {
  late List<Loc> locsData;
  List<Loc> selectedLocs = [];

  @override
  void initState() {
    super.initState();
    locsData = getLocs();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 55,
      child: Row(children: [
        Expanded(
          flex: 80,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: Offset(0, 3),
                    blurRadius: 2,
                    spreadRadius: 1,
                  ),
                ]),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Typhoon Hevabi',
                      style: textStyles.lato_bold(fontSize: 22),
                    ),
                    Text(
                      '6-Day Rice Crop Damage Forecast',
                      style: textStyles.lato_bold(fontSize: 22),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: SfCartesianChart(
                    trackballBehavior: TrackballBehavior(enable: true, activationMode: ActivationMode.singleTap),
                    series: (selectedLocs.isEmpty)
                        ? locsData
                            .map((loc) => AreaSeries<LocationDayDamage, String>(
                                  animationDuration: 200,
                                  dataSource: loc.dayDamages,
                                  color: loc.color,
                                  xValueMapper: (LocationDayDamage data, _) =>
                                      data.dayNumber,
                                  yValueMapper: (LocationDayDamage data, _) =>
                                      data.damageCost,
                                ))
                            .toList()
                        : selectedLocs
                            .map((loc) => AreaSeries<LocationDayDamage, String>(
                                  animationDuration: 200,
                                  dataSource: loc.dayDamages,
                                  color: loc.color,
                                  xValueMapper: (LocationDayDamage data, _) =>
                                      data.dayNumber,
                                  yValueMapper: (LocationDayDamage data, _) =>
                                      data.damageCost,
                                ))
                            .toList(),
                    primaryXAxis: CategoryAxis(
                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                      labelPlacement: LabelPlacement.onTicks,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 20,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: Offset(0, 3),
                    blurRadius: 2,
                    spreadRadius: 1,
                  ),
                ]),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Legend',
                      style: textStyles.lato_bold(fontSize: 18),
                    ),
                    Text(
                      'Filter',
                      style: textStyles.lato_bold(fontSize: 18),
                    ),
                  ],
                ),
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: locsData
                          .map(
                            (d) => (d.isSelected == false)
                                ? Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: GestureDetector(
                                        onTap: (() {
                                          setState(() {
                                            addSelectedLoc(d);
                                            d.isSelected = !d.isSelected;
                                          });
                                        }),
                                        child: Icon(Icons.check_circle_outline)),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: GestureDetector(
                                        onTap: (() {
                                          setState(() {
                                            removeSelectedLoc(d);
                                            d.isSelected = !d.isSelected;
                                          });
                                        }),
                                        child: Icon(Icons.check_circle)),
                                  ),
                          )
                          .toList(),
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: locsData
                            .map(
                              (loc) => Row(
                                children: [
                                  CircleAvatar(
                                    radius: 10,
                                    backgroundColor: loc.color,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10.0),
                                    child: Text(
                                      loc.locName!,
                                      style: textStyles.lato_light(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList()),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: locsData
                          .map(
                            (d) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                d.totalDamage.toString(),
                                style: textStyles.lato_light(fontSize: 16),
                              ),
                            ),
                          )
                          .toList(),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  void addSelectedLoc(Loc selectedLoc) {
    setState(() {
      if (!selectedLocs.contains(selectedLoc)) {
        selectedLocs.add(selectedLoc);
      }
    });
  }

  void removeSelectedLoc(Loc selectedLoc) {
    setState(() {
      if (selectedLocs.contains(selectedLoc)) {
        selectedLocs.remove(selectedLoc);
      }
    });
  }

  List<Loc> getLocs() {
    final List<Loc> locs = [
      Loc([
        LocationDayDamage("Day 1", 3000000),
        LocationDayDamage("Day 2", 1276532),
        LocationDayDamage("Day 3", 3716239),
        LocationDayDamage("Day 4", 3287126),
        LocationDayDamage("Day 5", 2652735),
        LocationDayDamage("Day 6", 4213823),
      ], 1234567, Colors.amber.withOpacity(0.3), 'Aklan'),
      Loc([
        LocationDayDamage("Day 1", 4371263),
        LocationDayDamage("Day 2", 1653723),
        LocationDayDamage("Day 3", 5564736),
        LocationDayDamage("Day 4", 2256354),
        LocationDayDamage("Day 5", 3648263),
        LocationDayDamage("Day 6", 5627632),
      ], 7654321, Colors.blue.withOpacity(0.3), 'Hevabi'),
      Loc([
        LocationDayDamage("Day 1", 3283726),
        LocationDayDamage("Day 2", 5674823),
        LocationDayDamage("Day 3", 1257362),
        LocationDayDamage("Day 4", 4352412),
        LocationDayDamage("Day 5", 2126357),
        LocationDayDamage("Day 6", 3462527),
      ], 2341232, Colors.green.withOpacity(0.3), 'Bruh'),
    ];
    return locs;
  }
}

class Loc {
  List<LocationDayDamage>? dayDamages;
  double? totalDamage;
  Color? color;
  String? locName;
  bool isSelected = false;
  Loc(this.dayDamages, this.totalDamage, this.color, this.locName);
}

class LocationDayDamage {
  String? dayNumber;
  double? damageCost;
  LocationDayDamage(this.dayNumber, this.damageCost);
}
