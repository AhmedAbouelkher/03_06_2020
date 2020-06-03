import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:haftaa/Contracts/Disposable.dart';
import 'package:haftaa/data/product-repository.dart';
import 'package:haftaa/product/auction-product.dart';
import 'package:haftaa/product/base-product.dart';
import 'package:haftaa/product/request-product.dart';
import 'package:haftaa/product/sale-product.dart';
import 'package:haftaa/search/search.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc implements Disposable {
  List<BaseProduct> productList = List<BaseProduct>();
//product list observable subject
  BehaviorSubject<List<BaseProduct>> _subjectProducts;
  BehaviorSubject<List<BaseProduct>> get productsObservable =>
      _subjectProducts.stream;
//product observable subject
  BehaviorSubject<BaseProduct> _subjectProduct = BehaviorSubject<BaseProduct>();

  final _productRepositoy = ProductRepository();

  ProductSearchModel searchModel;
  int startLoadingWithCount;
  ProductBloc({this.searchModel, this.startLoadingWithCount}) {
    //products obervable subject
    _subjectProducts =
    new BehaviorSubject<List<BaseProduct>>.seeded(productList);
    //product observable subject
    _subjectProduct.stream.listen(_onProductObjectAdded);

//start loading
    startLoading(startLoadingWithCount ?? 2);
  }
  bool _isItemMatchedToSearch(BaseProduct product) {
    if (searchModel == null) {
      return true;
    }

    if (searchModel.categoryID != null) {
      if (searchModel.categoryID != product.categoryId) {
        return false;
      }
    }

    if (searchModel.governorateID != null) {
      if (searchModel.governorateID != product.governorateId) {
        return false;
      }
    }

    if (searchModel.productType != null) {
      if (searchModel.productType != product.type.toString().split('.')[1]) {
        return false;
      }
    }

    if (searchModel.usedProducts != null) {
      if (searchModel.usedProducts != product.used) {
        return false;
      }
    }

    if (searchModel.title != null && searchModel.title.trim().isNotEmpty) {
      if (!product.title.contains(searchModel.title) &&
          !product.description.contains(searchModel.title)) {
        return false;
      }
    }

    return true;
  }

  Stream<Event> _onProductChildAddedStream;
  Stream<Event> _onProductChildUpdatedStream;
  startLoading(int limit) async {
    _onProductChildAddedStream =
        _productRepositoy.getProducts(limit, searchModel);
    //_onProductChildUpdatedStream = searchQuery.onChildChanged;

    _onProductChildAddedStream.listen(_onProductChildAdded);
    _onProductChildUpdatedStream.listen(_onProductUpdated);
  }

  _onProductObjectAdded(BaseProduct product) {
    if (productList.contains(product)) {
      return;
    }
    if (!_isItemMatchedToSearch(product)) {
      return;
    }
    productList.add(product);
    _subjectProducts.sink.add(productList);
  }

  bool gettingMorePorducts = false;
  BaseProduct _lastProduct;
  loadMoreProducts(int limit) async {
    gettingMorePorducts = true;
    _subjectProduct.close();
    //_subjectProduct.stream.listen(_onProductObjectAdded);

    await _subjectProduct.last.then((product) {
      _lastProduct = product;
      gettingMorePorducts = false;
      _onProductChildAddedStream =
          _productRepositoy.getMoreProducts(limit, product.title, searchModel);
      _onProductChildAddedStream.listen(_onProductChildAdded);
    });
    _subjectProduct.stream.listen(_onProductObjectAdded);
  }

  _onProductChildAdded(Event event) async {
    if ((_lastProduct != null && _lastProduct.id == event.snapshot.key)) {
      return;
    }

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
        default:
          product = BaseProduct.fromSnapshot(event.snapshot);
          break;
      }
    }
    if (product != null) {
      _subjectProduct.sink.add(product);
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
  }

  @override
  dispose() {
    _subjectProducts.drain();
    _subjectProducts.close();
  }
}
