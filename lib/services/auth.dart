import 'package:admin/domain/myuser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _fAuth = FirebaseAuth.instance;
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference collectionReferenceNotes =
      FirebaseFirestore.instance.collection('notes');

  Future<MyUser?>? signInWithEmainAndPasswordo(
      String email, String password) async {
    try {
      UserCredential authResult = await _fAuth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = authResult.user;
      return MyUser.fromFirebase(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return null;
    }
  }

  Future logOut() async {
    await _fAuth.signOut();
  }

  Stream<MyUser?> get currentUser {
    return _fAuth
        .authStateChanges()
        .map((User? user) => user != null ? MyUser.fromFirebase(user) : null);
  }

  Future<QuerySnapshot>? getUserData(String nickname) async {
    if (nickname == "All users" || nickname == "") {
      return FirebaseFirestore.instance.collection('users').get();
    } else {
      return FirebaseFirestore.instance
          .collection('users')
          .where("nickname", isEqualTo: nickname)
          .get();
    }
  }

  delete(String uid) {
    collectionReference.doc(uid).delete().then((_) {
      print("success!");
    });
  }

  deleteNotes(String uid) {
    collectionReferenceNotes.doc(uid).delete().then((_) {
      print("_success!");
    });
  }

  getPublicNotes(String nickname) {
    if (nickname == "All users" || nickname == "") {
      return FirebaseFirestore.instance
          .collection('notes')
          .where('public', isEqualTo: true)
          .snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection('notes')
          .where('public', isEqualTo: true)
          .where('user_nickname', isEqualTo: nickname)
          .snapshots();
    }
  }
}
