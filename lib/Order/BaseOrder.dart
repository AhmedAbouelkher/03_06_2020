import 'package:haftaa/Cart/BaseCart.dart';
import 'package:haftaa/Payment/BasePatment.dart';
import 'package:haftaa/user/customer.dart';

abstract class BaseOrder {
  BaseCart cart;
  Customer customer;
  BasePayment basePayment;

  BaseOrder(this.cart, this.customer,this.basePayment);

  BaseOrder.fromJson(Map<String, dynamic> jsonObject) {
    this.cart =  jsonObject['cart'];
  }

  double totalPrice(){}
}
