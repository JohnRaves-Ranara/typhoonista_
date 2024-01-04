import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/entities/Typhoon.dart';
import 'package:typhoonista_thesis/services/FirestoreService.dart';
import 'package:typhoonista_thesis/entities/TyphoonDay.dart';

class idk extends StatefulWidget {
  const idk({super.key});

  @override
  State<idk> createState() => _idkState();
}

class _idkState extends State<idk> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            child: Center(
          child:
          StreamBuilder<TyphoonDay>(
            stream: FirestoreService().streamRecentEstimation(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                TyphoonDay recentEstimation = snapshot.data!;
                return Text(
                  recentEstimation.typhoonName
                );
              }
              else{
                return Text("WALAY DATA");
              }
            },
          ),
          // StreamBuilder<List<TyphoonDay>>(
          //   stream: FirestoreService().streamAllDays(),
          //   builder: (context, snapshot) {
          //     if (snapshot.hasData) {
          //       List<TyphoonDay> allDays = snapshot.data!;
          //       return ListView(
          //         children: allDays
          //             .map((day) => ListTile(
          //                   title: Text(day.damageCost.toString()),
          //                 ))
          //             .toList(),
          //       );
          //     }
          //     else{
          //       return Text("WALAY DATA");
          //     }
          //   },
          // ),
          // StreamBuilder<List<Typhoon>>(
          //   stream: FirestoreService().streamAllTyphoons(),
          //   builder: (context, snapshot) {
          //     if (snapshot.hasData) {
          //       List<Typhoon> allDays = snapshot.data!;
          //       return ListView(
          //         children: allDays
          //             .map((day) => ListTile(
          //                   title: Text(day.totalDamageCost.toString()),
          //                 ))
          //             .toList(),
          //       );
          //     }
          //     else{
          //       return Text("WALAY DATA");
          //     }
          //   },
          // ),
        )),
      ),
    );
  }
}
