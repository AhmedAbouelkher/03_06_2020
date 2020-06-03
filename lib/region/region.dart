import 'package:firebase_database/firebase_database.dart';

class Region {
  String _id;
  String _title;
  String _mapCoordinates;

  String get Id => _id;
  String get title => _title;
  String get mapCoordinates => _mapCoordinates;

  Region.fromMap(dynamic key, Map regionMap) {
    this._id = key;
    this._title = regionMap['title'];
    this._mapCoordinates = regionMap['mapCoordinates'];
  }
  Region.fromSnapshot(DataSnapshot regiondata) {
    this._id = regiondata.key;
    this._title = regiondata.value['title'];
    this._mapCoordinates = regiondata.value['mapCoordinates'];
  }
}
