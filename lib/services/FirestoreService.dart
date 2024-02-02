// import 'dart:ffi';
import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:typhoonista_thesis/entities/DamageCostBar.dart';
import 'package:typhoonista_thesis/entities/Location.dart';
import 'package:typhoonista_thesis/entities/Location_.dart';
import 'package:typhoonista_thesis/entities/Typhoon.dart';
import 'package:typhoonista_thesis/entities/TyphoonDay.dart';
import 'package:typhoonista_thesis/services/estimatorModel.dart';

class FirestoreService {
  //LINE BELOW IS DUMMY ONLY!!
  DocumentReference userRef =
      FirebaseFirestore.instance.collection("users").doc("test-user");

  CollectionReference typhColRef = FirebaseFirestore.instance
      .collection('users')
      .doc('test-user')
      .collection('typhoons');

  Future bruh({required double num})async{
    print("test idk");
  }

  Future<TyphoonDay> addDay(
      {String? typhoonId,
      required double damageCost,
      required String typhoonName,
      required double windSpeed,
      required double rainfall24,
      required double rainfall6,
      required String location,
      required String locationCode,
      required bool isFirstDay,
      required double price,
      required double disTrackMin
      }) async {
    print("dmgcostapi ${damageCost}");
    print(typhoonId);
    print(damageCost);
    print(typhoonName);
    print(windSpeed);
    print(rainfall24);
    print(rainfall6);
    print(location);
    print(locationCode);
    print(isFirstDay);
    print(price);

    //
    late TyphoonDay newlyAddedDay;
    var dayJson;
    final currentDateTime = DateTime.now();
    final currentYear = currentDateTime.year;
    if (isFirstDay) {
      print("REDVLET");
      //line below creates a new typhoon document inside typhoons collection
      DocumentReference typhoonDocRef = typhColRef.doc();
      final _typhoonId = typhoonDocRef.id;
      final typhoon = {
        "id": _typhoonId,
        "typhoonName": typhoonName,
        "peakWindspeed": windSpeed,
        "totalDamageCost": damageCost,
        "startDate": currentDateTime.toString(),
        "recentDayDateRecorded": currentDateTime.toString(),
        "peakRainfall24" : rainfall24,
        "peakRainfall6" : rainfall6,
        "endDate" : "",
        "currentDay": 1,
        "status": "ongoing",
        "year" : currentYear.toString()
      };

      await typhoonDocRef.set(typhoon);
      print("bruhbruhrbruh");
      //create new days collection inside newly created typhoons document
      CollectionReference daysColRef =
          typhColRef.doc(_typhoonId).collection("days");
      DocumentReference daysDocRef = daysColRef.doc();
      final _dayId = daysDocRef.id;
      DocumentReference allEstimations =
          userRef.collection("allDays").doc(_dayId);
      dayJson = {
        "id": _dayId,
        "typhoonID": _typhoonId,
        "typhoonName": typhoonName,
        "windSpeed": windSpeed,
        "rainfall24": rainfall24,
        "rainfall6" : rainfall6,
        "price" : price,
        "typhoonDistanceFromLocation" : disTrackMin,
        "location": location,
        "locationCode": locationCode,
        "day": 1,
        "damageCost": damageCost,
        "dateRecorded": currentDateTime.toString()
      };
      print("morisette");
      await daysDocRef.set(dayJson);
      await allEstimations.set(dayJson);
      print("percocets");
    } else {
      print("BEATAKOTONAI???");
      await updateTyphoon(typhoonId!, currentDateTime, damageCost);

      DocumentSnapshot typhoonDocSnapshot =
          await typhColRef.doc(typhoonId).get();
      DateTime typhoonRecentDay =
          DateTime.parse(typhoonDocSnapshot['recentDayDateRecorded']);
      DateTime dateOfRecentDay = DateTime(
          typhoonRecentDay.year, typhoonRecentDay.month, typhoonRecentDay.day);
      int currentDayOfTyphoon = typhoonDocSnapshot['currentDay'];
      CollectionReference daysColRef =
          typhColRef.doc(typhoonId).collection("days");
      DocumentReference daysDocRef = daysColRef.doc();
      final dayId = daysDocRef.id;
      DocumentReference allDays = userRef.collection("allDays").doc(dayId);

      dayJson = {
        "id": dayId,
        "typhoonID": typhoonId,
        "typhoonName": typhoonName,
        "windSpeed": windSpeed,
        "rainfall24": rainfall24,
        "rainfall6" : rainfall6,
        "typhoonDistanceFromLocation" : disTrackMin,
        "price" : price,
        "location": location,
        "locationCode": locationCode,
        "day": (DateTime(currentDateTime.year, currentDateTime.month,
                    currentDateTime.day)
                .isAfter(dateOfRecentDay))
            ? currentDayOfTyphoon + 1
            : currentDayOfTyphoon,
        "damageCost": damageCost,
        "dateRecorded": currentDateTime.toString()
      };

      await daysDocRef.set(dayJson);
      await allDays.set(dayJson);
    }

    newlyAddedDay = TyphoonDay.fromJson(dayJson);
    return newlyAddedDay;
  }

  Future<void> updateTyphoon(
      String typhoonId, DateTime currentDateTime, double damageCost) async {
    DocumentSnapshot typhoonDocSnapshot = await typhColRef.doc(typhoonId).get();
    DateTime typhoonRecentDay =
        DateTime.parse(typhoonDocSnapshot['recentDayDateRecorded']);
    DateTime dateOfRecentDay = DateTime(
        typhoonRecentDay.year, typhoonRecentDay.month, typhoonRecentDay.day);
    int currentDayOfTyphoon = typhoonDocSnapshot['currentDay'];
    double currentTotalDamageCost = typhoonDocSnapshot['totalDamageCost'];

    final damageCostFormatted = double.parse('${damageCost.toStringAsFixed(2)}');
    await typhColRef.doc(typhoonId).update({
      "recentDayDateRecorded": currentDateTime.toString(),
      "currentDay": (DateTime(currentDateTime.year, currentDateTime.month,
                  currentDateTime.day)
              .isAfter(dateOfRecentDay))
          ? currentDayOfTyphoon + 1
          : currentDayOfTyphoon,
      "totalDamageCost": currentTotalDamageCost + damageCostFormatted
    });
  }

  Future<TyphoonDay> getLastAddedDay() async {
    final x = await FirebaseFirestore.instance
        .collection('users')
        .doc('test-user')
        .collection('allDays')
        .orderBy('dateRecorded')
        .limit(1)
        .get();

    return TyphoonDay.fromJson(x.docs.first.data());
  }

  Stream<bool> isThereOngoingTyphoon(){
    return FirebaseFirestore.instance.collection('users').doc('test-user').collection('typhoons').snapshots().map((snapshot){
      
      if(snapshot.docs.isEmpty){
        return false;
      }
      
      bool hasOngoingTyphoon = snapshot.docs.any((doc) => doc['status'] == 'ongoing');
      return hasOngoingTyphoon;
    });
  }

  Future<Typhoon> getTyphoon(String typhoonID) async {
    DocumentSnapshot v = await FirebaseFirestore.instance
        .collection('users')
        .doc('test-user')
        .collection('typhoons')
        .doc(typhoonID)
        .get();
    return Typhoon.fromJson(v.data() as Map<String, dynamic>);
  }

  Stream<Typhoon> streamRecentEstimation() => FirebaseFirestore.instance
      .collection('users')
      .doc('test-user')
      .collection('typhoons')
      .where('status', isEqualTo: "ongoing")
      .snapshots()
      .map((snapshot) => snapshot.docs.first)
      .map((doc) => Typhoon.fromJson(doc.data()));

  Future<void> updateTyphoonStatusAsFinished(String typhoonID) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc('test-user')
        .collection('typhoons')
        .doc(typhoonID)
        .update({"status": "finished", "endDate": DateTime.now().toString()});
  }


  Stream<List<Typhoon>> streamAllTyphoons() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc('test-user')
        .collection('typhoons')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Typhoon.fromJson(doc.data())).toList());
  }

  Future<void> deleteTyphoon() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc('test-user')
        .collection('typhoons')
        .where('status', isEqualTo: 'ongoing')
        .get();

    List<Typhoon> typhoons =
        snapshot.docs.map((doc) => Typhoon.fromJson(doc.data())).toList();

    Typhoon ongoingTyphoon = typhoons.first;

    await FirebaseFirestore.instance
        .collection('users')
        .doc('test-user')
        .collection('typhoons')
        .doc(ongoingTyphoon.id)
        .delete();

    final snapshotDays = await FirebaseFirestore.instance
        .collection('users')
        .doc('test-user')
        .collection('allDays')
        .where('typhoonID', isEqualTo: ongoingTyphoon.id)
        .get();

    for (QueryDocumentSnapshot doc in snapshotDays.docs) {
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc('test-user')
          .collection('allDays')
          .doc(doc.id);

      await docRef.delete();
    }
  }

  Future<List<Location_>> getDistinctLocations(String typhoonID) async {
    QuerySnapshot daysSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc('test-user')
        .collection('typhoons')
        .doc(typhoonID)
        .collection('days')
        .orderBy('dateRecorded')
        .get();

    //taking all the locations from firestore
    List<Location_> notDistinctLocations = daysSnapshot.docs.map((doc) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Location_(
          munCode: data['locationCode'], munName: data['location']);
    }).toList();

    //to remove duplicates
    Set<Location_> distinctLocationsSet = notDistinctLocations.toSet();

    List<Location_> distinctLocationsList = distinctLocationsSet.toList();
    List<TyphoonDay> days = daysSnapshot.docs
        .map((doc) => TyphoonDay.fromJson(doc.data() as Map<String, dynamic>))
        .toList();

    //to set the TyphoonDays inside each distinct location
    for (int i = 0; i < days.length; i++) {
      for (Location_ loc in distinctLocationsList) {
        if (days[i].locationCode == loc.munCode) {
          loc.days.add(days[i]);
        }
      }
    }

    //for tallying per-location total dmgcost
    for (int i = 0; i < distinctLocationsList.length; i++) {
      double total = 0;
      for (TyphoonDay day in distinctLocationsList[i].days) {
        total += day.damageCost;
      }
      distinctLocationsList[i].totalDamageCost += total;
    }
    return distinctLocationsList;
  }

  Future<List<DamageCostBar>> getAllDamageCostBarsBasedOnYear({required int year}) async {
    QuerySnapshot typhSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc('test-user')
        .collection('typhoons')
        .get();
    List<Typhoon> typhoons = [];

    typhSnapshot.docs.forEach((doc) { 
      Map<String,dynamic> data = doc.data() as Map<String,dynamic>;
      DateTime startDate = DateTime.parse(data['startDate'] as String);

      if(startDate.year==year){
        typhoons.add(
          Typhoon.fromJson(data)
        );
      }
    });
    return typhoons.map((typhoon)=> DamageCostBar(typhoon.typhoonName, typhoon.totalDamageCost)).toList();
  }

  Stream<List<int>> getYearsListStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc('test-user')
        .collection('typhoons')
        .snapshots()
        .map((snapshot) {
      List<int> yearsList = [];

      snapshot.docs.forEach((document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        DateTime startDate = DateTime.parse(data['startDate']);
        int year = startDate.year; // Replace 'year' with your actual attribute name

        // Add the year to the list if it is not already present
        if (!yearsList.contains(year)) {
          yearsList.add(year);
        }
      });

      yearsList.sort((a, b) => b.compareTo(a)); // Sort in descending order
      return yearsList;
    });
  }

  Stream<List<DamageCostBar>> getAllDamageCostBarsBasedOnYearint(int selectedYear){
    return FirebaseFirestore.instance
    .collection('users')
    .doc('test-user')
    .collection('typhoons')
    .where('year', isEqualTo: selectedYear.toString())
    .snapshots()
    .map((snapshot) {
      List<Typhoon> typhoons = [];

      snapshot.docs.forEach((doc) {
        Map<String,dynamic> data = doc.data() as Map<String,dynamic>;
        typhoons.add(
          Typhoon.fromJson(data)
        );
      });
      return typhoons.map((typhoon) => DamageCostBar(typhoon.typhoonName, typhoon.totalDamageCost)).toList();
    });
  }

//   Stream<List<int>> getYearsListStream() {
//   return FirebaseFirestore.instance
//       .collection('your_collection_name')
//       .snapshots()
//       .map((QuerySnapshot<Map<String, dynamic>> snapshot) {
//     List<int> yearsList = [];

//     snapshot.docs.forEach((DocumentSnapshot document) {
//       Map<String, dynamic> data = document.data() as Map<String, dynamic>;
//       DateTime startDate = DateTime.parse(data['startDate']);
//       int year = startDate.year;
//       // int year = data['year'] ?? 0; // Replace 'year' with your actual attribute name

//       // Add the year to the list if it is not already present
//       if (!yearsList.contains(year)) {
//         yearsList.add(year);
//       }
//     });

//     return yearsList;
//   });
// }

  Future<List<int>> getTyphoonYears() async {
    QuerySnapshot yearsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc('test-user')
        .collection('typhoons')
        .get();

    List<int> bruh = [];

    for (var doc in yearsSnapshot.docs) {
      Map<String, dynamic> x = doc.data() as Map<String, dynamic>;
      int b = DateTime.parse(x['startDate']).year;
      bruh.add(b);
    }

    List<int> years = yearsSnapshot.docs
        .map<int>((doc) {
          Map<String, dynamic> docSnapshot = doc.data() as Map<String, dynamic>;
          DateTime b = DateTime.parse(docSnapshot['startDate'] as String);
          return b.year;
        })
        .toSet()
        .toList();

    print(years);
    return years;
  }

  Future<int> getFirstTyphoonYear()async{
    List<int> years = await getTyphoonYears();
    return years.first;
  }
}
