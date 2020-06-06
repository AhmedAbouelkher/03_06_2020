import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haftaa/ui/BottomNavigationBar.dart';
import 'package:haftaa/ui/LoginOrSignup/Login.dart';
import 'package:haftaa/ui/LoginOrSignup/LoginAnimation.dart';
import 'package:haftaa/ui/LoginOrSignup/Signup.dart';
import 'package:haftaa/provider/provider.dart';
import 'package:haftaa/ui/widgets/auth/phone-auth.dart';
import 'package:haftaa/validation/validators.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> with TickerProviderStateMixin {
  //Animation Declaration
  AnimationController sanimationController;
  AnimationController animationControllerScreen;
  Animation animationScreen;
  var tap = 0;
  final formGlobalKey = GlobalKey<FormState>();
  TextEditingController textEmailController = TextEditingController();
  TextEditingController textPasswordController = TextEditingController();
  String _email, _password;
  String _errorMessage = '';
  String _warningMessage = '';

  bool _isRegistring = false;
  void submit() async {
    if (_isRegistring) {
      _warningMessage = 'انتظر من فضلك...';
      return;
    }
    _warningMessage = '';
    if (validate()) {
//      try {
//        final auth = Provider.of<ProductProvider>(context).auth;
//
//        setState(() {
//          _isRegistring = true;
//        });
//
//        String userId = await auth.createUserWithEmailAndPassword(
//          _email,
//          _password,
//        );
//        await auth.refreshUserData(userid: userId);
//        setState(() {
//          _isRegistring = false;
//        });
//
//        _PlayAnimation();
//        Navigator.pushAndRemoveUntil(
//          context,
//          MaterialPageRoute(
//              builder: (BuildContext context) => bottomNavigationBar()),
//          ModalRoute.withName('/'),
//        );
//      } catch (e) {
//        setState(() {
//          _isRegistring = false;
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

  /// Set AnimationController to initState
  @override
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

  /// Dispose animationController
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

  bool loginWithPhone = true;

  /// Component Widget layout UI
  @override
  Widget build(BuildContext context) {
    //verifyPhoneNO(context);

    MediaQueryData mediaQueryData = MediaQuery.of(context);
    mediaQueryData.devicePixelRatio;
    mediaQueryData.size.height;
    mediaQueryData.size.width;

    var loginWithEmailform = Form(
      key: formGlobalKey,
      child: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.symmetric(vertical: 50.0)),

          /// TextFromField Email
          textFromField(
            validate: EmailValidator.validate,
            textController: textEmailController,
            icon: Icons.email,
            password: false,
            email: "البريد الإلكتروني",
            inputType: TextInputType.emailAddress,
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),

          /// TextFromField Password
          textFromField(
            validate: PasswordValidator.validate,
            textController: textPasswordController,
            icon: Icons.vpn_key,
            password: true,
            email: "كلمة المرور",
            inputType: TextInputType.text,
          ),
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

          /// Button Login
          FlatButton(
              padding: EdgeInsets.only(top: 20.0),
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => new loginScreen()));
              },
              child: Text(
                "لديك حساب؟ ادخل من هنا",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Sans"),
              )),
          Padding(
            padding: EdgeInsets.only(
                top: mediaQueryData.padding.top + 100.0, bottom: 0.0),
          )
        ],
      ),
    );
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            /// Set Background image in layout
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage("assets/img/camel-boys.jpg"),
              fit: BoxFit.cover,
            )),
            child: Container(
              /// Set gradient color in image
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(0, 0, 0, 0.2),
                    Color.fromRGBO(0, 0, 0, 0.3)
                  ],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                ),
              ),

              /// Set component layout
              child: ListView(
                padding: EdgeInsets.all(0.0),
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
                                        top:
                                            mediaQueryData.padding.top + 40.0)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image(
                                      image: AssetImage("assets/img/Logo.png"),
                                      height: 50.0,
                                    ),
                                    Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.0)),

                                    /// Animation text treva shop accept from login layout
                                    Hero(
                                      tag: "Haftaa",
                                      child: Text(
                                        "سوق الهفتاء",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 0.6,
                                            fontFamily: "Sans",
                                            color: Colors.white,
                                            fontSize: 20.0),
                                      ),
                                    ),
                                  ],
                                ),

                                loginWithPhone
                                    ?
                                    // LoginWithMobile(
                                    //     title: 'asdsds asd',
                                    //   )
                                    Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 90.0),
                                        child: PhoneAuth(),
                                      )
                                    : loginWithEmailform,
                              ],
                            ),
                          ),
                        ],
                      ),

                      /// Set Animaion after user click buttonLogin
                      // tap == 0
                      //     ? InkWell(
                      //         splashColor: Colors.yellow,
                      //         onTap: submit,

                      //         // () {

                      //         //   setState(() {
                      //         //     tap = 1;
                      //         //   });
                      //         //   _PlayAnimation();
                      //         //   return tap;
                      //         // },
                      //         child: buttonBlackBottom(
                      //             _isRegistring ? "جاري التسجيل..." : "تسجيل"),
                      //       )
                      //     : new LoginAnimation(
                      //         animationController: sanimationController.view,
                      //       )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
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
