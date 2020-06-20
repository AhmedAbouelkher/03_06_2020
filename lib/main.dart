import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haftaa/authentication/firebase-authenticate.dart';
import 'package:haftaa/bloc/product-bloc.dart';
import 'package:haftaa/product/product-provider.dart';
import 'package:haftaa/providers/countries.dart';
import 'package:haftaa/providers/phone_auth.dart';
import 'package:haftaa/services/dynamic_link_service.dart';
import 'package:haftaa/settings/settings_controller.dart';
import 'package:haftaa/ui/BottomNavigationBar.dart';
import 'package:haftaa/ui/LoginOrSignup/ChoseLoginOrSignup.dart';
import 'package:haftaa/ui/HomeUIComponent/Home.dart';
import 'package:haftaa/ui/LoginOrSignup/Login.dart';
import 'package:haftaa/ui/OnBoarding.dart';
import 'dart:async';

//import 'package:haftaa/Authentication/auth.dart';
import 'package:haftaa/provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase/auth/phone_auth/get_phone.dart';
import 'locator.dart';

/// Run first apps open
void main() {
  setupLocator();
  runApp(myApp());
}

/// Set orienttation
class myApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// To set orientation always portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    ///Set color status bar
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent, //or set color with: Color(0xFF0000FF)
    ));

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => PhoneAuthDataProvider()..currentuser(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductProvider()..startLoading(-1),
        ),
      ],
      child: MaterialApp(
        title: "سوق الهفتاء",
        theme: ThemeData(
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            primaryColorLight: Colors.white,
            primaryColorBrightness: Brightness.light,
            primaryColor: Colors.white),
        debugShowCheckedModeBanner: false,
        //home: AddProduct(),
        //home: testFirebase(),
        home: SplashScreen(),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: [const Locale('ar')],

        /// Move splash screen to ChoseLogin Layout
        /// Routes
        routes: <String, WidgetBuilder>{
          "onBoarding": (BuildContext context) => new onBoarding(),
          "home": (BuildContext context) => new bottomNavigationBar(),
          // "root": (BuildContext context) => new BottomNavigationBar(items: <BottomNavigationBarItem>[],),
          "choose-login": (BuildContext context) => new ChoseLogin(),
          "login": (BuildContext context) => new loginScreen(),

        },
      ),
//      child: MaterialApp(
//        home: PhoneAuthGetPhone(),
//        debugShowCheckedModeBanner: false,
//      ),
    );
//    return Provider(
//      auth: Auth(),
//      child: MaterialApp(
//        title: "سوق الهفتاء",
//        theme: ThemeData(
//            brightness: Brightness.light,
//            backgroundColor: Colors.white,
//            primaryColorLight: Colors.white,
//            primaryColorBrightness: Brightness.light,
//            primaryColor: Colors.white),
//        debugShowCheckedModeBanner: true,
//        //home: AddProduct(),
//        //home: testFirebase(),
//        home: SplashScreen(),
//        localizationsDelegates: [
//          GlobalMaterialLocalizations.delegate,
//          GlobalWidgetsLocalizations.delegate
//        ],
//        supportedLocales: [const Locale('ar')],
//
//        /// Move splash screen to ChoseLogin Layout
//        /// Routes
//        routes: <String, WidgetBuilder>{
//          "onBoarding": (BuildContext context) => new onBoarding(),
//          "home": (BuildContext context) => new bottomNavigationBar(),
//          // "root": (BuildContext context) => new BottomNavigationBar(items: <BottomNavigationBarItem>[],),
//          "choose-login": (BuildContext context) => new ChoseLogin(),
//        },
//      ),
//    );
  }
}

class testFirebase extends StatefulWidget {
  @override
  _testFirebaseState createState() => _testFirebaseState();
}

class _testFirebaseState extends State<testFirebase> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  FirebaseAuthenticate firebaseAuthenticate = FirebaseAuthenticate();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Firebase Auth'),
        ),
        body: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                Text('Register'),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(hintText: 'Email'),
                ),
                SizedBox(height: 26),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(hintText: 'Password'),
                ),
                SizedBox(height: 26),
                RaisedButton(
                  child: Text('Register'),
                  onPressed: () async {
                    String email = _emailController.text;
                    String password = _passwordController.text;
                    var user =
                        await firebaseAuthenticate.createUser(email, password);
                    print(user);
                  },
                )
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }
}

/// Component UI
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

/// Component UI
class _SplashScreenState extends State<SplashScreen> {
 // final DynamicLinkService _dynamicLinkService = locator<DynamicLinkService>();

  @override

  /// Setting duration in splash screen
  startTime(context) async {
    //await Provider.of<ProductProvider>(context).loadItems();

    return new Timer(Duration(milliseconds: 2000), NavigatorPage);
  }

  /// To navigate layout change
  void NavigatorPage() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool introDisplayed = await prefs.getBool('introDisplayed');
      if (introDisplayed == true) {
        Navigator.of(context).pushReplacementNamed("home");
      } else
        Navigator.of(context).pushReplacementNamed("onBoarding");
    } catch (e) {
      var ss;
    }
  }

  /// Declare startTime to InitState
  @override
  void initState() {
    super.initState();
  }

  var adIdFromExtrenalLink;

  @override
  void didChangeDependencies() {
//    _dynamicLinkService.handleDynamicLinks((title) {
//      if (title == null || title == '') {
      startTime(context);
//      } else {
//        //get product
//        adIdFromExtrenalLink = title;
//
//        //check type
//
//        //redirect to details
//      }
//    }, (error) {
//      startTime(context);
//    });
  }

  /// Code Create UI Splash Screen
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        /// Set Background image in splash screen layout (Click to open code)
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/solar_slash.png'),
                fit: BoxFit.cover)),
        child: Container(
          /// Set gradient black in image splash screen (Click to open code)
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                Color.fromRGBO(0, 0, 0, 0.3),
                Color.fromRGBO(0, 0, 0, 0.4)
              ],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter)),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 30.0),
                    ),

                    /// Text header "Welcome To" (Click to open code)
//                    Text(
//                      "هلا بيك في",
//                      style: TextStyle(
//                        color: Colors.white,
//                        fontWeight: FontWeight.w200,
//                        fontFamily: "Sans",
//                        fontSize: 19.0,
//                      ),
//                    ),
//
//                    /// Animation text Treva Shop to choose Login with Hero Animation (Click to open code)
//                    Hero(
//                      tag: "Haftaa",
//                      child: Text(
//                        "سوق الهفتاء",
//                        style: TextStyle(
//                          fontFamily: 'Sans',
//                          fontWeight: FontWeight.w900,
//                          fontSize: 35.0,
//                          letterSpacing: 0.4,
//                          color: Colors.white,
//                        ),
//                      ),
//                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
