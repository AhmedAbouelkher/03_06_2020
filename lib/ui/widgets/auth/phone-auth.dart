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
//      final AuthResult authResult = await ProviderCustom.of(context)
//          .auth
//          .signInWithPhoneNumber(textCodeController.text);
//      await ProviderCustom.of(context).auth.refreshUserData();
//      final User currentUser =
//          await ProviderCustom.of(context).auth.currentUser();
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
//      await ProviderCustom.of(context)
//          .auth
//          .verifyPhoneNumber(
//            phone: textPhoneController.text,
//            verificationCompleted: (authCredential) async {
//              //rdirect to home page
//              final AuthResult authResult = await ProviderCustom.of(context)
//                  .auth
//                  .signInWithCredential(authCredential)
//                  .catchError((onError) {
//                var ss;
//              });
//              await ProviderCustom.of(context).auth.refreshUserData();
//              final User currentUser =
//                  await ProviderCustom.of(context).auth.currentUser();
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
  double _height, _width, _fixedPadding;

  Widget _getColumnBody() =>
      Column(
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
            onChanged: (val){
              countryCode = val.toString();
            },
            // optional. Shows only country name and flag
            showCountryOnly: false,
            // optional. Shows only country name and flag when popup is closed.
            showOnlyCountryWhenClosed: false,
            // optional. aligns the flag and the Text left
            alignLeft: false,
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
              Provider
                  .of<PhoneAuthDataProvider>(context, listen: false)
                  .phoneNumberController,
              prefix: countryCode?? "+966",
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

          /*
           *  Button: OnTap of this, it appends the dial code and the phone number entered by the user to send OTP,
           *  knowing once the OTP has been sent to the user - the user will be navigated to a new Screen,
           *  where is asked to enter the OTP he has received on his mobile (or) wait for the system to automatically detect the OTP
           */
          SizedBox(height: _fixedPadding * 1.5),
          RaisedButton(
            elevation: 16.0,
            onPressed: startPhoneAuth,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'إرسال الكود',
                style: TextStyle(
                     fontSize: 18.0),
              ),
            ),
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
          ),
        ],
      );
  startPhoneAuth() async {
    final phoneAuthDataProvider =
        Provider.of<PhoneAuthDataProvider>(context, listen: false);
    phoneAuthDataProvider.loading = true;
    var countryProvider = Provider.of<CountryProvider>(context, listen: false);
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
      _showSnackBar("Oops! Number seems invaild");
      return;
    }
  }

  @override
  Widget build(BuildContext context) {

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _fixedPadding = _height * 0.025;


    final countriesProvider = Provider.of<CountryProvider>(context);
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
                boxShadow: [BoxShadow(blurRadius: 10.0, color: Colors.black12)]),
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

    return Column(
      children: <Widget>[
        _getColumnBody(),
        (Provider.of<PhoneAuthDataProvider>(context, listen: false).status !=
                    PhoneAuthState.CodeSent ||
                Provider.of<PhoneAuthDataProvider>(context, listen: false)
                        .status ==
                    null)
            ? phoneTextbox
            : Container(),
        Padding(
          padding: EdgeInsets.only(top: 10),
        ),
        (Provider.of<PhoneAuthDataProvider>(context, listen: false).status ==
                PhoneAuthState.CodeSent)
            ? codeTextbox
            : Container(),
        Text(
          errorMessage,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.2,
              fontFamily: 'Sans',
              fontSize: 17.0),
        ),
        InkWell(
          onTap: startPhoneAuth,
          // onTap: () => submit(context),
          child: Padding(
            padding: EdgeInsets.all(30.0),
            child: Container(
              height: 55.0,
              width: 600.0,
              child: Text(
                'التالي',
                style: TextStyle(
                    color: Colors.white,
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
                      colors: <Color>[Color(0xFF121940), Color(0xFF6E48AA)])),
            ),
          ),
        )
      ],
    );
  }
}
