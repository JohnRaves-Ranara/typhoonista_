// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:typhoonista_thesis/HOMEPAGES2/entities2/new/Typhoon.dart';
// import 'package:typhoonista_thesis/assets/themes/textStyles.dart';
// import 'package:typhoonista_thesis/HOMEPAGES2/entities2/new/Owner.dart';
// import 'package:typhoonista_thesis/HOMEPAGES2/entities2/new/Day.dart';
// import 'package:typhoonista_thesis/HOMEPAGES2/entities2/new/Province.dart';
// import 'package:typhoonista_thesis/HOMEPAGES2/entities2/new/Municipality.dart';
// import 'package:typhoonista_thesis/HOMEPAGES2/services2/FirestoreService2.dart';

// class test5 extends StatefulWidget {
//   const test5({super.key});

//   @override
//   State<test5> createState() => _test5State();
// }

// class _test5State extends State<test5> {
//   // late List<Loc> locsData;
//   List<Day> selectedLocs = [];

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           StreamBuilder<Typhoon>(
//             stream: FirestoreService2().streamOngoingTyphoon(),
//             builder: (context, snapshot){
//               if(snapshot.hasData){
//                 Typhoon ongoingTyphoon = snapshot.data!;
//                 return StreamBuilder<List<Province>>(
//                     stream: FirestoreService2().streamProvinces(ongoingTyphoon.id),
//                     builder: (context,snapshot){
//                       if(snapshot.hasData){
//                         List<Province> provinces = snapshot.data!;
//                         return Column(
//                           children: provinces.map((province){
//                             return StreamBuilder<List<Municipality>>(
//                               stream: FirestoreService2().streamMunicipalities(ongoingTyphoon.id, province.id),
//                               builder: (context,snapshot){
//                                 if(snapshot.hasData){
//                                   List<Municipality> municipalities = snapshot.data!;
//                                   return Column(
//                                     children: municipalities.map((municipality){
//                                       return StreamBuilder<List<Owner>>(
//                                         stream: FirestoreService2().streamOwners(ongoingTyphoon.id, province.id, municipality.id),
//                                         builder: (context,snapshot){
//                                           if(snapshot.hasData){
//                                             List<Owner> owners = snapshot.data!;
//                                             return Column(
//                                               children: owners.map((owner){
//                                                 return StreamBuilder<List<Day>>(
//                                                   stream: FirestoreService2().streamDays(ongoingTyphoon.id, province.id, municipality.id, owner.id),
//                                                   builder: (context,snapshot){
//                                                     if(snapshot.hasData){
                                                      
//                                                     }else{
//                                                       return Center(child: Text("no days"),);
//                                                     }
//                                                   });
//                                               }).toList(),
//                                             );
//                                           }else{
//                                             return Center(child: Text("no owners"),);
//                                           }
//                                         }
//                                         );
//                                     }).toList(),
//                                   );
//                                 }else{
//                                   return Center(child: Text("no municipalities"),);
//                                 }
//                               }
//                               );
//                           }).toList(),
//                         );
//                       }else{
//                         return Center(child: Text("no provinces"),);
//                       }
//                     },
//                   );
//               }else{
//                 return Center(child: Text("no ongoing typhoon"),);
//               }
//             }
//             )
//         ],
//       ),
//     );
//   }

//   void addSelectedLoc(Day selectedLoc) {
//     setState(() {
//       if (!selectedLocs.contains(selectedLoc)) {
//         selectedLocs.add(selectedLoc);
//       }
//     });
//   }

//   void removeSelectedLoc(Day selectedLoc) {
//     setState(() {
//       if (selectedLocs.contains(selectedLoc)) {
//         selectedLocs.remove(selectedLoc);
//       }
//     });
//   }

//   List<Loc> getLocs() {
//     final List<Loc> locs = [
//       Loc([
//         LocationDayDamage("Day 1", 3000000),
//         LocationDayDamage("Day 2", 1276532),
//         LocationDayDamage("Day 3", 3716239),
//         LocationDayDamage("Day 4", 3287126),
//         LocationDayDamage("Day 5", 2652735),
//         LocationDayDamage("Day 6", 4213823),
//       ], 1234567, Colors.amber.withOpacity(0.3), 'Aklan'),
//       Loc([
//         LocationDayDamage("Day 1", 4371263),
//         LocationDayDamage("Day 2", 1653723),
//         LocationDayDamage("Day 3", 5564736),
//         LocationDayDamage("Day 4", 2256354),
//         LocationDayDamage("Day 5", 3648263),
//         LocationDayDamage("Day 6", 5627632),
//       ], 7654321, Colors.blue.withOpacity(0.3), 'Hevabi'),
//       Loc([
//         LocationDayDamage("Day 1", 3283726),
//         LocationDayDamage("Day 2", 5674823),
//         LocationDayDamage("Day 3", 1257362),
//         LocationDayDamage("Day 4", 4352412),
//         LocationDayDamage("Day 5", 2126357),
//         LocationDayDamage("Day 6", 3462527),
//       ], 2341232, Colors.green.withOpacity(0.3), 'Bruh'),
//     ];
//     return locs;
//   }

//   Color getRandomColor(){
//     int red = Random().nextInt(256);
//     int green = Random().nextInt(256);
//     int blue = Random().nextInt(256);
//     // Create a new random color
//     Color randomColor = Color.fromARGB(255, red, green, blue).withOpacity(0.3);
//     return randomColor;
//   }
// }

// class Loc {
//   List<LocationDayDamage>? dayDamages;
//   double? totalDamage;
//   Color? color;
//   String? locName;
//   bool isSelected = false;
//   Loc(this.dayDamages, this.totalDamage, this.color, this.locName);
// }

// class LocationDayDamage {
//   String? dayNumber;
//   double? damageCost;
//   LocationDayDamage(this.dayNumber, this.damageCost);
// }

// void main(){
//   print(DateTime.now().toString());
// }
