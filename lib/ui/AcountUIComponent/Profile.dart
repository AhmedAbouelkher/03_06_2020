import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haftaa/provider/image-provider.dart';
import 'package:haftaa/providers/phone_auth.dart';
import 'package:haftaa/ui/AcountUIComponent/AboutApps.dart';
import 'package:haftaa/ui/BottomNavigationBar.dart';
import 'package:haftaa/ui/LoginOrSignup/ChoseLoginOrSignup.dart';
import 'package:haftaa/ui/AcountUIComponent/Notification.dart';
import 'package:haftaa/ui/LoginOrSignup/Login.dart';
import 'package:haftaa/ui/pages/edit-profile.dart';
import 'package:haftaa/ui/pages/favourit-list.dart';
import 'package:haftaa/provider/provider.dart';
import 'package:haftaa/search/search.dart';
import 'package:haftaa/ui/pages/products-list.dart';
import 'package:haftaa/user/user-controller.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
  VoidCallback onMenuItemClick;

  Profile({this.onMenuItemClick});
}

/// Custom Font
var _txt = TextStyle(
  color: Colors.black,
  fontFamily: "Sans",
);

/// Get _txt and custom value of Variable for Name User
var _txtName = _txt.copyWith(fontWeight: FontWeight.w700, fontSize: 17.0);

/// Get _txt and custom value of Variable for Edit text
var _txtEdit = _txt.copyWith(color: Colors.black26, fontSize: 15.0);

/// Get _txt and custom value of Variable for Category Text
var _txtCategory = _txt.copyWith(
    fontSize: 14.5, color: Colors.black54, fontWeight: FontWeight.w500);

class _ProfileState extends State<Profile> {
  FirebaseUser firebaseuser;

  getLogedInPart(FirebaseUser user) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Center(
            child: Column(
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    File file = await UploadImageProvider.pickImage();
                    String newImagePath =
                        await UploadImageProvider.uploadImageFile(
                            file, 'users', DateTime.now().toString() + '.png');
                    await new UserController()
                        .updateProfilePhoto(user, newImagePath);

                    setState(() {});
                  },
                  child: Container(
                    height: 100.0,
                    width: 100.0,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2.5),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: user == null || user.photoUrl == null
                                ? AssetImage("assets/img/user.png")
                                : NetworkImage(user.photoUrl))),
                  ),
                ),
                Text(

                  (user.displayName == null || user.displayName == ''
                          ? null
                          : user.displayName) ??

                      user.phoneNumber,
                  style: _txtName,
                  textDirection: TextDirection.ltr,
                ),
                InkWell(
                  onTap: () {


                    if (Provider.of<PhoneAuthDataProvider>(context,
                        listen: false).isLoggedIn


                    ) {
                      var user = Provider.of<PhoneAuthDataProvider>(context,
                              listen: false)
                          .user;
                      // var user = Provider.of<ProductProvider>(context).auth.user;
                      Navigator.of(context).push(
                        PageRouteBuilder(
                            pageBuilder: (_, __, ___) => new EditProfile(
                                  user: user,
                                ),
                            transitionDuration: Duration(milliseconds: 600),
                            transitionsBuilder: (_, Animation<double> animation,
                                __, Widget child) {
                              return Opacity(
                                opacity: animation.value,
                                child: child,
                              );
                            }),
                      );
                    } else {
                      Navigator.pushNamed(context, 'login');
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Text(
                      "تعديل الملف الشخصي",
                      style: _txtEdit,
                    ),
                  ),
                ),
                // Text(
                //   snapshot.data.email,
                //   style: _txtEdit,
                // ),
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    firebaseuser =
        Provider.of<PhoneAuthDataProvider>(context, listen: false).user;
    //firebaseuser = Provider.of<ProductProvider>(context).auth.firebaseUser;
    var loginRawMaterial = Column(
      children: <Widget>[
        Container(
          height: 100.0,
          width: 100.0,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2.5),
              shape: BoxShape.circle,
              image: DecorationImage(image: AssetImage("assets/img/user.png"))),
        ),
        RawMaterialButton(
          onPressed: () async {
            Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (_, __, ___) => new loginScreen(),
                transitionDuration: Duration(milliseconds: 900),

                /// Set animation Opacity in route to detailProduk layout
                transitionsBuilder:
                    (_, Animation<double> animation, __, Widget child) {
                  return Opacity(
                    opacity: animation.value,
                    child: child,
                  );
                }));
          },
          child: Text("تسجيل دخول/تسجيل",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Sans",
                  fontWeight: FontWeight.w600)),
          fillColor: Color(0xFFA3BDED),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          constraints: BoxConstraints.tight(Size(300, 40)),
        )
      ],
    );

    /// Declare MediaQueryData
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    // final auth = Provider.of<ProductProvider>(context).auth;

    /// To Sett PhotoProfile,Name and Edit Profile
    var _profile = Padding(
      padding: EdgeInsets.only(
        top: 185.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Provider.of<PhoneAuthDataProvider>(context, listen: true)
                      .isLoggedIn
                  ? getLogedInPart(
                      Provider.of<PhoneAuthDataProvider>(context, listen: false)
                          .user)
                  : loginRawMaterial,
              // getLogedInPart(),
//              StreamBuilder<FirebaseUser>(
//                stream: Provider.of<ProductProvider>(context).auth.onAuthStateChanged,
//                builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
//                  if (snapshot.hasData) {
//                    return getLogedInPart(snapshot.data);
//                  } else {
//                    return loginRawMaterial;
//                  }
//                },
//              ),
            ],
          ),
          Container(),
        ],
      ),
    );

    var menList = Padding(
      padding: const EdgeInsets.only(top: 360.0),
      child: Column(
        /// Setting Category List
        children: <Widget>[
          /// Call category class
          category(
            txt: "إعلاناتي",
            padding: 35.0,
             icon: Icon(Icons.list,color: Color(0xff8985ab)),
            tap: () {
              if (Provider.of<PhoneAuthDataProvider>(context, listen: false)
                     .isLoggedIn) {
                ProductSearchModel _searchModel =
                    ProductSearchModel.FromSearchParams(
                        userID: Provider.of<PhoneAuthDataProvider>(context,
                                listen: false)
                            .user
                            .uid);
                if (widget.onMenuItemClick != null) {
                  widget.onMenuItemClick();
                }
                Navigator.of(context).push(
                  PageRouteBuilder(
                      pageBuilder: (_, __, ___) => new ProductList.Search(
                            _searchModel,
                            'إعلاناتي',
                            showCategoriesSlider: false,
                          ),
                      transitionDuration: Duration(milliseconds: 600),
                      transitionsBuilder:
                          (_, Animation<double> animation, __, Widget child) {
                        return Opacity(
                          opacity: animation.value,
                          child: child,
                        );
                      }),
                );
              } else {
                Navigator.pushNamed(context, 'login');
              }

              // Navigator.of(context).push(PageRouteBuilder(
              //     pageBuilder: (_, __, ___) => new notification()));
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 85.0, right: 30.0),
            child: Divider(
              color: Colors.black12,
              height: 2.0,
            ),
          ),
          category(
            txt: "تصفح الإعلانات",
            padding: 35.0,
             icon:Icon(Icons.home,color: Color(0xff8985ab),) ,
            tap: () {
              if (widget.onMenuItemClick != null) {
                widget.onMenuItemClick();
              }
              Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) => new bottomNavigationBar()));
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 85.0, right: 30.0),
            child: Divider(
              color: Colors.black12,
              height: 2.0,
            ),
          ),

          category(
            txt: "الإعلانات المفضلة",
            padding: 35.0,
            icon: Icon(
              Icons.favorite_border,
              color: Color(0xff8985ab),
            ),
            tap: () {
              if (widget.onMenuItemClick != null) {
                widget.onMenuItemClick();
              }
              Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) => new FavouritList()));
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 85.0, right: 30.0),
            child: Divider(
              color: Colors.black12,
              height: 2.0,
            ),
          ),
          category(
            txt: " الإشعارات",
            padding: 35.0,
            image: "assets/icon/notification.png",

            tap: () {

              if (Provider.of<PhoneAuthDataProvider>(context, listen: false).isLoggedIn == true) {

                if (widget.onMenuItemClick != null) {
                  widget.onMenuItemClick();
                }
                Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (_, __, ___) => new notification()));

              } else {
                Navigator.pushNamed(context, 'login');
              }


            },
          ),
          // Padding(
          //   padding: const EdgeInsets.only(
          //       top: 20.0, left: 85.0, right: 30.0),
          //   child: Divider(
          //     color: Colors.black12,
          //     height: 2.0,
          //   ),
          // ),
          // category(
          //   txt: "Payments",
          //   padding: 35.0,
          //   image: "assets/icon/creditAcount.png",
          //   tap: () {
          //     Navigator.of(context).push(PageRouteBuilder(
          //         pageBuilder: (_, __, ___) =>
          //             new creditCardSetting()));
          //   },
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(
          //       top: 20.0, left: 85.0, right: 30.0),
          //   child: Divider(
          //     color: Colors.black12,
          //     height: 2.0,
          //   ),
          // ),
          // category(
          //   txt: "Message",
          //   padding: 26.0,
          //   image: "assets/icon/chat.png",
          //   tap: () {
          //     Navigator.of(context).push(PageRouteBuilder(
          //         pageBuilder: (_, __, ___) => new chat()));
          //   },
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(
          //       top: 20.0, left: 85.0, right: 30.0),
          //   child: Divider(
          //     color: Colors.black12,
          //     height: 2.0,
          //   ),
          // ),
          // category(
          //   txt: "My Orders",
          //   padding: 23.0,
          //   image: "assets/icon/truck.png",
          //   tap: () {
          //     Navigator.of(context).push(PageRouteBuilder(
          //         pageBuilder: (_, __, ___) => new order()));
          //   },
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(
          //       top: 20.0, left: 85.0, right: 30.0),
          //   child: Divider(
          //     color: Colors.black12,
          //     height: 2.0,
          //   ),
          // ),
          // category(
          //   txt: "Setting Acount",
          //   padding: 30.0,
          //   image: "assets/icon/setting.png",
          //   tap: () {
          //     Navigator.of(context).push(PageRouteBuilder(
          //         pageBuilder: (_, __, ___) => new settingAcount()));
          //   },
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(
          //       top: 20.0, left: 85.0, right: 30.0),
          //   child: Divider(
          //     color: Colors.black12,
          //     height: 2.0,
          //   ),
          // ),
          // category(
          //   txt: "Call Center",
          //   padding: 30.0,
          //   image: "assets/icon/callcenter.png",
          //   tap: () {
          //     Navigator.of(context).push(PageRouteBuilder(
          //         pageBuilder: (_, __, ___) => new callCenter()));
          //   },
          // ),

          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 85.0, right: 30.0),
            child: Divider(
              color: Colors.black12,
              height: 2.0,
            ),
          ),
          category(
            padding: 38.0,
            txt: "عن التطبيق",
             icon: Icon(Icons.title,color: Color(0xff8985ab)),

            tap: () {
              if (widget.onMenuItemClick != null) {
                widget.onMenuItemClick();
              }
              Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) => new aboutApps()));
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 85.0, right: 30.0),
            child: Divider(
              color: Colors.black12,
              height: 2.0,
            ),
          ),
          Provider.of<PhoneAuthDataProvider>(context, listen: true).isLoggedIn
              ? category(
                  padding: 38.0,
                  txt: "تسجيل خروج",
                  image: "assets/icon/aboutapp.png",
                  tap: () async {
                    if (widget.onMenuItemClick != null) {
                      widget.onMenuItemClick();
                    }
                    await Provider.of<PhoneAuthDataProvider>(context,
                            listen: false)
                        .signOut()
                        .then((onValue) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                bottomNavigationBar()),
                        ModalRoute.withName('/'),
                      );
                    });
                    setState(() {});
                  },
                )
              : Container(),
          Padding(padding: EdgeInsets.only(bottom: 20.0)),
        ],
      ),
    );
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            /// Setting Header Banner
            Container(
              height: 240.0,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/img/headerProfile.png"),
                      fit: BoxFit.cover)),
            ),

            /// Calling _profile variable
            _profile,
            menList,
          ],
        ),
      ),
    );
  }
}

/// Component category class to set list
class category extends StatelessWidget {
  @override
  String txt, image;
  Icon icon;
  GestureTapCallback tap;
  double padding;

  category({this.txt, this.image, this.tap, this.padding, this.icon});

  Widget build(BuildContext context) {
    return InkWell(
      onTap: tap,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 30.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: padding),
                  child: image != null
                      ? Image.asset(
                          image,
                          height: 25.0,
                        )
                      : icon,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 5),
                ),
                Text(
                  txt,
                  style: _txtCategory,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
