import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:typhoonista_thesis/entities/Location.dart';
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

  Future<TyphoonDay> addDay(
      {String? typhoonId,
      required String typhoonName,
      required double windSpeed,
      required double rainfall,
      required String location,
      required String locationCode,
      required bool isFirstDay}) async {
    final double damageCost = estimatorModel().getEstimation();
    late TyphoonDay newlyAddedDay;
    var dayJson;
    final currentDateTime = DateTime.now();
    if (isFirstDay) {
      //line below creates a new typhoon document inside typhoons collection
      DocumentReference typhoonDocRef = typhColRef.doc();
      final _typhoonId = typhoonDocRef.id;
      final typhoon = {
        "id": _typhoonId,
        "typhoonName": typhoonName,
        "peakWindspeed": windSpeed,
        "peakRainfall": rainfall,
        "totalDamageCost": damageCost,
        "startDate": currentDateTime.toString(),
        "recentDayDateRecorded": currentDateTime.toString(),
        "endDate": "",
        "currentDay": 1,
        "status": "ongoing"
      };

      await typhoonDocRef.set(typhoon);
      
      
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
        "rainfall": rainfall,
        "location": location,
        "locationCode" : locationCode,
        "day": 1,
        "damageCost": damageCost,
        "dateRecorded": currentDateTime.toString()
      };
      await daysDocRef.set(dayJson);
      await allEstimations.set(dayJson);
    } else {
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
        "rainfall": rainfall,
        "location": location,
        "locationCode" : locationCode,
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

    await typhColRef.doc(typhoonId).update({
      "recentDayDateRecorded": currentDateTime.toString(),
      "currentDay": (DateTime(currentDateTime.year, currentDateTime.month,
                  currentDateTime.day)
              .isAfter(dateOfRecentDay))
          ? currentDayOfTyphoon + 1
          : currentDayOfTyphoon,
      "totalDamageCost": currentTotalDamageCost + damageCost
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

  Future<void> updateTyphoonStatusAsFinished(String typhoonID) async{
    await FirebaseFirestore.instance.collection('users').doc('test-user').collection('typhoons').doc(typhoonID).update({
      "status" : "finished",
      "endDate" : DateTime.now().toString()
    });
  }

  // Stream<TyphoonDay> getRecentlyAddedDay() {
  //   return FirebaseFirestore.instance
  //       .collection('users')
  //       .doc('test-user')
  //       .collection('allDays')
  //       .orderBy('creationDate', descending: true)
  //       .limit(1)
  //       .snapshots()
  //       .map((snapshot) => snapshot.docs.first)
  //       .map((doc) => TyphoonDay.fromJson(doc.data()));
  // }

  Stream<List<Typhoon>> streamAllTyphoons() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc('test-user')
        .collection('typhoons')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Typhoon.fromJson(doc.data())).toList());
  }

  Future<void> deleteTyphoon() async{
    final snapshot = await FirebaseFirestore.instance.collection('users').doc('test-user').collection('typhoons').where('status', isEqualTo: 'ongoing').get();
    
    List<Typhoon> typhoons = snapshot.docs.map((doc) => Typhoon.fromJson(doc.data())).toList();

    Typhoon ongoingTyphoon = typhoons.first;

    await FirebaseFirestore.instance.collection('users').doc('test-user').collection('typhoons').doc(ongoingTyphoon.id).delete();

    final snapshotDays = await FirebaseFirestore.instance.collection('users').doc('test-user').collection('allDays').where('typhoonID', isEqualTo: ongoingTyphoon.id).get();

    for(QueryDocumentSnapshot doc in snapshotDays.docs){
      final docRef = FirebaseFirestore.instance.collection('users').doc('test-user').collection('allDays').doc(doc.id);

      await docRef.delete();
    }

  }

  Future<List<Location>> getDistinctLocations(String typhoonID) async {
    QuerySnapshot daysSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc('test-user')
        .collection('typhoons')
        .doc(typhoonID)
        .collection('days')
        .orderBy('dateRecorded')
        .get();

    //taking all the locations from firestore
    List<Location> notDistinctLocations = daysSnapshot.docs.map((doc) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Location(code: data['locationCode'], name: data['location']);
    }).toList();

    //to remove duplicates
    Set<Location> distinctLocationsSet = notDistinctLocations.toSet();

    List<Location> distinctLocationsList = distinctLocationsSet.toList();
    List<TyphoonDay> days = daysSnapshot.docs
        .map((doc) => TyphoonDay.fromJson(doc.data() as Map<String, dynamic>))
        .toList();

    //to set the TyphoonDays inside each distinct location
    for (int i = 0; i < days.length; i++) {
      for (Location loc in distinctLocationsList) {
        if (days[i].locationCode == loc.code) {
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

}
