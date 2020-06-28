import 'dart:async';

import 'package:haftaa/Category/BaseCategory.dart';
import 'package:haftaa/Category/CategoryController.dart';
import 'package:haftaa/Enums/enums.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:haftaa/governorate/governorate.dart';
import 'package:haftaa/governorate/governorateController.dart';
import 'package:haftaa/product/product-provider.dart';
import 'package:haftaa/region/region-controller.dart';
import 'package:haftaa/region/region.dart';
import 'package:haftaa/user/user-controller.dart';
import 'package:haftaa/user/user.dart';
import 'package:intl/intl.dart';

class BaseProduct {
  BaseProduct();

  String _id;
  String _userId;
  Future<User> _user;
  bool _used;
  DateTime _updateDate;
  ItemType _type;
  String _title;
  String _regionId;
  Future<Region> _region;
  String _mainImage;
  String _governorateId;
  String _description;
  DateTime _creationDate;
  String _categoryId;
  Future<BaseCategory> _category;
  bool _available;
  Future<Governorate> _governorate;
  List<String> _images = [];
  Map<dynamic, dynamic> _favUsers = Map();
  bool _displayInMobileHome = false;
  bool _showMobileNumber = true;


  bool get showMobileNumber => _showMobileNumber;

  set showMobileNumber(bool value) {
    _showMobileNumber = value;
  }

  BaseProduct.map(dynamic obj) {
    this._id = obj['id'];
    this._title = obj['title'];
    this._description = obj['description'];
  }

  String get id => _id;

  set id(value) {
    _id = value;
  }

  String get userId => _userId;

  set userId(value) {
    _userId = value;
  }

  bool get used => _used;

  set used(value) {
    _used = value;
  }

  bool get displayInMobileHome => _displayInMobileHome;

  set displayInMobileHome(value) {
    _displayInMobileHome = value;
  }

  DateTime get updateDate => _updateDate;

  set updateDate(value) {
    _updateDate = value;
  }

  ItemType get type => _type;

  set type(value) {
    _type = value;
  }

  String get title => _title;

  set title(value) {
    _title = value;
  }

  Map<dynamic, dynamic> get favUsers => _favUsers;

  set favUsers(value) {
    _favUsers = value;
  }

  Future<Region> get region {
    if (_region != null) {
      return _region;
    }
    if (regionId != null) {
      return RegionController.getRegion(regionId);
    }
    return null;
  }

  set region(Future<Region> value) {
    _region = value;
  }

  Future<User> get user {
    if (_user != null) {
      return _user;
    }
    if (userId != null) {
      return UserController.getUser(userId);
    }
    return null;
  }

  String get mainImage => _mainImage;

  set mainImage(value) {
    _mainImage = value;
  }

  String get governorateId => _governorateId;

  set governorateId(value) {
    _governorateId = value;
  }

  String get description => _description;

  set description(value) {
    _description = value;
  }

  String descriptionSubString(int lenght) {
    return description.substring(
        0, (description.length > lenght ? lenght : description.length));
  }

  DateTime get creationDate => _creationDate;

  set creationDate(value) {
    _creationDate = value;
  }

  String get categoryId => _categoryId;

  set categoryId(value) {
    _categoryId = value;
  }

  String get regionId => _regionId;

  set regionId(value) {
    _regionId = value;
  }

  String get arabicTypeName {
    if (_type != null) {
      switch (_type) {
        case ItemType.sale:
          return 'للبيع';
          break;
        case ItemType.request:
          return 'للشراء';
          break;
        case ItemType.auction:
          return 'مزاد';
          break;
        default:
      }
    }
    return null;
  }

  Future<BaseCategory> get category {
    if (_category != null) {
      return _category;
    }
    if (categoryId != null) {
      return CategoryController.getCategory(categoryId);
    }
    return null;
  }

  set category(Future<BaseCategory> value) {
    _category = value;
  }

  bool get available => _available;

  set available(value) {
    _available = value;
  }

  String get formatedCreateDate => creationDate == null
      ? ''
      : new DateFormat('yyyy-M-dd a HH:mm').format(creationDate);

  Future<Governorate> get governorate {
    Completer<Governorate> completer = new Completer<Governorate>();
    if (_governorate != null) {
      completer.complete(_governorate);
    }
    if (governorateId != null) {
      GovernorateController.getGovernorate(governorateId).then((governorate_) {
        completer.complete(governorate_);
      });
    }
    return completer.future;
  }

  set governorate(Future<Governorate> value) {
    _governorate = value;
  }

  List<String> get images => _images;

  set images(value) {
    _images = value;
  }

  BaseProduct.fromMap(dynamic key, Map mapedData) {
    this._id = key;

    _userId = mapedData['userId'] == null ? '' : mapedData['userId'];
    _used = mapedData['used'];

    try {
      _updateDate = mapedData['updateDate'] == null
          ? null
          : DateTime.parse(mapedData['updateDate']);
    } catch (e) {
      _updateDate = null;
    }

    switch (mapedData['type']) {
      case 'sale':
        _type = ItemType.sale;
        break;
      case 'request':
        _type = ItemType.request;
        break;
      case 'auction':
        _type = ItemType.auction;
        break;
    }

    _title = mapedData['title'] == null ? '' : mapedData['title'];

    //todo: make image local
    _mainImage = mapedData['mainImage'];
    // == null
    //     ? 'http://endpointworks.com/content/images/2018/10/Registry_Editor_icon.png'
    //     : mapedData['mainImage'];

    _governorateId =
        mapedData['governorateId'] == null ? '' : mapedData['governorateId'];

    _regionId = mapedData['regionID'] == null ? '' : mapedData['regionID'];

    _description =
        mapedData['description'] == null ? '' : mapedData['description'];

    try {
      _creationDate = DateTime.parse(mapedData['creationDate']);
    } catch (e) {
      _creationDate = null;
    }

    _categoryId =
        mapedData['categoryId'] == null ? '-' : mapedData['categoryId'];

    if (mapedData['images'] != null) {
      for (final image in mapedData['images']) {
        print(image);
        _images.add(image);
      }
    }
    if (mapedData['favUsers'] != null) {
      _favUsers = mapedData['favUsers'];
    }

    _available = mapedData['available'];
    _displayInMobileHome = mapedData['displayInMobileHome'];
    _showMobileNumber = mapedData['showMobileNumber'];


  }

  BaseProduct.fromSnapshot(DataSnapshot snapshot) {
    //print('emoo:' + snapshot.value['title']);

    _id = snapshot.key;
    _userId = snapshot.value['userId'] == null ? '' : snapshot.value['userId'];
    _used = snapshot.value['used'];

    try {
      _updateDate = snapshot.value['updateDate'] == null
          ? null
          : DateTime.parse(snapshot.value['updateDate']);
    } catch (e) {
      _updateDate = null;
    }

    switch (snapshot.value['type']) {
      case 'sale':
        _type = ItemType.sale;
        break;
      case 'request':
        _type = ItemType.request;
        break;
      case 'auction':
        _type = ItemType.auction;
        break;
    }

    _title = snapshot.value['title'] == null ? '' : snapshot.value['title'];

    //todo: make image local
    _mainImage = snapshot.value['mainImage'] == null
        ? 'http://endpointworks.com/content/images/2018/10/Registry_Editor_icon.png'
        : snapshot.value['mainImage'];

    _governorateId = snapshot.value['governorateId'] == null
        ? ''
        : snapshot.value['governorateId'];

    _regionId =
        snapshot.value['regionID'] == null ? '' : snapshot.value['regionID'];

    _description = snapshot.value['description'] == null
        ? ''
        : snapshot.value['description'];

    try {
      _creationDate = snapshot.value['creationDate'] == null
          ? null
          : DateTime.parse(snapshot.value['creationDate']);
    } catch (e) {
      _creationDate = null;
    }

    _categoryId = snapshot.value['categoryId'] == null
        ? '-'
        : snapshot.value['categoryId'];

    if (snapshot.value['images'] != null) {
      for (final image in snapshot.value['images']) {
        print(image);
        _images.add(image);
      }
    }

    if (snapshot.value['favUsers'] != null) {
      _favUsers = snapshot.value['favUsers'];
    }

    _available = snapshot.value['available'];
    _displayInMobileHome = snapshot.value['displayInMobileHome'] ?? false;
    _showMobileNumber = snapshot.value['showMobileNumber'] ?? false;

  }

  Map<String, dynamic> toJson() {
    return {
      'available': available,
      'categoryId': categoryId,
      'creationDate': creationDate == null ? null : creationDate.toString(),
      'description': description,
      'governorateId': governorateId,
      //'images': images,
      'regionID': regionId,
      'title': title,
      'type': type.toString().split('.')[1],
      'updateDate': updateDate == null ? null : updateDate.toString(),
      'used': used,
      'userId': userId,
      'used': used,
      'displayInMobileHome': displayInMobileHome,
      'showMobileNumber': showMobileNumber,

    };
  }
  Future<DataSnapshot>  getProductComments(String id) {
    return new ProductProvider().getProductComments(id);
  }
}
