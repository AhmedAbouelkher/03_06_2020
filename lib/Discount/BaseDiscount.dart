

import 'package:haftaa/product/base-product.dart';

abstract class BaseDiscount {
  BaseProduct product;
  double min_quantity;
  double max_quantity;
  double price;
  double priceAfterDiscount;
  BaseDiscount(this.product, this.min_quantity, this.max_quantity, this.price,
      this.priceAfterDiscount);
}
