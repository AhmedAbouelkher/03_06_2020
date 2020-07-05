import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:haftaa/Contracts/Disposable.dart';
import 'package:haftaa/product/base-product.dart';
import 'package:haftaa/user/user.dart';

class UserController extends Disposable {
  @override
  dispose() {}

  static final userReference =
      FirebaseDatabase.instance.reference().child('users');

  //User user;
  UserController();

  static Future<User> getUser(String userId) async {
    Completer<User> completer = Completer<User>();
    User _user = User();
    _user.id = userId;
    await FirebaseDatabase.instance
        .reference()
        .child('users/${userId}')
        .once()
        .then((DataSnapshot snapshot) {
      _user = User.fromSnapshot(snapshot);
      completer.complete(_user);
    }).catchError((onError) {
      completer.complete(_user);
    });
    return completer.future;
  }

  static bool isProductExistsInUserFavList(String productID, User user) {
    bool isProductExistsInUserFav = false;
    if (user == null || user.favourits == null) {
      return false;
    }
    Map favourits = user.favourits as Map;

    favourits.forEach((key, mapItem) {
      if (mapItem['productID'] == productID) {
        isProductExistsInUserFav = true;
      }
    });

    return isProductExistsInUserFav;
  }

  static String getFavID(String productID, User user) {
    String favID;
    if (user == null || user.favourits == null) {
      return null;
    }
    Map favourits = user.favourits as Map;
    favourits.forEach((key, mapItem) {
      if (mapItem['productID'] == productID) {
        favID = key;
      }
    });

    return favID;
  }

  Future<void> addUserIDToProductFav(String productID, String userID) async {
    return FirebaseDatabase.instance
        .reference()
        .update({'/menuItems/${productID}/favUsers/${userID}': true});
  }

  Future<void> removeUserFromProductFav(String productID, String userID) async {
    return FirebaseDatabase.instance
        .reference()
        .child('/menuItems/${productID}/favUsers/${userID}/')
        .remove();
  }

  static List<User> toUsers(List<Map<String, dynamic>> jsonObjects) {}

  Future<void> updateProfilePhoto(FirebaseUser user, String photoURL) async {
    UserUpdateInfo userUpdateInfo = UserUpdateInfo();

    userUpdateInfo.photoUrl = photoURL;

    return await user.updateProfile(userUpdateInfo);
  }

  Future<void> updateProfile(FirebaseUser user, {name}) async {
    UserUpdateInfo userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = name ?? '';
    return await user.updateProfile(userUpdateInfo);
  }
}
