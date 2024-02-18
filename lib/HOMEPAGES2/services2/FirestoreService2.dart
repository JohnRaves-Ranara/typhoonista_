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
      Owner? ownerToUpdate,
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
    if (ownerToUpdate == null) {
      //ADD OWNER
      String currentDateTime = DateTime.now().toString();
      //get forecast
      List<Day> forecast = await forecastModel().forecast(
          initial_ws: windSpeed,
          initial_rf24: rainfall24,
          initial_rf6: rainfall6,
          initial_area: riceArea,
          initial_yield: riceYield,
          initial_distance: distance,
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
        "daysCount" : dayCount,
        "color": ownerColor,
        "dateRecorded":
            currentDateTime, //get this first thing in the function. DateTime.now().toString()
        "id":
            ownerID, // NAHH, SCRATCH THAT, JUST USE UUID().V1() FOR OWNER ID, FOR PROPER ORGANIZATION.
        "munName": munName,
        "municipalityID": municipalityID,
        "ownerName": ownerName,
        "provName": provName,
        "provinceID": provinceID,
        "totalDamageCost": double.parse(totalDamageCost.toStringAsFixed(2)),
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
          "ownerID": ownerID,
          "provinceID": provinceID,
          "rainfall24": day.rainfall24,
          "rainfall6": day.rainfall6,
          "riceArea": day.riceArea,
          "ricePrice": day.ricePrice,
          "riceYield": day.riceYield,
          "typhoonID": ongoingTyphoonID,
          "windSpeed": day.windSpeed,
        });
      }
      await updateMunicipalityTotalDamageCost(
          ongoingTyphoonID, provinceID!, municipalityID!);
      await updateProvinceTotalDamageCost(ongoingTyphoonID, provinceID);
      await updateTyphoonTotalDamageCost(ongoingTyphoonID);
    } else {
      String currentDateTime = DateTime.now().toString();
      //UPDATE OWNER

      //DELETE ALL DAYS IN THE OWNER
      await deleteAllDaysOfOwner(ownerToUpdate);

      //DELETE THE OWNER
      await deleteOwner(ownerToUpdate);

      //get new forecast
      List<Day> forecast = await forecastModel().forecast(
          initial_ws: windSpeed,
          initial_rf24: rainfall24,
          initial_rf6: rainfall6,
          initial_area: riceArea,
          initial_yield: riceYield,
          initial_distance: distance,
          rice_price: ricePrice,
          days: dayCount);

      //doesnt exist yet since bago ra gi delete
      DocumentReference ownerDocRef = userRef
          .collection('typhoons')
          .doc(ownerToUpdate.typhoonID)
          .collection('provinces')
          .doc(ownerToUpdate.provinceID)
          .collection('municipalities')
          .doc(ownerToUpdate.municipalityID)
          .collection('owners')
          .doc(ownerToUpdate.id);

      //populate each Day's typhoonID, provID, munID, and ownerID
      forecast.forEach((day) {
        day.typhoonID = ownerToUpdate.typhoonID;
        day.provinceID = ownerToUpdate.provinceID;
        day.municipalityID = ownerToUpdate.municipalityID;
        day.ownerID = ownerToUpdate.id;
      });

      //getting totaldmgcost of all days
      double total = 0;
      for (Day day in forecast) {
        total += day.damageCost!;
      }
      double totalDamageCost = total;

      //adding owner to db
      await ownerDocRef.set({
        "daysCount" : dayCount,
        "color": [ownerToUpdate.colorMarker.red, ownerToUpdate.colorMarker.green, ownerToUpdate.colorMarker.red],
        "dateRecorded":
            currentDateTime, //get this first thing in the function. DateTime.now().toString()
        "id":
            ownerToUpdate.id, // NAHH, SCRATCH THAT, JUST USE UUID().V1() FOR OWNER ID, FOR PROPER ORGANIZATION.
        "munName": munName,
        "municipalityID": municipalityID,
        "ownerName": ownerToUpdate.ownerName,
        "provName": provName,
        "provinceID": provinceID,
        "totalDamageCost": double.parse(totalDamageCost.toStringAsFixed(2)),
        "typhoonID": ownerToUpdate.typhoonID,
      });

      for (Day day in forecast) {
        String dayID = uuid.v1();
        DocumentReference daysColRef = userRef
            .collection('typhoons')
            .doc(ownerToUpdate.typhoonID)
            .collection('provinces')
            .doc(ownerToUpdate.provinceID)
            .collection('municipalities')
            .doc(ownerToUpdate.municipalityID)
            .collection('owners')
            .doc(ownerToUpdate.id)
            .collection('days')
            .doc(dayID);

        await daysColRef.set({
          "damageCost": day.damageCost,
          "dayNum": day.dayNum,
          "disTrackMin": day.distance,
          "id": dayID,
          "municipalityID": ownerToUpdate.municipalityID,
          "ownerID": ownerToUpdate.id,
          "provinceID": ownerToUpdate.provinceID,
          "rainfall24": day.rainfall24,
          "rainfall6": day.rainfall6,
          "riceArea": day.riceArea,
          "ricePrice": day.ricePrice,
          "riceYield": day.riceYield,
          "typhoonID": ownerToUpdate.typhoonID,
          "windSpeed": day.windSpeed,
        });
      }

      await updateMunicipalityTotalDamageCost(
          ownerToUpdate.typhoonID!, ownerToUpdate.provinceID!, ownerToUpdate.municipalityID!);
      await updateProvinceTotalDamageCost(ownerToUpdate.typhoonID!, ownerToUpdate.provinceID!);
      await updateTyphoonTotalDamageCost(ownerToUpdate.typhoonID!);

      
    }
  }

  Future<void> deleteAllDaysOfOwner(Owner owner)async{
    CollectionReference daysColRef = userRef.collection('typhoons').doc(owner.typhoonID)
    .collection('provinces').doc(owner.provinceID)
    .collection('municipalities').doc(owner.municipalityID)
    .collection('owners').doc(owner.id)
    .collection('days');
    QuerySnapshot daysSnapshot = await daysColRef.get();

    for(DocumentSnapshot doc in daysSnapshot.docs){
      Map<String,dynamic> data = doc.data() as Map<String,dynamic>;

      await daysColRef.doc(data['id']).delete();
    }

    
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

  Future<List<Day>> getAllDays(
      String typhoonID, String provID, String munID, String ownerID) async {
    QuerySnapshot firstDaySnapshot = await userRef
        .collection('typhoons')
        .doc(typhoonID)
        .collection('provinces')
        .doc(provID)
        .collection('municipalities')
        .doc(munID)
        .collection('owners')
        .doc(ownerID)
        .collection('days')
        .get();
    List<Day> days = [];
    for (DocumentSnapshot doc in firstDaySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      // if(data['dayNum'] == 1){
      //   firstDay = Day.fromJson(data);
      // }
      days.add(Day.fromJson(data));
    }
    return days;
  }

  List<int> getColorRGBList() {
    Random random = Random();
    List<int> randomNumbers = [];

    for (int i = 0; i < 3; i++) {
      int randomNumber =
          random.nextInt(128) + 128; // Generates a random number between 0 and 255
      randomNumbers.add(randomNumber);
    }

    return randomNumbers;
  }

  Future<void> deleteOwner(Owner ownerToDelete) async {
    await userRef
        .collection('typhoons')
        .doc(ownerToDelete.typhoonID)
        .collection('provinces')
        .doc(ownerToDelete.provinceID)
        .collection('municipalities')
        .doc(ownerToDelete.municipalityID)
        .collection('owners')
        .doc(ownerToDelete.id)
        .delete();
  }

}
