import 'package:flutter/material.dart';

class CannotEdit extends StatelessWidget {
  String title;
  double imagePaddingTop = 50.0;
  double imageHeight = 300.0;
  CannotEdit({this.title, this.imagePaddingTop, this.imageHeight});
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
            Padding(
                padding: EdgeInsets.only(
                    top: mediaQueryData.padding.top )),
            Image.asset(
              "assets/imgIllustration/biddings.png",
              height: imageHeight,
            ),
            Padding(padding: EdgeInsets.only(bottom: 10.0)),
            Text(
              title ?? "غير مسموح بالتعديل",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18.5,
                  color: Colors.black54,
                  fontFamily: "Popins"),
            ),
          ],
        ),
      ),
    );
  }
}
