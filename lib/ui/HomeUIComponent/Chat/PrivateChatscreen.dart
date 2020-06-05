import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:haftaa/constants.dart';
import 'package:haftaa/product/sale-product.dart';
import 'package:haftaa/providers/phone_auth.dart';
import 'package:provider/provider.dart';
import 'package:haftaa/ui/HomeUIComponent/Chat/PrivateChatModel.dart';

var dbRef;

class PrivateChatscreen extends StatefulWidget {
  String title = '';
  String ChatId = '';
  var productID ;
  var productTitle ;



  PrivateChatscreen(this.title, this.productID, this.productTitle, this.ChatId);

  @override
  _PrivateChatscreen createState() => _PrivateChatscreen();
}

class _PrivateChatscreen extends State<PrivateChatscreen> {
  final messageTextController = TextEditingController();

  String messageText;

  @override
  Widget build(BuildContext context) {

    dbRef = FirebaseDatabase.instance
        .reference()
        .child("Chat")
        .child("PrivateChat")
        .child('${widget.productID}')
        .child('${widget.ChatId}');


    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.title}'),
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MessagesStream(),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                        color: Colors.grey,
                        width: MediaQuery.of(context).size.width * .004),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .2,
                      child: FlatButton(
                        onPressed: () {


                          if(messageText.isEmpty || messageText == null){}
                          else
                            {

                              messageTextController.clear();
                              dbRef.push().set({
                                "sender": '${Provider.of<PhoneAuthDataProvider>(context, listen: false).user.phoneNumber}',
                                "text":messageText,
                                "time":DateTime.now().millisecondsSinceEpoch,

                              }).catchError((onError) {
                                print(onError);
                              });
                            }

                            // notification
                          FirebaseDatabase.instance.reference()
                              .child('Notification')
                              .child('${Provider.of<PhoneAuthDataProvider>(context, listen: false).user.uid}')
                              .child('${widget.productID}')
                              .update({
                                  "sender": '${Provider.of<PhoneAuthDataProvider>(context, listen: false).user.phoneNumber}',
                                  "text":messageText,
                                  "time":DateTime.now().millisecondsSinceEpoch,
                                  "ChatID" : widget.ChatId,
                                  "ProID" : widget.productID,
                                  "ProTitle" : widget.productTitle,
                                  "Title" : widget.title,
                              });

                        },
                        child: Icon(
                          Icons.send,
                          size: MediaQuery.of(context).size.width * .09,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.start,

                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * .05),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: messageTextController,
                        onChanged: (value) {
                          messageText = value;


                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: MediaQuery.of(context).size.width * .02,
                              horizontal:
                                  MediaQuery.of(context).size.width * .05),
                          hintText: 'اكتب رسالتك....',

                          border: InputBorder.none,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class MessagesStream extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: dbRef.onValue,
        builder: (context, snap) {
          if (snap.data.snapshot.value == null) {
            return NoMessage();

          }
           else
             {
               Map data = snap.data.snapshot.value;
               List<MsgModel> item = [];

               for (var i in data.values) {
                 item.add(MsgModel.fromJson(i));
               }

               item.sort((a, b) => b.time.compareTo(a.time));

               return Expanded(
                 child: ListView.builder(
                   reverse: true,
                   padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                   itemCount: item.length,
                   itemBuilder: (BuildContext context, int index) {
                     return MessageBubble(
                       text: item[index].text,
                       isMe:  Provider.of<PhoneAuthDataProvider>(context, listen: false).isLoggedIn == true,
                     );
                   },
                 ),
               );
             }


        });
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.text, this.isMe});


  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: <Widget>[

          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(20.0))
                : BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
            elevation: 5.0,
            color: isMe ? Colors.grey : Colors.white70,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black54,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NoMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Center(
              child: Opacity(
                  opacity: 0.5,
                  child: Image.asset(
                    "assets/imgIllustration/IlustrasiMessage.png",
                    height: 220.0,
                  )),
            ),
          ),
          Center(
            child: Text(
              "لا يوجد رسائل حتى الآن",
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.black12,
                  fontSize: 17.0,
                  fontFamily: "Popins"),
            ),
          )
        ],
      ),
    );
  }
}
