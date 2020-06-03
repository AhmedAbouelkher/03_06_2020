import 'package:haftaa/Category/BaseCategory.dart';
import 'package:haftaa/governorate/governorate.dart';

class ProductSearchModel {
  ProductSearchModel();
  ProductSearchModel.of();
  String _productTitle;
  String _productUsingStatusInArabic;
  String _productTypeInArabic;
  BaseCategory _category;
  String _categoryId="2321312323";
  Governorate _governorate;
  String _userID;
  String _userIDWhoMakesFavorite;

  String get title => _productTitle;
  set title(value) {
    _productTitle = value;
  }

  bool get usedProducts {
    if (_productUsingStatusInArabic != null &&
        _productUsingStatusInArabic.isNotEmpty) {
      if (_productUsingStatusInArabic == 'جديد') {
        return false;
      } else if (_productUsingStatusInArabic == 'مستعمل') {
        return true;
      }
    }
    return null;
  }

  String get productType {
    if (_productTypeInArabic != null) {
      switch (_productTypeInArabic) {
        case 'بيع':
          return 'sale';
          break;
        case 'شراء':
          return 'request';
          break;
        case 'مزاد':
          return 'auction';
          break;
        default:
      }
    }
    return null;
  }

  String get categoryID {
    if (_categoryId != null) {
      return _categoryId;
    }

    if (_category != null) {
      return _category.id;
    }
    return null;
  }

  String get governorateID {
    if (_governorate != null) {
      return _governorate.id;
    }
    return null;
  }

  String get userID => _userID;
  String get userIDWhoMakesFavorite => _userIDWhoMakesFavorite;
  ProductSearchModel.FromSearchParams(
      {productTitle,
      productUsingStatus,
      productTypeInArabic,
      category,
      categoryId,
      governorate,
      userID,
      userIDWhoMakesFavorite}) {
    this._productTitle = productTitle;
    this._productUsingStatusInArabic = productUsingStatus;
    this._productTypeInArabic = productTypeInArabic;
    this._category = category;
    this._governorate = governorate;
    this._userID = userID;
    this._categoryId = categoryId;
    this._userIDWhoMakesFavorite = userIDWhoMakesFavorite;
  }
}
