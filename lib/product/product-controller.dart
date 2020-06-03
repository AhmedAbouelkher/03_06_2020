import 'package:firebase_database/firebase_database.dart';

import 'package:haftaa/Contracts/Disposable.dart';
import 'package:haftaa/Enums/enums.dart';
import 'package:haftaa/product/auction-product.dart';
import 'package:haftaa/product/base-product.dart';
import 'package:haftaa/product/request-product.dart';
import 'package:haftaa/product/sale-product.dart';

import 'package:haftaa/search/search.dart';
import 'dart:async';

import 'package:haftaa/services/firebase-service.dart' as FirebaseService2;

class ProductController implements Disposable {
  List<BaseProduct> productList = List<BaseProduct>();
  StreamController<List<BaseProduct>> _productsStreamController =
  StreamController<List<BaseProduct>>();

  Stream<List<BaseProduct>> get productListStream =>
      _productsStreamController.stream;

  StreamSink<List<BaseProduct>> get productListSink =>
      _productsStreamController.sink;

  List<BaseProduct> products = new List();
  ProductSearchModel searchModel;
//firebase reference
  static final _productsReference =
  FirebaseDatabase.instance.reference().child('menuItems');
//Stream Subscription

  ProductController() {
    _productsStreamController.add(productList);
    //attach add product fuction to subscription event
    //_productsQuery = _productsReference.orderByKey();
  }
  ProductController.getParameters({this.searchModel}) {
    _productsStreamController.add(productList);
    loadProducts();
  }

  addProductToFirebase(String title) {
    FirebaseService2.FirebaseService firebaseService1 =
    FirebaseService2.FirebaseService();
    firebaseService1.createItem(
        FirebaseDBCollections.news.toString(), {'title': title, 'desc': ''});

    // FirebaseService firedb = FirebaseService();
    // firedb.addItem('1', {'title': title, 'desc': ''});
  }

  delete() {}
  create() {}
  Future<void> update(BaseProduct product) {
    Completer<String> completer = Completer<String>();
    FirebaseDatabase.instance
        .reference()
        .child('menuItems')
        .child(product.id)
        .update(product.toJson())
        .then((onValue) {
      completer.complete();
    });

    return completer.future;
  }

  getProduct() {}
  Future<String> addProduct(BaseProduct product) {
    Completer<String> completer = Completer<String>();
    var productref =
    FirebaseDatabase.instance.reference().child('menuItems').push();

    productref.set(product.toJson()).then((onValue) {
      completer.complete(productref.key);
    });

    return completer.future;
  }

  Future<void> updateproductImages(String productID, List<String> images) {
    Map<String, dynamic> imagesmap = Map<String, dynamic>();
    for (var i = 0; i < images.length; i++) {
      imagesmap['${i}'] = images[i];
    }
    return FirebaseDatabase.instance
        .reference()
        .child('menuItems')
        .child(productID)
        .child('images')
        .set(imagesmap);
  }

  Future<void> updateProductMainImage(String productID, String mainImageURL) {
    return FirebaseDatabase.instance
        .reference()
        .update({'/menuItems/${productID}/mainImage': mainImageURL});
  }

  List<BaseProduct> getProducts() {
    FirebaseService2.FirebaseService firebaseService1 =
    FirebaseService2.FirebaseService();
    firebaseService1
        .getItems(FirebaseDBCollections.menuItems.toString())
        .then((DataSnapshot datasnapshot) {
      Map<dynamic, dynamic> values = datasnapshot.value;
      values.forEach((key, values) {
        // products.add(Product(values["title"], values["title"], values["title"],
        //     values["title"], values["title"], null, null, null));
        print(values["title"]);
      });

      return products;
    });
    return null;
  }

  @override
  dispose() {
    _productsStreamController.close();
  }

  //Query _productsQuery; //= _productsReference.orderByKey();
  BaseProduct category;

  Query _handleQuery(ProductSearchModel searchModel) {
    Query searchQuery;
    searchQuery = FirebaseDatabase.instance.reference().child('menuItems');

    if (searchModel.usedProducts != null) {
      searchQuery =
          searchQuery.orderByChild('used').equalTo(searchModel.usedProducts);
    }
    if (searchModel.title != null && searchModel.title.isNotEmpty) {
      searchQuery =
          searchQuery.orderByChild('title').startAt(searchModel.title);
    }

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
    return searchQuery;
  }

  Future<List<BaseProduct>> search(ProductSearchModel searchModel) async {
    var completer = new Completer<List<BaseProduct>>();
    List<BaseProduct> products = new List();
    BaseProduct product;
    Query searchQuery;
    if (searchModel != null)
      searchQuery = _handleQuery(searchModel);
    else
      searchQuery = FirebaseDatabase.instance.reference().child('menuItems');

    searchQuery.once().then((snapshot) {
      if (snapshot.value != null) {
        Map mapped = snapshot.value;
        products = mapped.entries.map<BaseProduct>((mapItem) {
          switch (mapItem.value['type']) {
            case 'sale':
              product = SaleProduct.fromMap(mapItem.key, mapItem.value);
              break;
            case 'request':
              product = RequestProduct.fromMap(mapItem.key, mapItem.value);
              break;
            case 'auction':
              product = AuctionProduct.fromMap(mapItem.key, mapItem.value);
              break;
          }
          return product;
        }).toList();
      }

      completer.complete(products);
    }).catchError((onError) {
      completer.complete(onError);
    });

    return completer.future;
  }

  Stream<Event> _onProductChildAddedStream;
  Stream<Event> _onProductChildUpdatedStream;
  Future<List<BaseProduct>> loadProducts() async {
    Completer completer = new Completer<List<BaseProduct>>();

    Query searchQuery;
    if (searchModel != null)
      searchQuery = _handleQuery(searchModel);
    else
      searchQuery = FirebaseDatabase.instance.reference().child('menuItems');

    _onProductChildAddedStream = searchQuery.onChildAdded;
    _onProductChildUpdatedStream = searchQuery.onChildChanged;

    _onProductChildAddedStream.listen(onProductChildAdded);
    _onProductChildUpdatedStream.listen(_onProductUpdated);


  }

  onProductChildAdded(Event event) async {
    BaseProduct product;
    if (event.snapshot.value['type'] != null) {
      switch (event.snapshot.value['type']) {
        case 'sale':
          product = SaleProduct.fromSnapshot(event.snapshot);
          break;
        case 'request':
          product = RequestProduct.fromSnapshot(event.snapshot);
          break;
        case 'auction':
          product = AuctionProduct.fromSnapshot(event.snapshot);
          break;
      }
    }
    if (product != null) {
      productList.add(product);
      productListSink.add(productList);
    }
  }

  void _onProductUpdated(Event event) {
    var oldProductValue =
    productList.singleWhere((product) => product.id == event.snapshot.key);

    //todo:make it dynamic enum switcher
    switch (event.snapshot.value['type']) {
      case 'sale':
        productList[productList.indexOf(oldProductValue)] =
        new SaleProduct.fromSnapshot(event.snapshot);

        break;
      case 'request':
        productList[productList.indexOf(oldProductValue)] =
        new RequestProduct.fromSnapshot(event.snapshot);

        break;
      case 'auction':
        productList[productList.indexOf(oldProductValue)] =
        new AuctionProduct.fromSnapshot(event.snapshot);

        break;
    }

    //productList.add(product);
    productListSink.add(productList);
  }


}
