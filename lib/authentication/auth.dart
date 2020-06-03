// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:haftaa/user/user-controller.dart';
import 'package:haftaa/user/user.dart';

abstract class BaseAuth {
  Stream<FirebaseUser> get onAuthStateChanged;

  Future<String> signInWithEmailAndPassword(String email, String password);

  Future<String> createUserWithEmailAndPassword(String email, String password);

  Future<FirebaseUser> currentFirebaseUser();
  Future<User> currentUser();
  Future<void> signOut();
  void refreshUserData();
  // Future<String> signInWithGoogle();
  // Future<String> signInWithFacebook();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<User> _currentUser;
  FirebaseUser firebaseUser;
  User _user;
  User get user {
    return _user;
  }

  set user(value) {
    _user = value;
  }

  // final _googleSignIn = GoogleSignIn();
  // final _facebookLogin = FacebookLogin();
  Auth() {
    currentUser().then((uservalue) {
      if (uservalue != null) {
        user = uservalue;
      }
    }).catchError((onError) {
      var ss;
    });
  }
  @override
  Stream<FirebaseUser> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged.map((FirebaseUser user) {
      firebaseUser = user;
      return user;
    });
  }

  @override
  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    return (await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user
        .uid;
  }

  @override
  Future<FirebaseUser> currentFirebaseUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  @override
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    return (await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user
        .uid;
  }

  // @override
  // Future<String> signInWithFacebook() async {
  //   final loginResult = await _facebookLogin.logIn(['email']);

  //   final AuthCredential credential = FacebookAuthProvider.getCredential(
  //     accessToken: loginResult.accessToken.token,
  //   );
  //   return (await _firebaseAuth.signInWithCredential(credential)).user.uid;
  // }

  // @override
  // Future<String> signInWithGoogle() async {
  //   final GoogleSignInAccount account = await _googleSignIn.signIn();
  //   final GoogleSignInAuthentication _auth = await account.authentication;
  //   final AuthCredential credential = GoogleAuthProvider.getCredential(
  //     accessToken: _auth.accessToken,
  //     idToken: _auth.idToken,
  //   );
  //   return (await _firebaseAuth.signInWithCredential(credential)).user.uid;
  // }

  @override
  Future<void> signOut() async {
    var result = await _firebaseAuth.signOut();
    _currentUser = null;
    _user = null;
    return result;
  }

  @override
  Future<User> currentUser() async {
    if (_currentUser != null) {
      return _currentUser;
    }

    FirebaseUser firebaseUser = await currentFirebaseUser();
    String id = firebaseUser?.uid;
    return await UserController.getUser(id);
  }

  @override
  Future<void> refreshUserData({String userid}) async {
    Completer completer = Completer();
    String uid = userid ?? (await currentFirebaseUser()).uid;
    _currentUser = UserController.getUser(uid);
    user = await _currentUser;
    completer.complete();
    return completer.future;
  }

  Future<void> verifyPhoneNumber({
    String phone,
    Function(AuthCredential) verificationCompleted,
    Function(AuthException) verificationFailed,
    Function(String, [int]) codeSent,
    Function(String) codeAutoRetrievalTimeout,
  }) async {
    return _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 120),
        verificationCompleted: (AuthCredential authCredential) {
          _authCredential = authCredential;
          verificationCompleted(authCredential);
        },
        verificationFailed: (AuthException authException) {
          verificationFailed(authException);
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          this.actualCode = verificationId;
          codeSent(verificationId, forceResendingToken);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          this.actualCode = verificationId;
          codeAutoRetrievalTimeout(verificationId);
        });
  }

  AuthCredential _authCredential;
  String actualCode;
  Future<AuthResult> signInWithPhoneNumber(String smsCode) async {
    _authCredential = PhoneAuthProvider.getCredential(
        verificationId: actualCode, smsCode: smsCode);
    return await _firebaseAuth.signInWithCredential(_authCredential);
  }

  Future<AuthResult> signInWithCredential(AuthCredential authCredential) async {
    return await _firebaseAuth.signInWithCredential(authCredential);
  }
}
