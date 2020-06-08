import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haftaa/authentication/auth.dart';
import 'package:haftaa/Ticker/TickerController.dart';
import 'package:haftaa/ui/BottomNavigationBar.dart';
import 'package:haftaa/ui/LoginOrSignup/LoginAnimation.dart';
import 'package:haftaa/provider/provider.dart';
import 'package:haftaa/services/firebase.dart';
import 'package:haftaa/ui/widgets/auth/login-with-mobile.dart';
import 'package:haftaa/ui/widgets/auth/phone-auth.dart';
import 'package:haftaa/validation/validators.dart';

class loginScreen extends StatefulWidget {
  @override
  _loginScreenState createState() => _loginScreenState();
}

/// Component Widget this layout UI
class _loginScreenState extends State<loginScreen>
    with TickerProviderStateMixin {
  TextEditingController textEmailController = TextEditingController();
  TextEditingController textPasswordController = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();
  String _email, _password;
  FormType _formType = FormType.login;
  //Animation Declaration
  AnimationController sanimationController;

  String _errorMessage = '';
  String _warningMessage = '';

  var tap = 0;
  bool _isLoging = false;
  void submit() async {
    if (_isLoging) {
      _warningMessage = 'انتظر من فضلك...';
      return;
    }
    _warningMessage = '';
    if (validate()) {
//      try {
//        final auth = Provider.of<ProductProvider>(context).auth;
//        if (_formType == FormType.login) {
//          setState(() {
//            _isLoging = true;
//          });
//
//          String userId = await auth.signInWithEmailAndPassword(
//            _email,
//            _password,
//          );
//          await auth.refreshUserData(userid: userId);
//          setState(() {
//            _isLoging = false;
//          });
//          print('Signed in $userId');
//
//          _PlayAnimation();
//          Navigator.pushAndRemoveUntil(
//            context,
//            MaterialPageRoute(
//                builder: (BuildContext context) => bottomNavigationBar()),
//            ModalRoute.withName('/'),
//          );
//        } else {
//          String userId = await auth.createUserWithEmailAndPassword(
//            _email,
//            _password,
//          );
//
//          print('Registered in $userId');
//        }
//      } catch (e) {
//        setState(() {
//          _isLoging = false;
//          _errorMessage = _handleLoginError(e);
//        });
//        print(e);
//      }
    }
  }

  String _handleLoginError(PlatformException error) {
    String errorMessage = '';
    switch (error.code) {
      case 'ERROR_WRONG_PASSWORD':
        errorMessage = 'كلمة المرور خطأ';
        break;
      default:
        errorMessage = error.code;
    }
    return errorMessage;
  }

  bool validate() {
    final form = formGlobalKey.currentState;
    form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  @override

  /// set state animation controller
  void initState() {
    sanimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800))
          ..addStatusListener((statuss) {
            if (statuss == AnimationStatus.dismissed) {
              setState(() {
                tap = 0;
              });
            }
          });

    textEmailController.addListener(() {
      _email = textEmailController.text;
    });

    textPasswordController.addListener(() {
      _password = textPasswordController.text;
    });

    super.initState();
  }

  /// Dispose animation controller
  @override
  void dispose() {
    super.dispose();
    sanimationController.dispose();
  }

  /// Playanimation set forward reverse
  Future<Null> _PlayAnimation() async {
    try {
      await sanimationController.forward();
      await sanimationController.reverse();
    } on TickerCanceled {}
  }

  TickerController tickerController = TickerController();
  bool loginWithPhone = true;

  /// Component Widget layout UI
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    mediaQueryData.devicePixelRatio;
    mediaQueryData.size.width;
    mediaQueryData.size.height;

    var loginWithEmail2 = Column(
      children: <Widget>[
        /// TextFromField Email
        Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),

        textFromField(
          validate: EmailValidator.validate,
          textController: textEmailController,
          icon: Icons.email,
          password: false,
          email: "البريد الإلكتروني",
          inputType: TextInputType.emailAddress,
        ),
        Form(
          key: formGlobalKey,
          child: Column(
            children: <Widget>[
              /// TextFromField Password
              Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
              textFromField(
                validate: PasswordValidator.validate,
                textController: textPasswordController,
                icon: Icons.vpn_key,
                password: true,
                email: "كلمة المرور",
                inputType: TextInputType.text,
              ),

              /// Button Signup
              FlatButton(
                padding: EdgeInsets.only(top: 20.0),
                onPressed: () {
                  FirebaseService f = new FirebaseService();
                  f.getItem('1');
                },
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _warningMessage.isNotEmpty
                          ? Text(
                              _warningMessage,
                              style: TextStyle(
                                  color: Colors.brown,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Sans"),
                            )
                          : Padding(
                              padding: EdgeInsets.only(top: 0.0),
                            ),
                      _errorMessage.isNotEmpty
                          ? Text(
                              _errorMessage,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Sans"),
                            )
                          : Padding(
                              padding: EdgeInsets.only(top: 0.0),
                            ),
                      Text(
                        "ليس لديك حساب؟ سجل الآن",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.0,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Sans"),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: mediaQueryData.padding.top + 100.0, bottom: 0.0),
              )
            ],
          ),
        ),
      ],
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        /// Set Background image in layout (Click to open code)
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/img/desert.jpg"),
          fit: BoxFit.cover,
        )),
        child: Container(
          /// Set gradient color in image (Click to open code)
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(0, 0, 0, 0.0),
                Color.fromRGBO(0, 0, 0, 0.3)
              ],
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
            ),
          ),

          /// Set component layout
          child: ListView(
            children: <Widget>[
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        alignment: AlignmentDirectional.topCenter,
                        child: Column(
                          children: <Widget>[
                            /// padding logo
                            Padding(
                                padding: EdgeInsets.only(
                                    top: mediaQueryData.padding.top + 10.0)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image(
                                  image: AssetImage(
                                    "assets/launcher/rsz_icon_hourse.png",
                                  ),
                                  height: 70.0,
                                ),
//                                ClipRRect(
//                                  borderRadius:
//                                      BorderRadius.all(Radius.circular(40)),
//                                  child: Image(
//                                    image: AssetImage(
//                                      "assets/launcher/rsz_icon_hourse.png",
//                                    ),
//                                    height: 70.0,
//                                  ),
//                                ),
                                Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.0)),

                                /// Animation text treva shop accept from signup layout (Click to open code)
                                Hero(
                                  tag: "Treva",
                                  child: Text(
                                    "سوق الهفتاء",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.6,
                                        color: Colors.white,
                                        fontFamily: "Sans",
                                        fontSize: 20.0),
                                  ),
                                ),
                              ],
                            ),

                            /// ButtonCustomFacebook
//                            Padding(
//                                padding: EdgeInsets.symmetric(vertical: 30.0)),
//                            //buttonCustomFacebook(),
//
//                            /// ButtonCustomGoogle
//                            Padding(
//                                padding: EdgeInsets.symmetric(vertical: 7.0)),
//                            //buttonCustomGoogle(),
//
//                            /// Set Text
//                            Padding(
//                                padding: EdgeInsets.symmetric(vertical: 10.0)),
//                            Text(
//                              "أو",
//                              style: TextStyle(
//                                  fontWeight: FontWeight.w900,
//                                  color: Colors.white,
//                                  letterSpacing: 0.2,
//                                  fontFamily: 'Sans',
//                                  fontSize: 17.0),
//                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0)),
                            loginWithPhone
                                ?
                                // LoginWithMobile(
                                //     title: 'asdsds asd',
                                //   )
                                PhoneAuth()
                                : loginWithEmail2,

                            /// Set Animaion after user click buttonLogin
                            // tap == 0
                            //     ? InkWell(
                            //         splashColor: Colors.yellow,
                            //         onTap: submit,
                            //         child: buttonBlackBottom(_isLoging
                            //             ? "جاري الدخول..."
                            //             : "تسجيل الدخول"),
                            //       )
                            //     : new LoginAnimation(
                            //         animationController:
                            //             sanimationController.view,
                            //       ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Column(
                  //   children: <Widget>[
                  //     StreamBuilder(
                  //         stream: tickerController.tickerStream,
                  //         builder: (context, AsyncSnapshot<int> snapshot) {
                  //           if (snapshot.hasError) {
                  //             return Text('Error');
                  //           } else {
                  //             return Center(
                  //               child: Column(
                  //                 mainAxisAlignment: MainAxisAlignment.center,
                  //                 children: <Widget>[
                  //                   Text(
                  //                     snapshot.data.toString() +
                  //                         " Not Have Acount? Sign Up123",
                  //                     style: TextStyle(
                  //                         color: Colors.white,
                  //                         fontSize: 13.0,
                  //                         fontWeight: FontWeight.w600,
                  //                         fontFamily: "Sans"),
                  //                   ),
                  //                   RaisedButton(
                  //                     child: Text('+'),
                  //                     onPressed: () {
                  //                       tickerController.incrementSink
                  //                           .add(snapshot.data);
                  //                     },
                  //                   ),
                  //                   RaisedButton(
                  //                     child: Text('-'),
                  //                     onPressed: () {
                  //                       tickerController.decrementSink
                  //                           .add(snapshot.data);
                  //                     },
                  //                   )
                  //                 ],
                  //               ),
                  //             );
                  //           }
                  //         })
                  //   ],
                  // )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// textfromfield custom class
class textFromField extends StatelessWidget {
  bool password;
  String email;
  IconData icon;
  TextInputType inputType;
  TextEditingController textController;

  Function validate;

  textFromField(
      {this.email,
      this.icon,
      this.inputType,
      this.password,
      this.textController,
      this.validate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(
        height: 60.0,
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.0),
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 10.0, color: Colors.black12)]),
        padding:
            EdgeInsets.only(left: 20.0, right: 30.0, top: 0.0, bottom: 0.0),
        child: Theme(
          data: ThemeData(
            hintColor: Colors.transparent,
          ),
          child: TextFormField(
            validator: validate,
            controller: textController,
            obscureText: password,
            decoration: InputDecoration(
                border: InputBorder.none,
                labelText: email,
                icon: Icon(
                  icon,
                  color: Colors.black38,
                ),
                labelStyle: TextStyle(
                    fontSize: 15.0,
                    fontFamily: 'Sans',
                    letterSpacing: 0.3,
                    color: Colors.black38,
                    fontWeight: FontWeight.w600)),
            keyboardType: inputType,
          ),
        ),
      ),
    );
  }
}

///buttonCustomFacebook class
class buttonCustomFacebook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(
        alignment: FractionalOffset.center,
        height: 49.0,
        width: 500.0,
        decoration: BoxDecoration(
          color: Color.fromRGBO(107, 112, 248, 1.0),
          borderRadius: BorderRadius.circular(40.0),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 15.0)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/img/icon_facebook.png",
              height: 25.0,
            ),
            Padding(padding: EdgeInsets.symmetric(horizontal: 7.0)),
            Text(
              "الدخول بحساب فيسبوك",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Sans'),
            ),
          ],
        ),
      ),
    );
  }
}

///buttonCustomGoogle class
class buttonCustomGoogle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(
        alignment: FractionalOffset.center,
        height: 49.0,
        width: 500.0,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10.0)],
          borderRadius: BorderRadius.circular(40.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/img/google.png",
              height: 25.0,
            ),
            Padding(padding: EdgeInsets.symmetric(horizontal: 7.0)),
            Text(
              "الدخول بحساب جوجل",
              style: TextStyle(
                  color: Colors.black26,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Sans'),
            )
          ],
        ),
      ),
    );
  }
}

///ButtonBlack class
class buttonBlackBottom extends StatelessWidget {
  String _text;
  buttonBlackBottom(this._text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30.0),
      child: Container(
        height: 55.0,
        width: 600.0,
        child: Text(
          _text,
          style: TextStyle(
              color: Colors.white,
              letterSpacing: 0.2,
              fontFamily: "Sans",
              fontSize: 18.0,
              fontWeight: FontWeight.w800),
        ),
        alignment: FractionalOffset.center,
        decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 15.0)],
            borderRadius: BorderRadius.circular(30.0),
            gradient: LinearGradient(
                colors: <Color>[Color(0xFF121940), Color(0xFF6E48AA)])),
      ),
    );
  }
}
