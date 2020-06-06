class MsgModel {
  String sender;

  String text;


  int time;

  MsgModel(this.sender, this.text, this.time);

  factory MsgModel.fromJson(Map<dynamic, dynamic> json) {
    return MsgModel(
      json['sender'],
      json['text'],
      json['time'] as int,
    );
  }
}