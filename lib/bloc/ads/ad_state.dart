import 'package:equatable/equatable.dart';
import 'package:haftaa/core/enums.dart';
import 'package:haftaa/entities/ad_entity.dart';
import 'package:haftaa/models/ad_model.dart';
import 'package:haftaa/search/search.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AdState extends Equatable {
  final List<AdModel> ads;

  const AdState(this.ads);

  List<AdModel> filterList(ProductSearchModel productSearchModel) {
    return ads.where((ad) {
      return (productSearchModel.title?.toLowerCase() == null
          ? false
          : ad.title
                  .toLowerCase()
                  .contains(productSearchModel.title.toLowerCase()) &&
              (productSearchModel.categoryID == null
                  ? true
                  : ad.categoryId == productSearchModel.categoryID) &&
              (productSearchModel.governorateID == null
                  ? true
                  : ad.governorateId == productSearchModel.governorateID) &&
              (productSearchModel.productType == null
                  ? true
                  : ad.type == productSearchModel.productType) &&
              (productSearchModel.usedProducts == null
                  ? true
                  : ad.used == productSearchModel.usedProducts) &&
              (productSearchModel.userID == null
                  ? true
                  : ad.userId == productSearchModel.userID) &&
              (productSearchModel.userIDWhoMakesFavorite == null
                  ? true
                  : ad.favUsers.containsKey(ad.userId)));
    }).toList();
  }

  SortList(SortingType sortingType, List<AdModel> list) {
    switch (sortingType) {
      case SortingType.latest:
        list.sort((a, b) {
          return a.creationDate.compareTo(b.creationDate);
        });
        break;
      case SortingType.lowPrice:
        list.sort((a, b) {
          return (b.options.price ?? 0).compareTo(a.options.price ?? 0);
        });
        break;
      case SortingType.hightPrice:
        list.sort((a, b) {
          return (a.options.price ?? 0).compareTo(b.options.price ?? 0);
        });
        break;
      case SortingType.charcter:
        list.sort((a, b) {
          return a.title.compareTo(b.title);
        });
        break;
    }
  }

  @override
  List<Object> get props => [ads];
}

class AdsUpdated extends AdState {
  AdsUpdated(List<AdModel> ads) : super(ads);

  @override
  List<Object> get props => [ads];
}

class ProductInitilizeState extends AdState {
  ProductInitilizeState(List<AdModel> ads) : super(ads);

  @override
  List<Object> get props => [ads];

  @override
  String toString() => 'weather init';
}

class ProductLoadingState extends AdState {
  ProductLoadingState(List<AdModel> ads) : super(ads);

  @override
  List<Object> get props => [ads];

  @override
  String toString() => 'weather loading';
}

class ProductLoadedState extends AdState {
  ProductLoadedState(List<AdModel> ads) : super(ads);

  @override
  List<Object> get props => [ads];
}

class ProductLoadingStarted extends AdState {
  ProductLoadingStarted(List<AdModel> ads) : super(ads);

  @override
  List<Object> get props => [];

  @override
  String toString() => 'product loading started ..';
}

class ProductNotLoadedState extends AdState {
  ProductNotLoadedState(List<AdModel> ads) : super(ads);

  @override
  List<Object> get props => [];

  @override
  String toString() => 'weather not loaded';
}

class ProductInsertedState extends AdState {
  ProductInsertedState(List<AdModel> ads) : super(ads);

  @override
  List<Object> get props => [];

  @override
  String toString() => 'weather inserted';
}
