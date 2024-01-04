import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Text.dart';

class TextDataService {
  final collectionRef = FirebaseFirestore.instance.collection('texts');

  Future<List<Text>> getTexts() async{
    QuerySnapshot snapshot = await collectionRef.get();

    return snapshot.docs.map((doc) => Text(doc['text'])).toList();
  }

  Future<void> addText(String text) async{
    await collectionRef.add(
      {
        "text" : text
      }
    );
  }
}

  