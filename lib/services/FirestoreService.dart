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

  Future<TyphoonDay> addDay(
      {String? typhoonId,
      required String typhoonName,
      required double windSpeed,
      required double rainfall,
      required String location,
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
        "location": location,
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

  Stream<List<TyphoonDay>> streamAllDays() => FirebaseFirestore.instance
      .collection('users')
      .doc('test-user')
      .collection('allDays')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((json) {
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
    return FirebaseFirestore.instance
        .collection('users')
        .doc('test-user')
        .collection('allDays')
        .orderBy('creationDate', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) => snapshot.docs.first)
        .map((doc) => TyphoonDay.fromJson(doc.data()));
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
