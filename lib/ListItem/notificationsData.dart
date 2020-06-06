
class NotificationModel {

  String senderPhone;
  String text;
  String time;
  String chatID;
  String productID;
  String productTitle;
  String title;
  String userpProductID;
  String myID;
  String peerId;


  NotificationModel(
      this.senderPhone,
      this.text,
      this.time,
      this.chatID,
      this.productID,
      this.productTitle,
      this.title,
      this.userpProductID,
      this.myID,
      this.peerId);

  factory NotificationModel.fromJson(Map<dynamic, dynamic> json) {
    return NotificationModel(
      json['senderPhone'].toString(),
      json['text'].toString(),
      json['time'].toString(),
      json['chatID'].toString(),
      json['productID'].toString(),
      json['productTitle'].toString(),
      json['title'].toString(),
      json['userpProductID'].toString(),
      json['myID'].toString(),
      json['peerId'].toString(),

    );
  }












}
