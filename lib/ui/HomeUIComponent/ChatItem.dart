import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haftaa/constants.dart';


class Chatitem extends StatefulWidget {

  @override
  _chatItemState ChatitemState() => _chatItemState();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return null;
  }
}

/// defaultUserName use in a Chat name
const String defaultUserName = "Alisa Hearth";

class _chatItemState extends State<Chatitem> with TickerProviderStateMixin {
  final List<Msg> _messages = <Msg>[];
  final TextEditingController _textController = new TextEditingController();
  bool _isWriting = false;
  final messageTextController = TextEditingController();

  String messageText;
  final dbRef = FirebaseDatabase.instance.reference().child("Chats").child("chatID");


  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.4,
        title: Text(
          "مزايدات",
          style: TextStyle(
              fontFamily: "Gotik", fontSize: 18.0, color: Colors.black54),
        ),
        iconTheme: IconThemeData(color: Color(0xFF6991C7)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),

      /// body in chat like a list in a message
      body: Container(
        color: Colors.white,
        child: new Column(children: <Widget>[
          new Flexible(
            child: _messages.length>0
                ?  Container(
                    child: new ListView.builder(
                      itemBuilder: (_, int index) => _messages[index],
                      itemCount: _messages.length,
                      reverse: true,
                      padding: new EdgeInsets.all(10.0),
                    ),
                  ): NoMessage(),
          ),
          /// Line
          new Divider(height: 1.5),
          new Container(
            child: null/*_buildComposer()*/,
            decoration: new BoxDecoration(
                color: Theme.of(ctx).cardColor,
                boxShadow: [BoxShadow(blurRadius: 1.0, color: Colors.black12)]),
          ),
        ]),
      ),
    );
  }

  /// Component for typing text
  Widget _buildComposer() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: TextField(
            style: TextStyle(color: Colors.black),
            controller: messageTextController,
            onChanged: (value) {
              messageText = value;
            },
            decoration: kMessageTextFieldDecoration,
          ),
        ),
        FlatButton(
          onPressed: () {
            messageTextController.clear();
            dbRef.push().set({
              "sender": 'Sender1',
              "text":messageText,
              "time":DateTime.now().millisecondsSinceEpoch,

            }).then((_) {
              messageTextController.clear();

            }).catchError((onError) {
              print(onError);
            });
          },
          child: Text(
            'Sender1',
            style: kSendButtonTextStyle,
          ),
        ),
        FlatButton(
          onPressed: () {
            dbRef.push().set({
              "sender": 'Sender2',
              "text":messageText,
              "time":DateTime.now().millisecondsSinceEpoch,

            }).then((_) {

              messageTextController.clear();
            }).catchError((onError) {
              print(onError);
            });
          },
          child: Text(
            'Sender2',
            style: kSendButtonTextStyle,
          ),
        ),
      ],
    );
  }

  void _submitMsg(String txt) {
    _textController.clear();
    setState(() {
      _isWriting = false;
    });
    Msg msg = new Msg(
      txt: txt,
      animationController: new AnimationController(
          vsync: this, duration: new Duration(milliseconds: 800)),
    );
    setState(() {
      _messages.insert(0, msg);
    });
    msg.animationController.forward();
  }

  @override
  void dispose() {
    for (Msg msg in _messages) {
      msg.animationController.dispose();
    }
    super.dispose();
  }
}

class Msg extends StatelessWidget {
  Msg({this.txt, this.animationController});

  final String txt;
  final AnimationController animationController;

  @override
  Widget build(BuildContext ctx) {
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(
          parent: animationController, curve: Curves.fastOutSlowIn),
      axisAlignment: 0.0,
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Expanded(
              child: Padding(
                padding: const EdgeInsets.all(00.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(1.0),bottomLeft:Radius.circular(20.0),topRight:Radius.circular(20.0),topLeft:Radius.circular(20.0)),
                        color: Color(0xFF6991C7).withOpacity(0.6),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: new Text(txt,style: TextStyle(color: Colors.white),),
                    ),
                  ],
                ),
              ),
            ),
//            new Container(
//              margin: const EdgeInsets.only(right: 5.0,left: 10.0),
//              child: new CircleAvatar(
//                backgroundImage: AssetImage("assets/avatars/avatar-1.jpg"),
////                  backgroundColor: Colors.indigoAccent,
////                  child: new Text(defaultUserName[0])),
//              ),
//            ),
          ],
        ),
      ),
    );
  }
}

class NoMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top:100.0),
            child: Center(
              child: Opacity(
                opacity: 0.5,
                  child: Image.asset("assets/imgIllustration/IlustrasiMessage.png",height: 220.0,)),
            ),
          ),
          Center(child: Text("لا يوجد مزايدات حتى الآن", style: TextStyle( fontWeight: FontWeight.w300,color: Colors.black12,fontSize: 17.0,fontFamily: "Popins"),))
        ],
      ),
    ));
  }
}
