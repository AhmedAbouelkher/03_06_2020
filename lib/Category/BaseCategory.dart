import 'package:firebase_database/firebase_database.dart';

class BaseCategory {
  String _id;
  String _title;
  String _img;
  String _description;
  String _icon;
  int _itemsCount;
  BaseCategory parentCategory;
  Map defaultItems;



  String get id => _id;
  String get title => _title;
  String get img => _img;
  String get description => _description;
  String get icon => _icon;
  int get itemsCount => _itemsCount;

  BaseCategory();

  // BaseCategory.fromSnapshot(String key, Map<dynamic, dynamic> snapshot) {
  //   this._id = key;
  //   this._title = snapshot['title'];
  //   this._img = snapshot['thumb'];
  //   this._description = snapshot['description'];
  // }
  BaseCategory.fromMap(dynamic key, Map mapedData) {
    this._id = key;
    this._title = mapedData['title'];
    this._img = mapedData['thumb'];
    this._description = mapedData['description'];
    this._icon = mapedData['icon'];
    this._itemsCount = mapedData['itemsCount'];

     this.defaultItems = mapedData['defaultItems'] as Map ;

  }
  BaseCategory.fromSnapshot(DataSnapshot snapshot) {
    this._id = snapshot.key;
    this._title = snapshot.value['title'];
    this._img = snapshot.value['thumb'];
    this._description = snapshot.value['description'];
    this._icon = snapshot.value['icon'];
    this._itemsCount = snapshot.value['itemsCount'];
    this.defaultItems = snapshot.value['defaultItems'];

  }
}
