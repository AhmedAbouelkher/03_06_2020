import 'package:haftaa/product/base-product.dart';


abstract class BaseCartItem{
   BaseProduct product;
   //عدد الوحدات الي اشتراه الزبون
   double quantity;

   BaseCartItem(this.product,this.quantity);
}