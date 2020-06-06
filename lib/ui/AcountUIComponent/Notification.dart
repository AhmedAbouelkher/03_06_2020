import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:haftaa/ListItem/notificationsData.dart';
import 'package:haftaa/providers/phone_auth.dart';
import 'package:haftaa/ui/HomeUIComponent/Chat/PrivateChatscreen.dart';
import 'package:provider/provider.dart';

var dbRef;

class notification extends StatefulWidget {
  @override
  _notificationState createState() => _notificationState();
}

class _notificationState extends State<notification> {
  Widget build(BuildContext context) {
    dbRef = FirebaseDatabase.instance.reference().child("Notification").child(
        "${Provider.of<PhoneAuthDataProvider>(context, listen: false).user.uid}");

    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "إشعارات",
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18.0,
              color: Colors.black54,
              fontFamily: "Gotik"),
        ),
        iconTheme: IconThemeData(
          color: const Color(0xFF6991C7),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: NotificationsStream(),
    );
  }
}

class NotificationsStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: dbRef.onValue,
        builder: (context, snap) {
          if (snap.hasData && snap.data.snapshot.value != null) {
            Map data = snap.data.snapshot.value;
            List<NotificationModel> notificationItems = [];

            for (var i in data.values) {
              notificationItems.add(NotificationModel.fromJson(i));
            }

            notificationItems.sort((a, b) => b.time.compareTo(a.time));

            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              itemCount: notificationItems.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PrivateChatscreen.FromNotification(
                                  title: notificationItems[index].title,
                                  chatId: notificationItems[index].chatID,
                                  productTitleFromNotification:
                                      notificationItems[index].productTitle,
                                  productIdFromNotification:
                                      notificationItems[index].productID,
                                  userpProductIDFromNotification:notificationItems[index].userpProductID,
                                  peerIdFromNotification: notificationItems[index].peerId,
                                  myIDFromNotification:notificationItems[index].myID ,


                                ))
                    );
                  },
                  child: PostCard(
                    notificationItems[index].senderPhone,
                    notificationItems[index].text,
                    notificationItems[index].time,
                    notificationItems[index].chatID,
                    notificationItems[index].productID,
                    notificationItems[index].productTitle,
                    notificationItems[index].title,
                    notificationItems[index].userpProductID,
                    notificationItems[index].myID,
                    notificationItems[index].peerId,

                  ),
                );
              },
            );
          } else {
            return noItemNotifications();
          }
        });
  }
}

class PostCard extends StatelessWidget {
  String sender;
  String text;
  String time;
  String ChatID;
  String ProID;
  String ProTitle;
  String Title;
  String userpProductID;
  String myID;
  String peerId;


  PostCard(this.sender, this.text, this.time, this.ChatID, this.ProID,
      this.ProTitle, this.Title, this.userpProductID , this.myID , this.peerId);

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.white,
        elevation: 20,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(right: 8, top: 8, left: 5, bottom: 8),
              child: SizedBox(
                height: 100,
                child: Image.asset("assets/img/Logo.png"),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      ProTitle,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      sender,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      text,
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

class noItemNotifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      width: 500.0,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding:
                    EdgeInsets.only(top: mediaQueryData.padding.top + 100.0)),
            Image.asset(
              "assets/img/noNotification.png",
              height: 200.0,
            ),
            Padding(padding: EdgeInsets.only(bottom: 30.0)),
            Text(
              "لا يوجد إشعارات جديدة",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18.5,
                  color: Colors.black54,
                  fontFamily: "Gotik"),
            ),
          ],
        ),
      ),
    );
  }
}
