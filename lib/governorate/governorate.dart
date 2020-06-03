import 'package:firebase_database/firebase_database.dart';

class Governorate {
  String _id;
  String _countryId;
  String _mapCoordinates;
  String _title;
  //todo:implement country object

  String get id => _id;
  String get countryId => _countryId;
  String get title => _title;
  String get mapCoordinates => _mapCoordinates;

  Governorate(this._id, this._countryId, this._mapCoordinates, this._title);

  Governorate.fromMap(dynamic key, Map mapedData) {
    this._id = key;
    this._countryId = mapedData["countryId"];
    this._mapCoordinates = mapedData["mapCoordinates"];
    this._title = mapedData["title"];
  }

  Governorate.fromSnapshot(DataSnapshot snapshot) {
    this._id = snapshot.key;
    this._countryId = snapshot.value["countryId"];
    this._mapCoordinates = snapshot.value["mapCoordinates"];
    this._title = snapshot.value["title"];
  }
}
