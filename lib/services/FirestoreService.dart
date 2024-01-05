import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
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

  void addDay(
      {String? typhoonId,
      required String typhoonName,
      required double windSpeed,
      required double rainfall,
      required String location,
      required bool isFirstDay}) async {
    final double damageCost = estimatorModel().getEstimation();
    if (isFirstDay) {
      //line below creates a new typhoon document inside typhoons collection
      DocumentReference typhoonDocRef = typhColRef.doc();
      final _typhoonId = typhoonDocRef.id;
      final typhoon = {
        "id": _typhoonId,
        "typhoonName": typhoonName,
        "peakWindspeed": windSpeed,
        "peakRainfall": rainfall,
        "location": location,
        "totalDamageCost": damageCost,
        "startDate": DateTime.now().toString(),
        "endDate": "",
        "currentDay": 1
      };

      await typhoonDocRef.set(typhoon);

      //create new days collection inside newly created typhoons document
      CollectionReference daysColRef =
          typhColRef.doc(_typhoonId).collection("days");
      DocumentReference daysDocRef = daysColRef.doc();
      final _dayId = daysDocRef.id;
      DocumentReference allEstimations =
          userRef.collection("allDays").doc(_dayId);
      final day = {
        "id": _dayId,
        "typhoonID": _typhoonId,
        "typhoonName": typhoonName,
        "windSpeed": windSpeed,
        "rainfall": rainfall,
        "location": location,
        "day": 1,
        "damageCost": damageCost,
        "dateRecorded": DateTime.now().toString()
      };
      await daysDocRef.set(day);
      await allEstimations.set(day);
    } else {
      DocumentSnapshot typhoonDocSnapshot =
          await typhColRef.doc(typhoonId!).get();
      int currentDayOfTyphoon = typhoonDocSnapshot['currentDay'];
      double currentTotalDamageCost = typhoonDocSnapshot['totalDamageCost'];
      CollectionReference daysColRef =
          typhColRef.doc(typhoonId).collection("days");
      DocumentReference daysDocRef = daysColRef.doc();
      final dayId = daysDocRef.id;
      DocumentReference allEstimations =
          userRef.collection("allDays").doc(dayId);
      final day = {
        "id": dayId,
        "typhoonID": typhoonId,
        "typhoonName": typhoonName,
        "windSpeed": windSpeed,
        "rainfall": rainfall,
        "location": location,
        "day": currentDayOfTyphoon + 1,
        "damageCost": damageCost,
        "dateRecorded": DateTime.now().toString()
      };
      await typhColRef.doc(typhoonId).update({
        "currentDay": currentDayOfTyphoon + 1,
        "totalDamageCost": currentTotalDamageCost + damageCost
      });
      await daysDocRef.set(day);
      await allEstimations.set(day);
    }
  }

  //FOR LIST
  Stream<List<Typhoon>> streamAllTyphoons() => FirebaseFirestore.instance
      .collection('users')
      .doc('test-user')
      .collection('typhoons')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((json) {
            print("dadajjk2394777777");
            final v = Typhoon.fromJson(json.data());
            print("11111111111111111");
            return v;
          }).toList());

  Stream<List<TyphoonDay>> streamAllDays() => FirebaseFirestore.instance
      .collection('users')
      .doc('test-user')
      .collection('allDays')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((json) {
            print("88888888888888");
            final v = TyphoonDay.fromJson(json.data());
            return v;
          }).toList());

  Stream<Typhoon> streamRecentEstimation() => FirebaseFirestore.instance
      .collection('users')
      .doc('test-user')
      .collection('typhoons')
      .orderBy('startDate', descending: true)
      .limit(1)
      .snapshots()
      .map((snapshot) => snapshot.docs.first)
      .map((doc) => Typhoon.fromJson(doc.data()));

  Stream<TyphoonDay> getRecentlyAddedDay() {
    return FirebaseFirestore.instance.collection('users').doc('test-user').collection('allDays')
    .orderBy('creationDate', descending: true)
    .limit(1)
    .snapshots()
    .map((snapshot) => snapshot.docs.first)
    .map((doc) => TyphoonDay.fromJson(doc.data()));
  }

  // Future<List<TyphoonDay>> fetchAllDaysList() async {
  //   try {
  //     print("FLOWER");
  //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc('test-user')
  //         .collection('allDays')
  //         .get();
  //     print("MONSTERA");
  //     List<QueryDocumentSnapshot> docs = querySnapshot.docs;

  //     List<TyphoonDay> tempList = docs.map((doc) {
  //       return TyphoonDay.fromJson(doc.data() as Map<String, dynamic>);
  //     }).toList();

  //     print("ZETSUE NO TEMPEST");
  //     return tempList;
  //   } catch (e) {
  //     print("ERROR FETCHING ALL DAYS LIST: ${e}");
  //     return [];
  //   }
  // }

  // Future<TyphoonDay> fetchRecentEstimation() async {
  //   print("DAITOSHOKAN");
  //   List<TyphoonDay> allDays = await fetchAllDaysList();

  //   List<DateTime> allRecordedDates = allDays
  //       .map((TyphoonDay day) => DateTime.parse(day.dateRecorded))
  //       .toList();
  //   TyphoonDay recentEstimation = allDays[allRecordedDates.indexOf(allRecordedDates.reduce(
  //       (currentRecent, dateTime) =>
  //           dateTime.isAfter(currentRecent) ? dateTime : currentRecent))];
  //   print("RECENT EST DAMAGE COST: ${recentEstimation.damageCost.round()}");
  //   return recentEstimation;
  // }
}
