import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/entities2/Day.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/entities2/Municipality.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/entities2/Owner.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/entities2/Province.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/entities2/Typhoon.dart';
import 'package:typhoonista_thesis/tests/city.dart';

class FirestoreService2 {
  DocumentReference userRef =
      FirebaseFirestore.instance.collection('users3').doc('test-user3');

  Future<void> addTyphoon(String typhoonName) async {
    DocumentReference typhRef = userRef.collection('typhoons').doc();
    await typhRef.set({
      'id': typhRef.id,
      'name': typhoonName,
    });
  }

  Stream<Typhoon> streamOngoingTyphoon() {
    return userRef
        .collection('typhoons')
        .where('status', isEqualTo: 'ongoing')
        .snapshots()
        .map((snapshot) => snapshot.docs.first)
        .map((doc) => Typhoon.fromJson(doc.data()));
  }

  Stream<List<Province>> streamProvinces(String typhoonID) {
    return userRef
        .collection('typhoons')
        .doc(typhoonID)
        .collection('provinces')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Province.fromJson(doc.data())).toList());
  }

  Stream<List<Municipality>> streamMunicipalities(
      String typhoonID, String provinceID) {
    return userRef
        .collection('typhoons')
        .doc(typhoonID)
        .collection('provinces')
        .doc(provinceID)
        .collection('municipalities')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Municipality.fromJson(doc.data()))
            .toList());
  }

  Stream<List<Owner>> streamOwners(
      String typhoonID, String provID, String munID) {
    return userRef
        .collection('typhoons')
        .doc(typhoonID)
        .collection('provinces')
        .doc(provID)
        .collection('municipalities')
        .doc(munID)
        .collection('owners')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Owner.fromJson(doc.data())).toList());
  }

  Stream<List<Day>> streamDays(
      String typhoonID, String provID, String munID, String ownerID) {
    return userRef
        .collection('typhoons')
        .doc(typhoonID)
        .collection('provinces')
        .doc(provID)
        .collection('municipalities')
        .doc(munID)
        .collection('owners')
        .doc(ownerID)
        .collection('days')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Day.fromJson(doc.data())).toList());
  }
}
