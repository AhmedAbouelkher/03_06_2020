import 'package:flutter/material.dart';
import 'package:haftaa/ui/LoginOrSignup/ChoseLoginOrSignup.dart';

class LoginPlease extends StatelessWidget {
  String title;
  double imagePaddingTop = 50.0;
  double imageHeight = 300.0;
  LoginPlease({this.title, this.imagePaddingTop, this.imageHeight});
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      width: 500.0,
      color: Colors.white,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: mediaQueryData.padding.top)),
            Image.asset(
              "assets/imgIllustration/IlustrasiLogin.png",
              height: imageHeight,
            ),
            Padding(padding: EdgeInsets.only(bottom: 10.0)),
            Text(
              title ?? "سجل دخول من فضلك",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18.5,
                  color: Colors.black26.withOpacity(0.2),
                  fontFamily: "Popins"),
            ),
            Padding(padding: EdgeInsets.only(bottom: 10.0)),
            RawMaterialButton(
              onPressed: () async {
                Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (_, __, ___) => new ChoseLogin(),
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              constraints: BoxConstraints.tight(Size(300, 40)),
            )
          ],
        ),
      ),
    );
  }
}
