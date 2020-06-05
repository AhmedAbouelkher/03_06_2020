
class Post {

  String sender;
  String text;
  String time;
  String ChatID;
  String ProID;
  String ProTitle;
  String Title;


  Post(this.sender, this.text, this.time, this.ChatID, this.ProID, this.ProTitle, this.Title);

  factory Post.fromJson(Map<dynamic, dynamic> json) {
    return Post(
      json['sender'],
      json['text'],
      json['time'].toString(),
      json['ChatID'],
      json['ProID'],
      json['ProTitle'],
      json['Title'].toString(),

    );
  }












}
