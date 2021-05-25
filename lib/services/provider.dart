import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Provider extends StatelessWidget {
  final firestoreInstance_notes = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    firestoreInstance_notes.collection("notes").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print(result.data());
      });
    });
    return Text("loading");
  }
}
