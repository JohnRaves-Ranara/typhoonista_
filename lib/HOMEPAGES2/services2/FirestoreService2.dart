import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/entities2/new/Day.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/entities2/new/Municipality.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/entities2/new/Owner.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/entities2/new/Province.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/entities2/new/Typhoon.dart';
import 'package:typhoonista_thesis/tests/city.dart';
import 'package:uuid/uuid.dart';
import 'forecastModel.dart';

class FirestoreService2 {
  DocumentReference userRef =
      FirebaseFirestore.instance.collection('users3').doc('test-user3');

  Uuid uuid = Uuid();

  Future<Typhoon?> getOngoingTyphoon() async {
    QuerySnapshot typhoons =
        await userRef.collection('typhoons').limit(1).get();
    Typhoon? ongoingTyphoon;
    for (var typhoonDoc in typhoons.docs) {
      Map<String, dynamic> doc = typhoonDoc.data() as Map<String, dynamic>;
      if (doc['status'] == 'ongoing') {
        ongoingTyphoon = Typhoon(
            id: doc['id'],
            typhoonName: doc['typhoonName'],
            totalDamageCost: doc['totalDamageCost']);
      }
    }
    return ongoingTyphoon;
  }

  Stream<List<Owner>> streamAllOwners() async* {
    Typhoon? ongoingTyphoon = await getOngoingTyphoon();
    DocumentReference ongoingTyphoonDocRef =
        userRef.collection('typhoons').doc(ongoingTyphoon!.id);
    yield* FirebaseFirestore.instance
        .collectionGroup('owners')
        .orderBy(FieldPath.documentId)
        .startAt([ongoingTyphoonDocRef.path])
        .endAt([ongoingTyphoonDocRef.path + "\uf8ff"])
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Owner.fromJson(doc.data())).toList());
  }

  Stream<List<Day>> streamAllDays() async* {
    Typhoon? ongoingTyphoon = await getOngoingTyphoon();
    DocumentReference ongoingTyphoonDocRef =
        userRef.collection('typhoons').doc(ongoingTyphoon!.id);
    yield* FirebaseFirestore.instance
        .collectionGroup('days')
        .orderBy(FieldPath.documentId)
        .startAt([ongoingTyphoonDocRef.path])
        .endAt([ongoingTyphoonDocRef.path + "\uf8ff"])
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Day.fromJson(doc.data())).toList());
  }

  Stream<List<Municipality>> streamAllMunicipalities() async* {
    Typhoon? ongoingTyphoon = await getOngoingTyphoon();
    DocumentReference ongoingTyphoonDocRef =
        userRef.collection('typhoons').doc(ongoingTyphoon!.id);
    yield* FirebaseFirestore.instance
        .collectionGroup('municipalities')
        .orderBy(FieldPath.documentId)
        .startAt([ongoingTyphoonDocRef.path])
        .endAt([ongoingTyphoonDocRef.path + "\uf8ff"])
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Municipality.fromJson(doc.data()))
            .toList());
  }

  Stream<List<Province>> streamAllProvinces() async* {
    Typhoon? ongoingTyphoon = await getOngoingTyphoon();
    DocumentReference ongoingTyphoonDocRef =
        userRef.collection('typhoons').doc(ongoingTyphoon!.id);
    yield* FirebaseFirestore.instance
        .collectionGroup('provinces')
        .orderBy(FieldPath.documentId)
        .startAt([ongoingTyphoonDocRef.path])
        .endAt([ongoingTyphoonDocRef.path + "\uf8ff"])
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return Province.fromJson(doc.data());
            }).toList());
  }

  Stream<Typhoon> streamOngoingTyphoon() {
    return userRef
        .collection('typhoons')
        .where('status', isEqualTo: 'ongoing')
        .snapshots()
        .map((snapshot) => Typhoon.fromJson(snapshot.docs.first.data()));
  }

  Future<void> addOwner(
      //geo
      String? provinceID,
      String? municipalityID,
      String? provName,
      String? munName,
      //typhoon
      double windSpeed,
      double rainfall24,
      double rainfall6,
      double ricePrice,
      double riceArea,
      double riceYield,
      double distance,
      //forecast
      int dayCount) async {
    String currentDateTime = DateTime.now().toString();
    //get forecast
    List<Day> forecast = await forecastModel().forecast(
        next_ws: windSpeed,
        next_rf24: rainfall24,
        next_rf6: rainfall6,
        next_area: riceArea,
        next_yield: riceYield,
        next_distance: distance,
        rice_price: ricePrice,
        days: dayCount);

    //get ongoing typhoon ID

    Typhoon? ongoingTyphoon = await getOngoingTyphoon();
    String ongoingTyphoonID = ongoingTyphoon!.id;

    //check if province with given provinceID already exists
    CollectionReference provinceColRef = userRef
        .collection('typhoons')
        .doc(ongoingTyphoonID)
        .collection('provinces');
    DocumentSnapshot provinceDocSnapshot =
        await provinceColRef.doc(provinceID).get();
    //if it does not exist, add it to db.
    if (!provinceDocSnapshot.exists) {
      print("WALA PA GA EXIST ANG NAPILI NGA PROVINCE");
      DocumentReference provDocRef = provinceColRef.doc(provinceID);
      await provDocRef.set({
        'color': getColorRGBList(),
        'id': provinceID,
        'provName': provName,
        'totalDamageCost': 0, //to be updated later if ma add na ang days
        'typhoonID': ongoingTyphoonID
      });
      print("ADDED NA ANG PROVINCE");
    } 

    //check if municipality with given munID already exists
      CollectionReference munColRef = userRef
          .collection('typhoons')
          .doc(ongoingTyphoonID)
          .collection('provinces')
          .doc(provinceID)
          .collection('municipalities');
      DocumentSnapshot munDocSnapshot =
          await provinceColRef.doc(municipalityID).get();
      //if it does not exist, add it to db.
      if (!munDocSnapshot.exists) {
        print("WALA PA GA EXIST ANG NAPILI NGA MUNICIPALITY");
        DocumentReference munDocRef = munColRef.doc(municipalityID);
        await munDocRef.set({
          'color': getColorRGBList(),
          'id': municipalityID,
          'munName': munName,
          'provinceID': provinceID,
          'totalDamageCost': 0, //to be updated later if ma add na ang days
          'typhoonID': ongoingTyphoonID
        });
        print("NA ADD NA ANG MUNICIPALITY");
      }

    //ownerColRef
    CollectionReference ownerColRef = userRef
        .collection('typhoons')
        .doc(ongoingTyphoonID)
        .collection('provinces')
        .doc(provinceID)
        .collection('municipalities')
        .doc(municipalityID)
        .collection('owners');
    //getOwnerID
    String ownerID = uuid.v1();

    DocumentReference ownerDocRef = userRef
        .collection('typhoons')
        .doc(ongoingTyphoonID)
        .collection('provinces')
        .doc(provinceID)
        .collection('municipalities')
        .doc(municipalityID)
        .collection('owners')
        .doc(ownerID);

    //populate each Day's typhoonID, provID, munID, and ownerID
    forecast.forEach((day) {
      day.typhoonID = ongoingTyphoonID;
      day.provinceID = provinceID;
      day.municipalityID = municipalityID;
      day.ownerID = ownerID;
    });

    //In firestore, check provname and munname dupes.
    //get all documents in the owners collection
    QuerySnapshot ownerDocs = await ownerColRef.get();
    int ownerDupeCount = 0;
    for (DocumentSnapshot ownerDoc in ownerDocs.docs) {
      Map<String, dynamic> docData = ownerDoc.data() as Map<String, dynamic>;

      if (docData['provName'] == provName && docData['munName'] == munName) {
        ownerDupeCount++;
      }
    }

    String ownerName = '';
    //if no dupes, set name as provname,munname. If has dupes, set as provname,munname (count)
    if (ownerDupeCount == 0) {
      ownerName = '${provName}, ${munName}';
    } else {
      ownerName = '${provName}, ${munName} (${ownerDupeCount + 1})';
    }

    List<int> ownerColor = getColorRGBList();

    double total = 0;
    for (Day day in forecast) {
      total += day.damageCost!;
    }
    double totalDamageCost = total;

    await ownerDocRef.set({
      "color": ownerColor,
      "dateRecorded":
          currentDateTime, //get this first thing in the function. DateTime.now().toString()
      "id":
          ownerID, // NAHH, SCRATCH THAT, JUST USE UUID().V1() FOR OWNER ID, FOR PROPER ORGANIZATION.
      "munName": munName,
      "municipalityID": municipalityID,
      "ownerName" : ownerName,
      "provName": provName,
      "provinceID": provinceID,
      "totalDamageCost": totalDamageCost,
      "typhoonID": ongoingTyphoonID,
    });

    for (Day day in forecast) {
      String dayID = uuid.v1();
      DocumentReference daysColRef = userRef
          .collection('typhoons')
          .doc(ongoingTyphoonID)
          .collection('provinces')
          .doc(provinceID)
          .collection('municipalities')
          .doc(municipalityID)
          .collection('owners')
          .doc(ownerID)
          .collection('days')
          .doc(dayID);

      await daysColRef.set({
        "damageCost": day.damageCost,
        "dayNum": day.dayNum,
        "disTrackMin": day.distance,
        "id": dayID,
        "municipalityID": municipalityID,
        "ownerID" : ownerID,
        "provinceID": provinceID,
        "rainfall24": day.rainfall24,
        "rainfall6": day.rainfall6,
        "riceArea": day.riceArea,
        "ricePrice": day.ricePrice,
        "riceYield": day.riceYield,
        "typhoonID" : ongoingTyphoonID,
        "windSpeed": day.windSpeed,
      });
    }

    //UPDATE TOTAL DAMAGES OF TYPHOON, PROVINCE, AND MUNICIPALITY.
    //NOTE: THIS IS ONLY FOR FIRST TIME ADDING. // ON SECOND THOUGHT, IDK.

    await updateMunicipalityTotalDamageCost(ongoingTyphoonID, provinceID!, municipalityID!);
    await updateProvinceTotalDamageCost(ongoingTyphoonID, provinceID);
    await updateTyphoonTotalDamageCost(ongoingTyphoonID);
  }

  Future<void> updateTyphoonTotalDamageCost(String typhoonID) async {
    DocumentReference typhoonDocRef =
        userRef.collection('typhoons').doc(typhoonID);
    CollectionReference provincesColRef = typhoonDocRef.collection('provinces');
    QuerySnapshot provincesSnapshot = await provincesColRef.get();
    double totalDamageCost = 0;

    for (DocumentSnapshot doc in provincesSnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      totalDamageCost += data['totalDamageCost'];
    }
    // return totalDamageCost;

    await typhoonDocRef.update({'totalDamageCost': totalDamageCost});
  }

  Future<void> updateProvinceTotalDamageCost(
      String typhoonID, String provinceID) async {
    DocumentReference provinceDocRef = userRef
        .collection('typhoons')
        .doc(typhoonID)
        .collection('provinces')
        .doc(provinceID);
    CollectionReference municipalitiesColRef =
        provinceDocRef.collection('municipalities');
    QuerySnapshot municipalitiesSnapshot = await municipalitiesColRef.get();
    double totalDamageCost = 0;

    for (DocumentSnapshot doc in municipalitiesSnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      totalDamageCost += data['totalDamageCost'];
    }
    // return totalDamageCost;

    await provinceDocRef.update({'totalDamageCost': totalDamageCost});
  }

  Future<void> updateMunicipalityTotalDamageCost(
      String typhoonID, String provinceID, String municipalityID) async {
    DocumentReference municipalityDocRef = userRef
        .collection('typhoons')
        .doc(typhoonID)
        .collection('provinces')
        .doc(provinceID)
        .collection('municipalities')
        .doc(municipalityID);
    CollectionReference ownersColRef = municipalityDocRef.collection('owners');
    QuerySnapshot ownersSnapshot = await ownersColRef.get();
    double totalDamageCost = 0;

    for (DocumentSnapshot doc in ownersSnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      totalDamageCost += data['totalDamageCost'];
    }
    // return totalDamageCost;

    municipalityDocRef.update({'totalDamageCost': totalDamageCost});
  }

  Future<void> updateOwnerTotalDamageCost(String typhoonID, String provinceID,
      String municipalityID, String ownerID) async {
    DocumentReference ownerDocRef = userRef
        .collection('typhoons')
        .doc(typhoonID)
        .collection('provinces')
        .doc(provinceID)
        .collection('municipalities')
        .doc(municipalityID)
        .collection('owners')
        .doc(ownerID);
    CollectionReference daysColRef = ownerDocRef.collection('days');
    QuerySnapshot daysSnapshot = await daysColRef.get();
    double totalDamageCost = 0;

    for (DocumentSnapshot doc in daysSnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      totalDamageCost += data['damageCost'];
    }
    // return totalDamageCost;

    ownerDocRef.update({'totalDamageCost': totalDamageCost});
  }

  List<int> getColorRGBList() {
    Random random = Random();
    List<int> randomNumbers = [];

    for (int i = 0; i < 3; i++) {
      int randomNumber =
          random.nextInt(256); // Generates a random number between 0 and 255
      randomNumbers.add(randomNumber);
    }

    return randomNumbers;
  }
}
