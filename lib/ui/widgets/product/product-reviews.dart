import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:haftaa/product/base-product.dart';
import 'package:haftaa/providers/phone_auth.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProductReviews extends StatefulWidget {
  final BaseProduct product;

  ProductReviews(this.product);

  @override
  _ProductReviewsState createState() => _ProductReviewsState();
}

class _ProductReviewsState extends State<ProductReviews> {
  double rating = 3.5;
  int starCount = 5;
  var dbRef;
  static var _subHeaderCustomStyle = TextStyle(
      color: Colors.black54,
      fontWeight: FontWeight.w700,
      fontFamily: "Gotik",
      fontSize: 16.0);

  /// Custom Text for Detail title

  Widget _line() {
    return Container(
      height: 0.9,
      width: double.infinity,
      color: Colors.black12,
    );
  }

  String commentText;
  final TextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    dbRef = FirebaseDatabase.instance
        .reference()
        .child('menuItems')
        .child('${widget.product.id}')
        .child('comments');
    var commentsFuture = widget.product.getProductComments();
    var addComment = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          width: 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.white),
          child: TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            controller: TextController,
            onChanged: (value) {
              commentText = value;
            },
            decoration: InputDecoration(
              hintText: 'كتابة تعليق',
              hintStyle: TextStyle(
                color: Colors.black,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(15.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.lightBlueAccent),
            child: FlatButton(
                onPressed: () {
                  if (Provider.of<PhoneAuthDataProvider>(context, listen: false)
                          .isLoggedIn ==
                      true) {
                    if (commentText.length == 0) {
                      // dont comment
                    } else {
                      FirebaseDatabase.instance
                          .reference()
                          .child('menuItems')
                          .child('${widget.product.id}')
                          .child('comments')
                          .push()
                          .set({
                        "userID": Provider.of<PhoneAuthDataProvider>(context,
                                listen: false)
                            .user
                            .uid,
                        "userName": Provider.of<PhoneAuthDataProvider>(context,
                                listen: false)
                            .user
                            .displayName,
                        "userPhone": Provider.of<PhoneAuthDataProvider>(context,
                                listen: false)
                            .user
                            .phoneNumber,
                        "userImg": Provider.of<PhoneAuthDataProvider>(context,
                                listen: false)
                            .user
                            .photoUrl,
                        "text": commentText,
                        "time": DateTime.now().millisecondsSinceEpoch,
                      });
                      commentText = '';
                      TextController.clear();
                    }
                  } else {
                    Navigator.pushNamed(context, 'login');
                  }
                },
                child: Text(
                  'تعليق',
                  style:
                      TextStyle(color: const Color(0xffffffff), fontSize: 20),
                )),
          ),
        )
      ],
    );
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        height: 415.0,
        width: 600.0,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: Color(0xFF656565).withOpacity(0.15),
            blurRadius: 1.0,
            spreadRadius: 0.2,
          )
        ]),
        child: Padding(
          padding: EdgeInsets.only(top: 20.0, left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Text(
                      'التعليقات',
                      style: _subHeaderCustomStyle,
                    ),
                  ),
//                  Padding(
//                    padding: const EdgeInsets.only(
//                        left: 20.0, top: 15.0, bottom: 15.0),
//                    child: Row(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      mainAxisAlignment: MainAxisAlignment.start,
//                      children: <Widget>[
//                        InkWell(
//                          child: Padding(
//                              padding: EdgeInsets.only(top: 2.0, right: 3.0),
//                              child: Text(
//                                'View All',
//                                style: _subHeaderCustomStyle.copyWith(
//                                    color: Colors.indigoAccent, fontSize: 14.0),
//                              )),
//                          onTap: () {
////                            Navigator.of(context).push(PageRouteBuilder(pageBuilder: (_,__,___)=>ReviewsAll()));
//                          },
//                        ),
//                        Padding(
//                          padding: const EdgeInsets.only(right: 15.0, top: 2.0),
//                          child: Icon(
//                            Icons.arrow_forward_ios,
//                            size: 18.0,
//                            color: Colors.black54,
//                          ),
//                        )
//                      ],
//                    ),
//                  )
                ],
              ),
//              FutureBuilder(
//                future: commentsFuture,
//                builder: (context, AsyncSnapshot snapshot) {
//                  if (snapshot.hasData) {
//                    List<CommentModel> commentList = [];
//                    for (var i in snapshot.data.value) {
//                      commentList.add(CommentModel.fromJson(i));
//                    }
//
//                    return Expanded(
//                      child: ListView.builder(
//                        itemCount: commentList.length,
//                        itemBuilder: (BuildContext context, int index) {
//                          return buildRating(
//                              DateFormat('yyyy-M-dd a HH:mm')
//                                  .format(commentList[index].time),
//                              commentList[index].text,
//                              "assets/avatars/avatar-1.jpg");
//                        },
//                      ),
//                    );
//                  } else {
//                    return CircularProgressIndicator();
//                  }
//                },
//              ),
              StreamBuilder(
                stream: dbRef.onValue,
                builder: (context, snap) {
                  if (snap.hasData && snap.data.snapshot.value != null) {
                    Map data = snap.data.snapshot.value;
                    List<CommentModel> CommentItems = [];
                    for (var i in data.values) {
                      CommentItems.add(CommentModel.fromJson(i));
                    }
                    CommentItems.sort((a,b){
                      return a.time.compareTo(b.time);
                    });
                    return Expanded(
                      child: ListView.builder(
                        itemCount: CommentItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          return buildRating(CommentItems[index]);
                        },
                      ),
                    );
                  } else {
                    return Center(child: Text('لا يوجد تعليقات'));
                  }
                },
              ),
              widget.product.canComment
                  ? addComment
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: Text('لا يمكن التعليق على هذا المنتج حالياً')),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class buildRating extends StatelessWidget {
//  String date;
//  var details;
//  var image;
  CommentModel comment;

  buildRating(this.comment);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: Text(comment.formatedDate),
      leading: Container(
        height: 45.0,
        width: 45.0,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/launcher/rsz_icon_hourse.png"),
                fit: BoxFit.cover),
            borderRadius: BorderRadius.all(Radius.circular(50.0))),
      ),
      title: Row(
        children: <Widget>[
          SizedBox(width: 8.0),
          Text(
            '${comment.userName ?? ''}',
            style: TextStyle(fontSize: 12.0),
          )
        ],
      ),
      subtitle: Text(
        comment.text,
        style: TextStyle(
            fontFamily: "Gotik",
            color: Colors.black54,
            letterSpacing: 0.3,
            wordSpacing: 0.5),
      ),
    );
  }
}

class CommentModel {
  var text;
  int time;
  var datetime;
  var formatedDate;
  var userID;
  var userImg;
  var userName;
  var userPhone;

  CommentModel(this.text, this.time, this.userID, this.userImg, this.userName,
      this.userPhone) {
    this.datetime = new DateTime.fromMillisecondsSinceEpoch(time);
    this.formatedDate = _formatdate(this.datetime);
  }

  factory CommentModel.fromJson(Map<dynamic, dynamic> json) {
    return CommentModel(json['text'].toString(), json['time'], json['userID'],
        json['userImg'], json['userName'], json['userPhone']);
  }

  String _formatdate(DateTime date) {
    var now = date;
    var formatter = new DateFormat('dd-MM-yyyy');
    String formattedTime = DateFormat('kk:mm:a').format(now);
    String formattedDate = formatter.format(now);
    return '$formattedDate  $formattedTime';
    print(formattedDate);
    print(formattedDate);
  }
}
