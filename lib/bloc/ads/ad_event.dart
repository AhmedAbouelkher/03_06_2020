import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:haftaa/entities/ad_entity.dart';
import 'package:haftaa/models/ad_model.dart';

abstract class ProductEvent extends Equatable {}

class GetProductsEvent extends ProductEvent {
  @override
  List<Object> get props => [];
}

class NewAdComeFromDb extends ProductEvent {
  final AdEntity ad;

  NewAdComeFromDb(this.ad);

  List<Object> get props => [ad];
}

class InsertNewProductEvent extends ProductEvent {
  AdModel product;

  InsertNewProductEvent({@required this.product}) : assert(product != null);

  @override
  List<Object> get props => [product];
}

class DeleteProductEvent extends ProductEvent {
  final List<AdModel> products;

  final String id;

  DeleteProductEvent({this.products, this.id});

  @override
  List<Object> get props => [id, products];
}

class ProductsUpdated extends ProductEvent {
  List<AdModel> products;

  ProductsUpdated(this.products);

  @override
  List<Object> get props => [
        products,
      ];
}
