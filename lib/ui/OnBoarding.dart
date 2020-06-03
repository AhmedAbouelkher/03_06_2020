import 'package:flutter/material.dart';
import 'package:haftaa/Library/intro_views_flutter-2.4.0/lib/Models/page_view_model.dart';
import 'package:haftaa/Library/intro_views_flutter-2.4.0/lib/intro_views_flutter.dart';
import 'package:haftaa/ListItem/ProductList.dart';
import 'package:haftaa/ui/BottomNavigationBar.dart';
import 'package:haftaa/ui/LoginOrSignup/ChoseLoginOrSignup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class onBoarding extends StatefulWidget {
  @override
  _onBoardingState createState() => _onBoardingState();
}

var _fontHeaderStyle = TextStyle(
    fontFamily: "Popins",
    fontSize: 21.0,
    fontWeight: FontWeight.w800,
    color: Colors.black87,
    letterSpacing: 1.5);

var _fontDescriptionStyle = TextStyle(
    fontFamily: "Sans",
    fontSize: 15.0,
    color: Colors.black26,
    fontWeight: FontWeight.w400);

///
/// Page View Model for on boarding
///
final pages = [
  new PageViewModel(
      pageColor: Colors.white,
      iconColor: Colors.black,
      bubbleBackgroundColor: Colors.black,
      title: Text(
        'بيع أي شيء',
        style: _fontHeaderStyle,
      ),
      body: Container(
        height: 250.0,
        child: Text(
            'تستطيع هنا عرض ما تريد بيعه على كل المستخدمين حيث نوفر التواصل بينكما بسهولة',
            textAlign: TextAlign.center,
            style: _fontDescriptionStyle),
      ),
      mainImage: Image.asset(
        'assets/imgIllustration/IlustrasiOnBoarding1.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      )),
  new PageViewModel(
      pageColor: Colors.white,
      iconColor: Colors.black,
      bubbleBackgroundColor: Colors.black,
      title: Text(
        'أيضاً اطلب أي شيء',
        style: _fontHeaderStyle,
      ),
      body: Container(
        height: 250.0,
        child: Text(
            'تستطيع طلب شيء تريد شراؤه وسنوفر لك وسيله التواصل بينكما بسهولة وسرعه ويسر',
            textAlign: TextAlign.center,
            style: _fontDescriptionStyle),
      ),
      mainImage: Image.asset(
        'assets/imgIllustration/find-it.jpg',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      )),
  new PageViewModel(
      pageColor: Colors.white,
      iconColor: Colors.black,
      bubbleBackgroundColor: Colors.black,
      title: Text(
        'أيضاً المزادات!',
        style: _fontHeaderStyle,
      ),
      body: Container(
        height: 250.0,
        child: Text(
            'تسطيع أيضاً بعرض ما تريد بيعه للمزاد العلني حيث يتفاعل معك المستخدمين المزايدين حتى ينتهي المزاد لأحدهم',
            textAlign: TextAlign.center,
            style: _fontDescriptionStyle),
      ),
      mainImage: Image.asset(
        'assets/imgIllustration/biddings.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      )),
];

class _onBoardingState extends State<onBoarding> {
  @override
  Widget build(BuildContext context) {
    return IntroViewsFlutter(
      pages,
      pageButtonsColor: Colors.black45,
      skipText: Text(
        "تخطى",
        style: _fontDescriptionStyle.copyWith(
            color: Colors.deepPurpleAccent,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0),
      ),
      doneText: Text(
        "انتهاء",
        style: _fontDescriptionStyle.copyWith(
            color: Colors.deepPurpleAccent,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0),
      ),
      onTapDoneButton: () async {
        //set refrence variable
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('introDisplayed', true);

        //navigate to home page
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => new bottomNavigationBar()));

        //navigate to chose login page
        // Navigator.of(context).pushReplacement(PageRouteBuilder(
        //   pageBuilder: (_, __, ___) => new ChoseLogin(),
        //   transitionsBuilder:
        //       (_, Animation<double> animation, __, Widget widget) {
        //     return Opacity(
        //       opacity: animation.value,
        //       child: widget,
        //     );
        //   },
        //   transitionDuration: Duration(milliseconds: 1500),
        // ));
      },
    );
  }
}
