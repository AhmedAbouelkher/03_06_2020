abstract class BasePayment{

String paymentID;
double amount;
DateTime paymenttime;
String paymentMethod;

  BasePayment();

  BasePayment.fromJson(Map<String,dynamic> jsonObject){
    this.paymentID = jsonObject['paymentID'];
    this.amount = jsonObject['amount'];
    this.paymenttime = jsonObject['paymenttime'];
    this.paymentMethod = jsonObject['paymentMethod'];
  }
}