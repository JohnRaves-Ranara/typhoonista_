// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_maps/maps.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:vector_map/vector_map.dart';

// class test5 extends StatefulWidget {
//   const test5({super.key});

//   @override
//   State<test5> createState() => _test5State();
// }

// class _test5State extends State<test5> {
//   late MapShapeSource _shapeSource;
//   // VectorMapController? _controller;
//   @override
//   void initState() {
//     super.initState();
//     _shapeSource = const MapShapeSource.asset(
//       // 'lib/philippines-with-regions_ (2).geojson',
//       'lib/services/MuniCities.minimal.json',

//       shapeDataField: "NAME_2",
//     );

//     print(_shapeSource);

//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Container(
//             color: Colors.blue,
//             child:

//             SfMaps(
//               layers: [
//                 MapShapeLayer(
//                   source: _shapeSource,
//                   showDataLabels: true,
//                   dataLabelSettings: const MapDataLabelSettings(
//                     overflowMode: MapLabelOverflow.hide,
//                     textStyle: TextStyle(color: Colors.black, fontSize: 9),
//                   ),
//                 )
//               ],
//             ),

//           )
//           // Text("hello world")
//         ],
//       ),
//     );
//   }
// }

import '../entities2/new/Day.dart';

void main() {
  List<Day> alldays = [
    Day(dayNum: 1, damageCost: 12),
    Day(dayNum: 4, damageCost: 34),
    Day(dayNum: 2, damageCost: 43),
    Day(dayNum: 4, damageCost: 67),
    Day(dayNum: 3,damageCost: 22),
    Day(dayNum: 1,damageCost: 87),
    Day(dayNum: 2,damageCost: 45),
    Day(dayNum: 4,damageCost: 23),
    Day(dayNum: 1,damageCost: 87),
    Day(dayNum: 3,damageCost: 23),
    Day(dayNum: 3,damageCost: 99),
    Day(dayNum: 2,damageCost: 45),
    Day(dayNum: 5, damageCost: 31),
    Day(dayNum: 5, damageCost: 11),
    Day(dayNum: 5, damageCost: 76),
  ];

  double getAverageDamagePerDay(List<Day> alldays) {
    Map<int, List<Day>> groupeddays = {};

    for (Day day in alldays) {
      groupeddays.putIfAbsent(day.dayNum!, () => []);
      groupeddays[day.dayNum]!.add(day);
    }

    List<double> totalOfAllDaysEachGroup = [];
    groupeddays.forEach((key, value) { 
      double total = 0;
      for(Day day in value){
        total += day.damageCost!;
      }
      totalOfAllDaysEachGroup.add(total);
    });
    print(totalOfAllDaysEachGroup);
    double total = 0;
    for(double num in totalOfAllDaysEachGroup){
      total += num;
    }

    return total / groupeddays.length;
  }

  double averageDamagePerDay = getAverageDamagePerDay(alldays);

  print(averageDamagePerDay);

  // groupeddays.forEach((key, value) {
  //   print("Group $key: ${value}");
  // });

  // double averageOfAll(Map<int, List<Day>> groupedPersons){
    
  // }
  


}
