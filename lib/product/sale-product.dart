import 'package:firebase_database/firebase_database.dart';
import 'package:haftaa/product/base-product.dart';

class
SaleProduct extends BaseProduct {
  double _price;
  double get price => _price;

  SaleProduct.fromMap(dynamic key, Map mapedData)
      : super.fromMap(key, mapedData) {
    if (mapedData['options'] != null && mapedData['options']['price'] != null) {
      _price = double.parse(mapedData['options']['price'].toString());
    }
  }

  SaleProduct.fromSnapshot(DataSnapshot snapshot)
      : super.fromSnapshot(snapshot) {
    if (snapshot.value['options'] != null && snapshot.value['options']['price'] != null) {
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
