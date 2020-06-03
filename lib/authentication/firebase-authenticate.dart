import 'package:haftaa/Authentication/authenticatable.dart';
import 'package:haftaa/user/base-user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class FirebaseAuthenticate {
  FirebaseAuth _firebaseauth;
  FirebaseAuthenticate() {
    _firebaseauth = FirebaseAuth.instance;
  }

  Future<FirebaseUser> signin(String email, String password) async {
    var signingResult = await _firebaseauth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((onValue) {
      var dd;
    });
    return signingResult.user;
  }

  Future<FirebaseUser> createUser(String email, String password) async {
    var registrationResult = await _firebaseauth.createUserWithEmailAndPassword(
        email: email, password: password);
    return registrationResult.user;
  }

  signOut() async {
    await _firebaseauth.signOut();
  }

  Future<FirebaseUser> getCurrentUser() async {
    return await _firebaseauth.currentUser();
  }
}
