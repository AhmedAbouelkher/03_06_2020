import 'package:firebase_database/firebase_database.dart';
import 'package:haftaa/search/search.dart';

class DatabaseProvider {}

class FirebaseProvider implements DatabaseProvider {
  Stream<Event> getProducts(int limit, ProductSearchModel searchModel) {
    if (limit == null || limit < 0) {
      return FirebaseDatabase.instance
          .reference()
          .child('menuItems')
          .orderByChild('title')
          .onChildAdded;
    }
    
    return FirebaseDatabase.instance
        .reference()
        .child('menuItems')
        .orderByChild('title')
        .limitToFirst(limit)
        .onChildAdded;
  }
   Stream<Event> getProductsStreamChange(int limit, ProductSearchModel searchModel) {
    if (limit == null || limit < 0) {
      return FirebaseDatabase.instance
          .reference()
          .child('menuItems')
          .orderByChild('title')
          .onChildChanged;
    }
    
    return FirebaseDatabase.instance
        .reference()
        .child('menuItems')
        .orderByChild('title')
        .limitToFirst(limit)
        .onChildChanged;
  }

  Stream<Event> getMoreProducts(
      int limit, String fromTitle, ProductSearchModel searchModel) {
    return FirebaseDatabase.instance
        .reference()
        .child('menuItems')
        .orderByChild('title')
        .startAt(fromTitle)
        .limitToFirst(limit)
        .onChildAdded;
  }
  Future<DataSnapshot> getHomeSliderProducts(){
 return FirebaseDatabase.instance
        .reference()
        .child('menuItems')
        .orderByChild('displayInMobileHome')
        .equalTo(true)
        .once();
  }

  Query _handleProductQueryRef(ProductSearchModel searchModel, int limit) {
    Query searchQuery =
        FirebaseDatabase.instance.reference().child('menuItems');
    if (searchModel == null) {
      searchQuery = searchQuery.orderByChild('title');
      if (limit != null && limit > 0) {
        searchQuery = searchQuery.limitToFirst(limit);
      }

      return searchQuery;
    }

    if (searchModel.usedProducts != null) {
      searchQuery =
          searchQuery.orderByChild('used').equalTo(searchModel.usedProducts);
    }
    // if (searchModel.title != null && searchModel.title.isNotEmpty) {
    //   searchQuery =
    //       searchQuery.orderByChild('title').startAt(searchModel.title);
    // }

    if (searchModel.productType != null && searchModel.productType.isNotEmpty) {
      searchQuery = searchQuery
          .orderByChild('type')
          .equalTo('${searchModel.productType}');
    }
    if (searchModel.categoryID != null) {
      searchQuery = searchQuery
          .orderByChild('categoryId')
          .equalTo('${searchModel.categoryID}');
    }
    if (searchModel.governorateID != null &&
        searchModel.governorateID.isNotEmpty) {
      searchQuery = searchQuery
          .orderByChild('governorateId')
          .equalTo('${searchModel.governorateID}');
    }
    if (searchModel.userIDWhoMakesFavorite != null) {
      searchQuery = searchQuery
          .orderByChild('favUsers/${searchModel.userIDWhoMakesFavorite}')
          .equalTo(true);
    }

    //check limit
    if (limit != null && limit > 0) {
      searchQuery = searchQuery.limitToFirst(limit);
    }
    return searchQuery;
  }
}
