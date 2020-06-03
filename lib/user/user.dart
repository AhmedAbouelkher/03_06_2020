import 'package:firebase_database/firebase_database.dart';

class User {
  String _id;
  String _name;
  String _email;
  String _age;
  String _mobile;
  String _role;
  var _favourits;
  String get name => _name;

  String get email => _email;

  String get age => _age;

  String get mobile => _mobile;

  String get role => _role;

  String get id => _id;
  set id (value){
    _id = value;
  }
  get favourits => _favourits;
User();
  User.fromSnapshot(DataSnapshot snapshot) {
    this._id = snapshot.key;
    this._name = snapshot.value['name'];
    this._email = snapshot.value['email'];
    this._mobile = snapshot.value['mobileNo'];
    this._role = snapshot.value['role'];
    this._favourits = snapshot.value['favourite'];
  }
}
