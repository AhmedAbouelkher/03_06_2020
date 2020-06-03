import 'package:firebase_database/firebase_database.dart';
import 'package:haftaa/data/firebase-provider.dart';
import 'package:haftaa/search/search.dart';

class ProductRepository {
  final _firebaseProvider = FirebaseProvider();
  Stream<Event> getProducts(int limit, ProductSearchModel serachModel) {
    return _firebaseProvider.getProducts(limit, serachModel);
  }
   Stream<Event> getProductsStreamChange(int limit, ProductSearchModel serachModel) {
    return _firebaseProvider.getProductsStreamChange(limit, serachModel);
  }

  Stream<Event> getMoreProducts(
      int limit, String fromTitle, ProductSearchModel serachModel) {
    return _firebaseProvider.getMoreProducts(limit, fromTitle, serachModel);
  }

  Future<DataSnapshot> getHomeSliderProducts() {
    return _firebaseProvider.getHomeSliderProducts();
  }
}
