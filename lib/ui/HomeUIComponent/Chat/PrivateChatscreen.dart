import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:haftaa/constants.dart';
import 'package:haftaa/product/base-product.dart';
import 'package:haftaa/product/sale-product.dart';
import 'package:haftaa/providers/phone_auth.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:haftaa/ui/HomeUIComponent/Chat/PrivateChatModel.dart';

var dbRef;

class PrivateChatscreen extends StatefulWidget {
  String title = '';
  String chatId = '';
  var Phone = '';
  BaseProduct product;
  var peerId;

  PrivateChatscreen({this.product, this.title, this.chatId, this.peerId, this.Phone});

  String productTitleFromNotification;
  String productIdFromNotification;
  String userpProductIDFromNotification;
  String myIDFromNotification;
  String peerIdFromNotification;
  bool showNumberFromNotification;
  String phoneFromNotification;

  PrivateChatscreen.FromNotification(
      {this.title,
      this.chatId,
      this.productTitleFromNotification,
      this.productIdFromNotification,
      this.userpProductIDFromNotification,
      this.peerIdFromNotification,
      this.myIDFromNotification,
        this.showNumberFromNotification,
        this.phoneFromNotification,

      });

  @override
  _PrivateChatscreen createState() => _PrivateChatscreen();
}

class _PrivateChatscreen extends State<PrivateChatscreen> {
  final messageTextController = TextEditingController();

  String messageText;
  var _firestore;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title:widget.product == null?
              widget.showNumberFromNotification == true?
          Text('${widget.productTitleFromNotification}\nمع ${widget.phoneFromNotification}',style: TextStyle(fontSize: 18,),):
          Text('${widget.productTitleFromNotification}',style: TextStyle(fontSize: 18,),)
              :
          widget.product.showMobileNumber == true?
          Text('${widget.title}\nمع ${widget.Phone}',style: TextStyle(fontSize: 18,),)
              :
          Text('${widget.title}',style: TextStyle(fontSize: 18,),),
          backgroundColor: Colors.white,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.report),
                onPressed: (){
                  if(widget.product == null){
                     // action come from notification screen

                    var IdProduct = widget.productIdFromNotification;


                  }
                  else{
                    // action come from details screen

                    var IdProduct = widget.product.id;


                  }
                }
            )
          ],
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              widget.product == null?
              MessagesStreamFireStore(widget.productIdFromNotification,widget.chatId)
              :
              MessagesStreamFireStore(widget.product.id,widget.chatId),
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
                          if (messageText.isEmpty || messageText == null) {
                          } else {
                            messageTextController.clear();

                            if (widget.product == null) {
                              _firestore = Firestore.instance
                                  .collection('PrivateChat')
                                  .document('${widget.productIdFromNotification}')
                                  .collection('${widget.chatId}').add({'message': messageText, 'sender': Provider
                                  .of<PhoneAuthDataProvider>(context, listen: false)
                                  .user
                                  .phoneNumber,'time': FieldValue.serverTimestamp()});

                            }else
                            {
                              _firestore = Firestore.instance
                                  .collection('PrivateChat')
                                  .document('${widget.product.id}')
                                  .collection('${widget.chatId}').add({'message': messageText, 'sender': Provider
                                  .of<PhoneAuthDataProvider>(context, listen: false)
                                  .user
                                  .phoneNumber,'time': FieldValue.serverTimestamp()});


                            }


//                            dbRef.push().set({
//                              "sender":
//                                  '${Provider.of<PhoneAuthDataProvider>(context, listen: false).user.phoneNumber}',
//                              "text": messageText,
//                              "time": DateTime.now().millisecondsSinceEpoch,
//                            }).catchError((onError) {
//                              print(onError);
//                            });
                          }

                          // notification


                          if (widget.product == null) {
                            FirebaseDatabase.instance
                                .reference()
                                .child('Notification')
                                .child(
                                    '${widget.userpProductIDFromNotification == Provider.of<PhoneAuthDataProvider>(context, listen: false).user.uid ? widget.myIDFromNotification : widget.userpProductIDFromNotification}')
                                .child('${widget.productIdFromNotification}')
                                .update({
                              "senderPhone":
                              Provider.of<PhoneAuthDataProvider>(context, listen: false).user.displayName == null
                                  ?
                              Provider.of<PhoneAuthDataProvider>(context, listen: false).user.phoneNumber
                                  :
                              Provider.of<PhoneAuthDataProvider>(context, listen: false).user.displayName
                              ,
                              "myID":
                                  '${Provider.of<PhoneAuthDataProvider>(context, listen: false).user.uid}',
                              "text": messageText,
                              "time": DateTime.now().millisecondsSinceEpoch,
                              "chatID": widget.chatId,
                              "productID": widget.productIdFromNotification,
                              "productTitle":
                                  widget.productTitleFromNotification,
                              "userpProductID":
                                  widget.userpProductIDFromNotification,
                              "title": widget.title ,
                              "peerId": widget.peerIdFromNotification,
                              "showNumber":widget.showNumberFromNotification,
                              "phone":Provider.of<PhoneAuthDataProvider>(context, listen: false).user.phoneNumber,
                            });
                          } else {
                            FirebaseDatabase.instance
                                .reference()
                                .child('Notification')
                                .child(
                                    '${widget.product.userId == Provider.of<PhoneAuthDataProvider>(context, listen: false).user.uid ? widget.peerId : widget.product.userId}')
                                .child('${widget.product.id}')
                                .update({
                              "senderPhone":
                              Provider.of<PhoneAuthDataProvider>(context, listen: false).user.displayName == null
                                  ?
                              Provider.of<PhoneAuthDataProvider>(context, listen: false).user.phoneNumber
                                  :
                              Provider.of<PhoneAuthDataProvider>(context, listen: false).user.displayName
                                 ,
                              "myID":
                                  '${Provider.of<PhoneAuthDataProvider>(context, listen: false).user.uid}',
                              "text": messageText,
                              "time": DateTime.now().millisecondsSinceEpoch,
                              "chatID": widget.chatId,
                              "productID": widget.product.id,
                              "userpProductID": widget.product.userId,
                              "productTitle": widget.product.title,
                              "title": widget.title,
                              "peerId": widget.peerId,
                              "showNumber":widget.product.showMobileNumber,
                              "phone":Provider.of<PhoneAuthDataProvider>(context, listen: false).user.phoneNumber,
                            });
                          }
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

class MessagesStreamFireStore extends StatelessWidget {

  String chatId ;
  String productId ;

  MessagesStreamFireStore(this.productId, this.chatId);





  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
                Firestore.instance
                .collection('PrivateChat')
                .document('$productId')
                .collection('$chatId')
                    .orderBy('time')
                    .snapshots(),
      builder: (context,   snapshot) {
        if (!snapshot.hasData||snapshot.data.documents.isEmpty) {
          return NoMessage();
        }
        final messages = snapshot.data.documents.reversed;
        List<MessageBubbleFireStore> messageBubbles = [];
        for (var message in messages) {

          final messageText = message.data['message'];
          final messageSender = message.data['sender'];
          var messgaeTime = message.data['time'];


          final messageBubble = MessageBubbleFireStore(
              text: messageText,
              isMe: messageSender == Provider.of<PhoneAuthDataProvider>(context, listen: false).user.phoneNumber,
            sender:messgaeTime ,


          );

          messageBubbles.add(messageBubble);
         // messageBubbles..sort((a, b) => a.time.compareTo(b.time));

         }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubbleFireStore extends StatelessWidget {
  MessageBubbleFireStore({this.text, this.isMe, this.sender});

  final String text;
  final Timestamp sender;
  final bool isMe;



  @override
  Widget build(BuildContext context) {


    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
        isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            '${sender?.toDate()?.day}-${sender?.toDate()?.month}-${sender?.toDate()?.year} ${sender?.toDate()?.hour}:${sender?.toDate()?.minute}',
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            elevation: 5.0,
            color: isMe ? Colors.grey : Colors.white70,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: SelectableText(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black,
                  fontSize: MediaQuery
                      .of(context)
                      .size
                      .width * .05,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


//class MessagesStream extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return StreamBuilder(
//        stream: dbRef.onValue,
//        builder: (context, snap) {
//          if (snap.data?.snapshot?.value == null) {
//            return NoMessage();
//          } else {
//            Map data = snap.data.snapshot.value;
//            List<MsgModel> messageList = [];
//
//            for (var i in data.values) {
//              messageList.add(MsgModel.fromJson(i));
//            }
//
//
//            messageList.sort((a, b) => b.time.compareTo(a.time));
//
//            return Expanded(
//              child: ListView.builder(
//                reverse: true,
//                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
//                itemCount: messageList.length,
//                itemBuilder: (BuildContext context, int index) {
//                  return MessageBubble(
//                    message: messageList[index],
//                    isMe: messageList[index].sender ==
//                        Provider.of<PhoneAuthDataProvider>(context,
//                                listen: false)
//                            .user
//                            .phoneNumber,
//                  );
//                },
//              ),
//            );
//          }
//        });
//  }
//}

//class MessageBubble extends StatelessWidget {
//  MessageBubble({ this.isMe, this.message});
//
//
//  final bool isMe;
//  final MsgModel message;
//
//  @override
//  Widget build(BuildContext context) {
//    return Padding(
//      padding: EdgeInsets.all(10.0),
//      child: Column(
//        crossAxisAlignment:
//            isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
//        children: <Widget>[
//          Material(
//            borderRadius: isMe
//                ? BorderRadius.only(
//                    topLeft: Radius.circular(10.0),
//                    bottomLeft: Radius.circular(10.0),
//                    bottomRight: Radius.circular(20.0))
//                : BorderRadius.only(
//                    bottomLeft: Radius.circular(20.0),
//                    bottomRight: Radius.circular(10.0),
//                    topRight: Radius.circular(10.0),
//                  ),
//            elevation: 5.0,
//            color: isMe ? Colors.grey : Colors.white70,
//            child: Padding(
//              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//              child: Text(
//                message.text + ' '+message.time.toString(),
//                style: TextStyle(
//                  color: isMe ? Colors.white : Colors.black54,
//                  fontSize: 15.0,
//                ),
//              ),
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//}

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
