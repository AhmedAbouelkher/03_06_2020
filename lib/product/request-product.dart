import 'package:firebase_database/firebase_database.dart';
import 'package:haftaa/product/base-product.dart';

class RequestProduct extends BaseProduct {
  double _price;
  double get price => _price;

  RequestProduct.fromMap(dynamic key, Map mapedData)
      : super.fromMap(key, mapedData) {
    if (mapedData['options'] != null) {
      _price = double.parse(mapedData['options']['price'].toString());
    }
  }

  RequestProduct.fromSnapshot(DataSnapshot snapshot)
      : super.fromSnapshot(snapshot) {
    if (snapshot.value['options'] != null) {
      _price = double.parse(snapshot.value['options']['price'].toString());
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> optionsContent = {'price': price};
    Map<String, dynamic> productJson = super.toJson();
    productJson['options'] = optionsContent;

    return productJson;
  }
}
