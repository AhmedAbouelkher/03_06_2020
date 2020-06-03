import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:haftaa/validation/validators.dart';

class LoginWithMobile extends StatefulWidget {
  LoginWithMobile({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LoginWithMobileState createState() => _LoginWithMobileState();
}

class _LoginWithMobileState extends State<LoginWithMobile> {
  String phoneNo;
  String smsOTP;
  String verificationId;
  String errorMessage = '';
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> verifyPhone() async {
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsOTPDialog(context).then((value) {
        print('sign in');
      });
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: '+201003831194', // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
            this.verificationId = verId;
          },
          codeSent:
              smsOTPSent, // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 60),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print(phoneAuthCredential);
          },
          verificationFailed: (AuthException exceptio) {
            print('${exceptio.message}');
          });
    } catch (e) {
      handleError(e);
    }
  }

  Future<bool> smsOTPDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter SMS Code'),
            content: Container(
              height: 85,
              child: Column(children: [
                TextField(
                  onChanged: (value) {
                    this.smsOTP = value;
                  },
                ),
                (errorMessage != ''
                    ? Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                      )
                    : Container())
              ]),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              FlatButton(
                child: Text('Done'),
                onPressed: () {
                  _auth.currentUser().then((user) {
                    if (user != null) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacementNamed('/homepage');
                    } else {
                      signIn();
                    }
                  });
                },
              )
            ],
          );
        });
  }

  signIn() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      final AuthResult authResult =
          await _auth.signInWithCredential(credential);
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(authResult.user.uid == currentUser.uid);
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/homepage');
    } catch (e) {
      handleError(e);
    }
  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
        });
        Navigator.of(context).pop();
        smsOTPDialog(context).then((value) {
          print('sign in');
        });
        break;
      default:
        setState(() {
          errorMessage = error.message;
        });

        break;
    }
  }
var textPhoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Container(
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
        ),
          // Padding(
          //   padding: EdgeInsets.all(10),
          //   child: TextField(

          //     decoration: InputDecoration(
          //         hintText: 'Enter Phone Number Eg. +910000000000'),
          //     onChanged: (value) {
          //       this.phoneNo = value;
          //     },
          //   ),
          // ),
          (errorMessage != ''
              ? Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                )
              : Container()),
          SizedBox(
            height: 10,
          ),
          RaisedButton(
            onPressed: () {
              verifyPhone();
            },
            child: Text('Verify'),
            textColor: Colors.white,
            elevation: 7,
            color: Colors.blue,
          )
        ],
      ),
    );
  }
}
