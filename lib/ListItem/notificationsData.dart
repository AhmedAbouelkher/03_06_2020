
class NotificationModel {

  String senderPhone;
  String text;
  String time;
  String chatID;
  String productID;
  String productTitle;
  String title;


  NotificationModel(this.senderPhone, this.text, this.time, this.chatID, this.productID, this.productTitle, this.title);

  factory NotificationModel.fromJson(Map<dynamic, dynamic> json) {
    return NotificationModel(
      json['senderPhone'],
      json['text'],
      json['time'].toString(),
      json['chatID'],
      json['productID'],
      json['productTitle'],
      json['title'].toString(),

    );
  }












}
