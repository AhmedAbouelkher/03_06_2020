import 'package:haftaa/Cart/BaseCartItem.dart';

abstract class BaseCart{

  List<BaseCartItem> cartItems;

  BaseCart(this.cartItems);
}