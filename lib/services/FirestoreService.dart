import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:typhoonista_thesis/services/estimatorModel.dart';

class FirestoreService{

  CollectionReference typhColRef = FirebaseFirestore.instance.collection('typhoons');

  // void addTyphoon(String typhName, double windspeed, double rainfall, String location) async{
    
  //   DocumentReference docRef = typhColRef.doc();
  //   final id = docRef.id;
  //   final double dmgcost = estimatorModel().getEstimation();
  //   final typhoon = {
  //     "id" : id,
  //     "typhoonName" : typhName,
  //     "peakWindSpeed" : peakWindspeed,
  //     "peakRainfall" : peakRainfall,
  //     "location" : location,
  //     "totalDamage" : dmgcost
  //   };

  //   addDay(id, typhName, )
  //   await docRef.set(typhoon);
    
  // }

  void addDay({String? typhoonId, required String typhoonName, required double windSpeed, required double rainfall, required String location, required bool isFirstDay})async {
    
    final double damageCost = estimatorModel().getEstimation();
    if(isFirstDay){

    //line below creates a new typhoon document inside typhoons collection
    DocumentReference typhoonDocRef = typhColRef.doc();
    final _typhoonId = typhoonDocRef.id;
    final typhoon = {
      "id" : _typhoonId,
      "typhoonName" : typhoonName,
      "peakWindspeed" : windSpeed,
      "peakRainfall" : rainfall,
      "location" : location,
      "totalDamage" : damageCost
    };

    await typhoonDocRef.set(typhoon);

    //create new days collection inside newly created typhoons document
    CollectionReference daysColRef = typhColRef.doc(_typhoonId).collection("days");
    DocumentReference daysDocRef = daysColRef.doc();
    final _dayId = daysDocRef.id;
    final day = {
      "id" : _dayId,
      "typhoonID" : _typhoonId,
      "typhoonName" : typhoonName,
      "windSpeed" : windSpeed,
      "rainfall" : rainfall,
      "location" : location,
      "day" : 1,
      "damageCost" : damageCost
    };
    await daysDocRef.set(day);
    }
  }
}