import 'package:haftaa/core/enums.dart';

abstract class IAPIService {
  getItem(String collectionName);
  getItems(String collectionName);
  createItem(String collectionName, dynamic dataObject);
  createItems();
  removeItem();
  removeItems();
}
