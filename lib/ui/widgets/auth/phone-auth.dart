import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haftaa/firebase/auth/phone_auth/verify.dart';
import 'package:haftaa/provider/provider.dart';
import 'package:haftaa/providers/countries.dart';
import 'package:haftaa/providers/phone_auth.dart';
import 'package:haftaa/ui/BottomNavigationBar.dart';
import 'package:haftaa/user/user.dart';
import 'package:haftaa/utils/widgets.dart';
import 'package:haftaa/validation/validators.dart';
import 'package:provider/provider.dart';

class PhoneAuth extends StatefulWidget {
  @override
  _PhoneAuthState createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  var textPhoneController = TextEditingController();
  var textCodeController = TextEditingController();
  var forceResendingToken;
  var verificationId;
  bool codeSent = false;

  double _height, _width, _fixedPadding;

  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  FocusNode focusNode5 = FocusNode();
  FocusNode focusNode6 = FocusNode();
  String code = "";
  bool checkBoxValue = false;

  final scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: "scaffold-get-phone");

  submit(BuildContext context) {
    if (textPhoneController.text == null ||
        textPhoneController.text.trim().isEmpty) {
      setState(() {
        errorMessage = 'أدخل رقم الجوال من فضلك';
      });
      return;
    }
    // if (!codeSent)
    //verifyPhoneNO(context);
    //else
    //signIn(context);
  }

//  signIn(BuildContext context) async {
//    if (textCodeController.text == null ||
//        textCodeController.text.trim() == '') {
//      setState(() {
//        errorMessage = 'أدخل الكود';
//      });
//
//      return;
//    }
//    try {
//      final AuthResult authResult = await Provider.of<ProductProvider>(context)
//          .auth
//          .signInWithPhoneNumber(textCodeController.text);
//      await Provider.of<ProductProvider>(context).auth.refreshUserData();
//      final User currentUser =
//          await Provider.of<ProductProvider>(context).auth.currentUser();
//      assert(authResult.user.uid == currentUser.id);
//
//      Navigator.pushAndRemoveUntil(
//        context,
//        MaterialPageRoute(
//            builder: (BuildContext context) => bottomNavigationBar()),
//        ModalRoute.withName('/'),
//      );
//    } catch (e) {
//      handleError(e);
//    }
//  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        setState(() {
          errorMessage = 'Invalid Code';
        });

        break;
      default:
        setState(() {
          errorMessage = error.message;
        });

        break;
    }
  }

//
//  Future<void> verifyPhoneNO(BuildContext context) async {
//    try {
//      setState(() {
//        errorMessage = '';
//      });
//      await Provider.of<ProductProvider>(context)
//          .auth
//          .verifyPhoneNumber(
//            phone: textPhoneController.text,
//            verificationCompleted: (authCredential) async {
//              //rdirect to home page
//              final AuthResult authResult = await Provider.of<ProductProvider>(context)
//                  .auth
//                  .signInWithCredential(authCredential)
//                  .catchError((onError) {
//                var ss;
//              });
//              await Provider.of<ProductProvider>(context).auth.refreshUserData();
//              final User currentUser =
//                  await Provider.of<ProductProvider>(context).auth.currentUser();
//              assert(authResult.user.uid == currentUser.id);
//
//              Navigator.pushAndRemoveUntil(
//                context,
//                MaterialPageRoute(
//                    builder: (BuildContext context) => bottomNavigationBar()),
//                ModalRoute.withName('/'),
//              );
//            },
//            verificationFailed: (authException) {
//              setState(() {
//                errorMessage = authException.message;
//              });
//            },
//            codeSent: (_verificationId, [_forceResendingToken]) {
//              setState(() {
//                codeSent = true;
//              });
//            },
//            codeAutoRetrievalTimeout: (verificationId) {},
//          )
//          .catchError((onError) {
//        var ss;
//      });
//    } catch (error) {
//      var error;
//    }
//  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String errorMessage = '';
  String countryCode = '';

  _showSnackBar(String text) {
    final snackBar = SnackBar(
      content: Text('$text'),
    );
//    if (mounted) Scaffold.of(context).showSnackBar(snackBar);
    //scaffoldKey.currentState.showSnackBar(snackBar);
  }

  signIn() {
    if (code.length != 6) {
      _showSnackBar("كود غير صالح");
    }
    Provider.of<PhoneAuthDataProvider>(context, listen: false)
        .verifyOTPAndLogin(smsCode: code);
  }

  // This will return pin field - it accepts only single char
  Widget getPinField({String key, FocusNode focusNode}) => SizedBox(
        height: 40.0,
        width: 35.0,
        child: TextField(
          key: Key(key),
          expands: false,
//          autofocus: key.contains("1") ? true : false,
          autofocus: false,
          focusNode: focusNode,
          onChanged: (String value) {
            if (value.length == 1) {
              code += value;
              switch (code.length) {
                case 1:
                  FocusScope.of(context).requestFocus(focusNode2);
                  break;
                case 2:
                  FocusScope.of(context).requestFocus(focusNode3);
                  break;
                case 3:
                  FocusScope.of(context).requestFocus(focusNode4);
                  break;
                case 4:
                  FocusScope.of(context).requestFocus(focusNode5);
                  break;
                case 5:
                  FocusScope.of(context).requestFocus(focusNode6);
                  break;
                default:
                  FocusScope.of(context).requestFocus(FocusNode());
                  break;
              }
            }
          },
          maxLengthEnforced: false,
          textAlign: TextAlign.center,
          cursorColor: Colors.white,
          keyboardType: TextInputType.number,
          style: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.white),
//          decoration: InputDecoration(
//              contentPadding: const EdgeInsets.only(
//                  bottom: 10.0, top: 10.0, left: 4.0, right: 4.0),
//              focusedBorder: OutlineInputBorder(
//                  borderRadius: BorderRadius.circular(5.0),
//                  borderSide:
//                      BorderSide(color: Colors.blueAccent, width: 2.25)),
//              border: OutlineInputBorder(
//                  borderRadius: BorderRadius.circular(5.0),
//                  borderSide: BorderSide(color: Colors.white))),
        ),
      );

  Widget _getColumnBody() => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          //  Logo: scaling to occupy 2 parts of 10 in the whole height of device
          Padding(
            padding: EdgeInsets.all(_fixedPadding),
          ),

          // AppName:

          Padding(
            padding: EdgeInsets.only(top: _fixedPadding, left: _fixedPadding),
            child: SubTitle(text: 'اختر الدولة'),
          ),
          CountryCodePicker(
            initialSelection: "sa",
            onInit: (code) {
              countryCode = code.toString();
            },
            onChanged: (val) {
              countryCode = val.toString();
            },
            favorite: [
              'KW',
              'SA',
              'AE',
              'QA',
              'BH',
              'OM',
              'JO',
              'EG',
              'SD',
              'PK'
            ],

            // optional. Shows only country name and flag
            showCountryOnly: false,
            // optional. Shows only country name and flag when popup is closed.
            showOnlyCountryWhenClosed: false,
            // optional. aligns the flag and the Text left
            alignLeft: true,
            textStyle: TextStyle(color: Colors.white),
          ),
          /*
           *  Select your country, this will be a custom DropDown menu, rather than just as a dropDown
           *  onTap of this, will show a Dialog asking the user to select country they reside,
           *  according to their selection, prefix will change in the PhoneNumber TextFormField
           */
//          Padding(
//              padding:
//              EdgeInsets.only(left: _fixedPadding, right: _fixedPadding),
//              child: ShowSelectedCountry(
//                country: countriesProvider.selectedCountry,
//                onPressed: () {
//                  Navigator.of(context).push(
//                    MaterialPageRoute(builder: (context) => SelectCountry()),
//                  );
//                },
//              )),

          //  Subtitle for Enter your phone
          Padding(
            padding: EdgeInsets.only(top: 10.0, left: _fixedPadding),
            child: SubTitle(text: 'اكتب رقم الجوال'),
          ),
          //  PhoneNumber TextFormFields
          Padding(
            padding: EdgeInsets.only(
                left: _fixedPadding,
                right: _fixedPadding,
                bottom: _fixedPadding),
            child: PhoneNumberField(
              controller:
                  Provider.of<PhoneAuthDataProvider>(context, listen: false)
                      .phoneNumberController,
              prefix: countryCode ?? "+966",
            ),
          ),

          /*
           *  Some informative text
           */
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(width: _fixedPadding),
              Icon(Icons.info, color: Colors.white, size: 20.0),
              SizedBox(width: 10.0),
              Expanded(
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: ' سيتم إرسال',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w400)),
                  TextSpan(
                      text: ' كلمة سر لمرة واحدة ',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700)),
                  TextSpan(
                      text: ' لرقم الجوال هذا',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w400)),
                ])),
              ),
              SizedBox(width: _fixedPadding),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(width: _fixedPadding),
              Checkbox(
                  value: checkBoxValue,
                  activeColor: Colors.green,
                  onChanged: (bool newValue) {
                    setState(() {
                      checkBoxValue = newValue;
                    });
                  }),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        // return object of type Dialog
                        return AlertDialog(
                          title: new Text("شروط استخدام التطبيق"),
                          content: ListView(
                            scrollDirection: Axis.vertical,
                            children: <Widget>[
                              Text(
                                  "لالالالافايسئبخلبعراسخلرعلااقبعخببيخهلاتىيخبلاهيلاهلالالالافايسئبخلبعراسخلرعلااقبعخببيخهلاتىيخبلاهيلاهلالالالافايسئبخلبعراسخلرعلااقبعخببيخهلاتىيخبلاهيلاهلالالالافايسئبخلبعراسخلرعلااقبعخببيخهلاتىيخبلاهيلاهلالالالافايسئبخلبعراسخلرعلااقبعخببيخهلاتىيخبلاهيلاهلالالالافايسئبخلبعراسخلرعلااقبعخببيخهلاتىيخبلاهيلاهلالالالافايسئبخلبعراسخلرعلااقبعخببيخهلاتىيخبلاهيلاهلالالالافايسئبخلبعراسخلرعلااقبعخببيخهلاتىيخبلاهيلاهلالالالافايسئبخلبعراسخلرعلااقبعخببيخهلاتىيخبلاهيلاهلالالالافايسئبخلبعراسخلرعلااقبعخببيخهلاتىيخبلاهيلاهلالالالافايسئبخلبعراسخلرعلااقبعخببيخهلاتىيخبلاهيلاهلالالالافايسئبخلبعراسخلرعلااقبعخببيخهلاتىيخبلاهيلاهلالالالافايسئبخلبعراسخلرعلااقبعخببيخهلاتىيخبلاهيلاهلالالالافايسئبخلبعراسخلرعلااقبعخببيخهلاتىيخبلاهيلاهلالالالافايسئبخلبعراسخلرعلااقبعخببيخهلاتىيخبلاهيلاهلالالالافايسئبخلبعراسخلرعلااقبعخببيخهلاتىيخبلاهيلاهلالالالافايسئبخلبعراسخلرعلااقبعخببيخهلاتىيخبلاهيلاهلالالالافايسئبخلبعراسخلرعلااقبعخببيخهلاتىيخبلاهيلاهلالالالافايسئبخلبعراسخلرعلااقبعخببيخهلاتىيخبلاهيلاهلالالالافايسئبخلبعراسخلرعلااقبعخببيخهلاتىيخبلاهيلاهلالالالافايسئبخلبعراسخلرعلااقبعخببيخهلاتىيخبلاهيلاهلالالالافايسئبخلبعراسخلرعلااقبعخببيخهلاتىيخبلاهيلاهلالالالافايسئبخلبعراسخلرعلااقبعخببيخهلاتىيخبلاهيلاهلالالالافايسئبخلبعراسخلرعلااقبعخببيخهلاتىيخبلاهيلاهلالالالافايسئبخلبعراسخلرعلااقبعخببيخهلاتىيخبلاهيلاهلالالالافايسئبخلبعراسخلرعلااقبعخببيخهلاتىيخبلاهيلاهلالالالافايسئبخلبعراسخلرعلااقبعخببيخهلاتىيخبلاهيلاهلالالالافايسئبخلبعراسخلرعلااقبعخببيخهلاتىيخبلاهيلاهلالالالافايسئبخلبعراسخلرعلااقبعخببيخهلاتىيخبلاهيلاهلالالالافايسئبخلبعراسخلرعلااقبعخببيخهلاتىيخبلاهيلاهلالالالافايسئبخلبعراسخلرعلااقبعخببيخهلاتىيخبلاهيلاه"),
                            ],
                          ),
                          actions: <Widget>[
                            // usually buttons at the bottom of the dialog
                            new FlatButton(
                              child: new Text("إغلاق"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: 'موافق على ',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w400)),
                    TextSpan(
                        text: 'شروط استخدام التطبيق',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700)),
                  ])),
                ),
              ),
              SizedBox(width: _fixedPadding),
            ],
          ),
          /*
           *  Button: OnTap of this, it appends the dial code and the phone number entered by the user to send OTP,
           *  knowing once the OTP has been sent to the user - the user will be navigated to a new Screen,
           *  where is asked to enter the OTP he has received on his mobile (or) wait for the system to automatically detect the OTP
           */

          SizedBox(height: _fixedPadding * 1.5),

//          RaisedButton(
//            elevation: 16.0,
//            onPressed: startPhoneAuth,
//            child: Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: Text(
//                'إرسال الكود',
//                style: TextStyle(
//                     fontSize: 18.0),
//              ),
//            ),
//            color: Colors.white,
//            shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.circular(30.0)),
//          ),
        ],
      );

  startPhoneAuth(context) async {
    final phoneAuthDataProvider =
        Provider.of<PhoneAuthDataProvider>(context, listen: false);
    phoneAuthDataProvider.loading = true;
    bool validPhone = await phoneAuthDataProvider.instantiate(
        dialCode: countryCode,
        onCodeSent: () {
          Navigator.of(context).pushReplacement(CupertinoPageRoute(
              builder: (BuildContext context) => PhoneAuthVerify()));
        },
        onFailed: () {
          _showSnackBar(phoneAuthDataProvider.message);
        },
        onError: () {
          _showSnackBar(phoneAuthDataProvider.message);
        });
    if (!validPhone) {
      phoneAuthDataProvider.loading = false;
      _showSnackBar("الرقم غير صالح");
      return;
    }
  }

  onStarted() {
    _showSnackBar("بدء التسجيل");
//    _showSnackBar(phoneAuthDataProvider.message);
  }

  onCodeSent() {
    _showSnackBar("تم إرسال الكود");
//    _showSnackBar(phoneAuthDataProvider.message);
  }

  onCodeResent() {
    _showSnackBar("تم إعادة إرسال الكود");
//    _showSnackBar(phoneAuthDataProvider.message);
  }

  onVerified() async {
    _showSnackBar(
        "${Provider.of<PhoneAuthDataProvider>(context, listen: false).message}");
    await Future.delayed(Duration(seconds: 1));
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => bottomNavigationBar()),
      ModalRoute.withName('/'),
    );
//
//    Navigator.of(context)
//        .push(MaterialPageRoute(builder: (BuildContext context) => LetsChat()));
  }

  onFailed() {
//    _showSnackBar(phoneAuthDataProvider.message);
    _showSnackBar("PhoneAuth failed");
  }

  onError() {
//    _showSnackBar(phoneAuthDataProvider.message);
    _showSnackBar(
        "خطأ دخول ${Provider.of<PhoneAuthDataProvider>(context, listen: false).message}");
  }

  onAutoRetrievalTimeOut() {
    _showSnackBar("انتهى وقت استرداد الكود");

    //_showSnackBar("PhoneAuth autoretrieval timeout");
//    _showSnackBar(phoneAuthDataProvider.message);
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _fixedPadding = _height * 0.025;

    final phoneAuthDataProvider =
        Provider.of<PhoneAuthDataProvider>(context, listen: false);

    phoneAuthDataProvider.setMethods(
      onStarted: onStarted,
      onError: onError,
      onFailed: onFailed,
      onVerified: onVerified,
      onCodeResent: onCodeResent,
      onCodeSent: onCodeSent,
      onAutoRetrievalTimeout: onAutoRetrievalTimeOut,
    );

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _fixedPadding = _height * 0.025;

//    final countriesProvider = Provider.of<CountryProvider>(context);
    final loader = Provider.of<PhoneAuthDataProvider>(context).loading;

    var phoneTextbox = Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: <Widget>[
          Container(
            height: 60.0,
            alignment: AlignmentDirectional.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(blurRadius: 10.0, color: Colors.black12)
                ]),
            padding:
                EdgeInsets.only(left: 20.0, right: 30.0, top: 0.0, bottom: 0.0),
            child: Theme(
              data: ThemeData(
                hintColor: Colors.transparent,
              ),
              child: TextFormField(
                validator: Validators.notEmptyText,
                controller: textPhoneController,
                //obscureText: password,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'رقم الجوال',
                    icon: Icon(
                      Icons.phone_iphone,
                      color: Colors.black38,
                    ),
                    labelStyle: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Sans',
                        letterSpacing: 0.3,
                        color: Colors.black38,
                        fontWeight: FontWeight.w600)),
                keyboardType: TextInputType.phone,
              ),
            ),
          ),
        ],
      ),
    );
    var codeTextbox = Padding(
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
            validator: Validators.notEmptyText,
            controller: textCodeController,
            //obscureText: password,
            decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'الكود',
                icon: Icon(
                  Icons.cloud_done,
                  color: Colors.black38,
                ),
                labelStyle: TextStyle(
                    fontSize: 15.0,
                    fontFamily: 'Sans',
                    letterSpacing: 0.3,
                    color: Colors.black38,
                    fontWeight: FontWeight.w600)),
            keyboardType: TextInputType.phone,
          ),
        ),
      ),
    );

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/img/desert.jpg"),
            fit: BoxFit.cover,
          )),
          child: Column(
            children: <Widget>[
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
                  Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),

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
              _getColumnBody(),
              InkWell(
                onTap: () {
                   checkBoxValue?startPhoneAuth(context):null;
//                  Scaffold.of(context).showSnackBar(
//                      SnackBar(content: new Text('test message')));
                },
                // onTap: () => submit(context),
                child: Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Container(
                    height: 55.0,
                    width: 600.0,
                    child: Text(
                      'إرسال الكود',
                      style: TextStyle(
                          color: !checkBoxValue ? Colors.white30 : Colors.white,
                          letterSpacing: 0.2,
                          fontFamily: "Sans",
                          fontSize: 18.0,
                          fontWeight: FontWeight.w800),
                    ),
                    alignment: FractionalOffset.center,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(color: Colors.black38, blurRadius: 15.0)
                        ],
                        borderRadius: BorderRadius.circular(30.0),
                        gradient: LinearGradient(
                            colors: !checkBoxValue
                                ? <Color>[Color(0xFF5d5c7b), Color(0xFF5d5c7b)]
                                : <Color>[
                                    Color(0xFF121940),
                                    Color(0xFF6E48AA)
                                  ])),
                  ),
                ),
              ),
              //getPinField(),
//        (Provider.of<PhoneAuthDataProvider>(context, listen: false).status !=
//                    PhoneAuthState.CodeSent ||
//                Provider.of<PhoneAuthDataProvider>(context, listen: false)
//                        .status ==
//                    null)
//            ? phoneTextbox
//            : Container(),
//        Padding(
//          padding: EdgeInsets.only(top: 10),
//        ),
//        (Provider.of<PhoneAuthDataProvider>(context, listen: false).status ==
//                PhoneAuthState.CodeSent)
//            ? codeTextbox
//            : Container(),
//        Text(
//          errorMessage,
//          style: TextStyle(
//              fontWeight: FontWeight.w600,
//              color: Colors.white,
//              letterSpacing: 0.2,
//              fontFamily: 'Sans',
//              fontSize: 17.0),
//        ),
            ],
          ),
        ),
      ),
    );
  }
}
