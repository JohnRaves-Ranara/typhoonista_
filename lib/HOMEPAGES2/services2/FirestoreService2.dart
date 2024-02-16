import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/entities2/new/Day.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/entities2/new/Municipality.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/entities2/new/Owner.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/entities2/new/Province.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/entities2/new/Typhoon.dart';
import 'package:typhoonista_thesis/tests/city.dart';

class FirestoreService2 {
  DocumentReference userRef =
      FirebaseFirestore.instance.collection('users3').doc('test-user3');

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

}
