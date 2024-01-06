import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/entities/TyphoonDay.dart';
import 'package:typhoonista_thesis/services/FirestoreService.dart';

class idk extends StatefulWidget {
  const idk({super.key});

  @override
  State<idk> createState() => _idkState();
}

class _idkState extends State<idk> {
  @override
  Widget build(BuildContext context) {
    final List<DateTime> dates = [DateTime.parse('2024-01-07 01:15:16.025'), DateTime.parse('2024-01-05 22:05:11.212')];

    final DateTime latest = dates.reduce((currentRecent, dateTime) => dateTime.isAfter(currentRecent) ? dateTime : currentRecent );
    
    return Scaffold(
      body: Center(
        child: FutureBuilder<TyphoonDay>(
          future: FirestoreService().getLastAddedDay(),
          builder: (context, snapshot) {
            
            if(snapshot.hasData){
              TyphoonDay lastAddedDay = snapshot.data!;
              return Container(
              height: 600,
              width: 800,
              color: Colors.teal,
              child: Text(lastAddedDay.damageCost.toString()),
            );
            }
            else{
              return Text("EMPTY");
            }
          }
        ),
        // child: Text(latest.toString()),
      ),
    );
  }
}
