import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService2{

  DocumentReference userRef = FirebaseFirestore.instance.collection('users2').doc('test-user2');

  Future<void> addTyphoon(String typhoonName) async{

    DocumentReference typhRef = userRef.collection('typhoons').doc();
    await typhRef.set({
      'id' : typhRef.id,
      'name' : typhoonName,
    });
  }
}