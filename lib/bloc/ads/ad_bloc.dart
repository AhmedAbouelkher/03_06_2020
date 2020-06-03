import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haftaa/entities/ad_entity.dart';
import 'package:haftaa/models/ad_model.dart';
import 'package:haftaa/repositories/product-repository.dart';
import 'package:haftaa/search/search.dart';

import 'ad_event.dart';
import 'ad_state.dart';

class AdBloc extends Bloc<ProductEvent, AdState> {
  ProductRepository _productRepo;
  StreamSubscription _productSubscription;

  AdBloc(ProductRepository productsRepository)
      : assert(productsRepository != null) {
    _productRepo = productsRepository;
  }

  @override
  AdState get initialState => ProductInitilizeState(List<AdModel>());

  @override
  Stream<AdState> mapEventToState(ProductEvent event) async* {
    if (event is GetProductsEvent) {
      yield* _mapLoadProductsEventToState();
    } else if (event is NewAdComeFromDb) {
      //add to state list
      state.ads.add(AdModel.fromEntity(event.ad));

      yield AdsUpdated(state.ads);
    } else if (event is ProductsUpdated) {
      yield* _mapProductUpdatedEventToState(event);
    }
//    else if (event is InsertNewProductEvent) {
//      var product = event.product;
//      _productRepo.addNewProduct(product);
//      yield ProductInsertedState();
//    }else if (event is DeleteProductEvent){
//      yield* _mapProductDeleteEventToState(event);
//    }
  }

  Stream<AdState> _mapProductUpdatedEventToState(
      ProductsUpdated event) async* {
    yield ProductLoadedState(state.ads);
  }

  Stream<AdState> _mapProductDeleteEventToState(
      DeleteProductEvent event) async* {
//    var products = event.products;
//    var search = products.where((productItem)=> productItem.id == event.id).toList();
//    for(var item in search){
//      _productRepo.deleteProduct(item.id);
//      item.deleted = true ;
//    }
    _mapLoadProductsEventToState();
  }

  Stream<AdState> _mapLoadProductsEventToState() async* {
    _productSubscription?.cancel();
    _productSubscription = _productRepo.getAds().listen((ad) {
      var adEntity = AdEntity.fromSnapshot(ad.snapshot);
      //add(ProductsUpdated(products.where((product) => product.deleted != true).toList()));

      add(NewAdComeFromDb(adEntity));
      var sss;
    });
    yield ProductLoadingStarted(state.ads);
  }



  @override
  Future<void> close() {
    _productSubscription?.cancel();
    return super.close();
  }
}
