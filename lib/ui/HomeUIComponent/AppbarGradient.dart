import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:haftaa/Enums/enums.dart';
import 'package:haftaa/ListItem/notificationsData.dart';
import 'package:haftaa/UI/pages/sale-product-details.dart';
import 'package:haftaa/bloc/product-bloc.dart';
import 'package:haftaa/providers/phone_auth.dart';
import 'package:haftaa/ui/AcountUIComponent/Notification.dart';
import 'package:haftaa/ui/HomeUIComponent/advanced-search.dart';
import 'package:haftaa/ui/AcountUIComponent/Message.dart';
import 'package:haftaa/provider/provider.dart';
import 'package:haftaa/ui/pages/add-product.dart';
import 'package:haftaa/ui/pages/auction-product-details.dart';
import 'package:haftaa/ui/pages/request-product-details.dart';
import 'package:haftaa/ui/widgets/product-search.dart';
import 'package:provider/provider.dart';

var dbRef;

class AppbarGradient extends StatefulWidget {
  @override
  _AppbarGradientState createState() => _AppbarGradientState();
}

class _AppbarGradientState extends State<AppbarGradient> {
  /// Build Appbar in layout home
  @override
  Widget build(BuildContext context) {
    if (Provider
        .of<PhoneAuthDataProvider>(context, listen: false)
        .isLoggedIn ==
        true) {
      dbRef = FirebaseDatabase.instance.reference().child("Notification").child(
          "${Provider
              .of<PhoneAuthDataProvider>(context, listen: false)
              .user
              .uid}");
    }

    /// Create responsive height and padding
    final MediaQueryData media = MediaQuery.of(context);
    final double statusBarHeight = MediaQuery
        .of(context)
        .padding
        .top;

    /// Create component in appbar
    return Container(
      padding: EdgeInsets.only(top: statusBarHeight),
      height: 58.0 + statusBarHeight,
      decoration: BoxDecoration(

        /// gradient in appbar
          gradient: LinearGradient(
              colors: [
                const Color(0xFFA3BDED),
                const Color(0xFF6991C7),
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp)),
      child: Row(
        children: <Widget>[

          Padding(
              padding: EdgeInsets.only(
                right: 17.0,
              )),

          /// if user click shape white in appbar navigate to search layout
          InkWell(
            onTap: () {
              showSearch(
                context: context,
                delegate: ProductSearch(),
              ).then((product) {
                var page;
                if (product != null) {
                  switch (product.type) {
                    case ItemType.sale:
                    //page = new SaleProductDetails(product);
                      break;
                    case ItemType.request:
                      page = new RequestProductDetails(product);
                      break;
                    case ItemType.auction:
                      page = new AuctionProductDetails(product);
                      break;
                    default:
                  }
                  Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (_, __, ___) => page,
                      transitionDuration: Duration(milliseconds: 900),

                      /// Set animation Opacity in route to detailProduk layout
                      transitionsBuilder:
                          (_, Animation<double> animation, __, Widget child) {
                        return Opacity(
                          opacity: animation.value,
                          child: child,
                        );
                      }));
                }
              });
              return;
              Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) =>
                      AdvancedSearch.withOptions(searchBytitleOnly: true),

                  /// transtation duration in animation
                  transitionDuration: Duration(milliseconds: 750),

                  /// animation route to search layout
                  transitionsBuilder:
                      (_, Animation<double> animation, __, Widget child) {
                    return Opacity(
                      opacity: animation.value,
                      child: child,
                    );
                  }));
            },

            /// Create shape background white in appbar (background treva shop text)
            child: Container(
              margin: EdgeInsets.only(left: media.padding.left + 15),
              height: 37.0,
              width: 120.0,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  shape: BoxShape.rectangle),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  Padding(padding: EdgeInsets.only(left: 5.0)),
                  Image.asset(
                    "assets/img/search2.png",
                    height: 22.0,
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                        left: 17.0,
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: 3.0),
                    child: Text(
                      "الهفتاء",
                      style: TextStyle(
                          fontFamily: "Popins",
                          color: Colors.black12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.0,
                          fontSize: 16.4),
                    ),
                  ),
                ],
              ),
            ),
          ),

          FlatButton(
            child: Row(
              children: <Widget>[
                Text(
                  'إضافة إعلان',
                  style: TextStyle(color: Colors.white),
                ),
                IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (Provider
                        .of<PhoneAuthDataProvider>(context,
                        listen: false)
                        .isLoggedIn ==
                        true) {
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) =>
                          new AddProduct.newOne()));
                    } else {
                      Navigator.pushNamed(context, 'login');
                    }
                  },
                )
              ],
            ),
            onPressed: () {
              if (Provider
                  .of<PhoneAuthDataProvider>(context, listen: false)
                  .isLoggedIn ==
                  true) {
                Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (_, __, ___) => new AddProduct.newOne()));
              } else {
                Navigator.pushNamed(context, 'login');
              }
            },
          ),

          /// Icon chat (if user click navigate to chat layout)
//          InkWell(
//              onTap: () {
//                Navigator.of(context).push(
//                    PageRouteBuilder(pageBuilder: (_, __, ___) => new chat()));
//              },
//              child: Image.asset(
//                "assets/img/chat.png",
//                height: media.devicePixelRatio + 20.0,
//              )),

          /// Icon notification (if user click navigate to notification layout)
          InkWell(
            onTap: () {
              if (Provider
                  .of<PhoneAuthDataProvider>(context, listen: false)
                  .isLoggedIn ==
                  true) {
                Scaffold.of(context).showBottomSheet<void>(
                      (BuildContext context) {
                    return Container(
                      height:  MediaQuery
                          .of(context)
                          .size
                          .height,
                      color: Colors.amber,
                      child: notification(),
                    );
                  },
                );


              } else {
              Navigator.pushNamed(context, 'login');
              }

//              Navigator.of(context).push(PageRouteBuilder(
//                  pageBuilder: (_, __, ___) => new notification()));
            },
            child: Stack(
              alignment: AlignmentDirectional(-3.0, -3.0),
              children: <Widget>[
                Image.asset(
                  "assets/img/notifications-button.png",
                  height: 24.0,
                ),
                Provider
                    .of<PhoneAuthDataProvider>(context, listen: false)
                    .isLoggedIn == true
                    ? dbRef == null ?
                Image.asset(
                  "assets/img/notifications-button.png",
                  height: 24.0,
                )
                    : StreamBuilder(
                  stream: dbRef.onValue,
                  builder: (context, snap) {
                    if (snap.data?.snapshot?.value == null) {
                      return Image.asset(
                        "assets/img/notifications-button.png",
                        height: 24.0,
                      );
                    }
                    Map data = snap.data.snapshot.value;
                    List<NotificationModel> notificationItems = [];

                    for (var i in data.values) {
                      notificationItems
                          .add(NotificationModel.fromJson(i));
                    }


                    return CircleAvatar(
                      radius: 8.6,
                      backgroundColor: Colors.redAccent,
                      child: Text(
                        notificationItems.length.toString(),
                        style: TextStyle(
                            fontSize: 13.0, color: Colors.white),
                      ),
                    );
                  },
                )
                    : SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
