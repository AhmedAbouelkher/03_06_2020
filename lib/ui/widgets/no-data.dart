import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  String title;
  double imagePaddingTop = 50.0;
  double imageHeight = 300.0;
  NoData({this.title, this.imagePaddingTop, this.imageHeight});
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
              "assets/imgIllustration/IlustrasiCart.png",
              height: imageHeight,
            ),
            Padding(padding: EdgeInsets.only(bottom: 10.0)),
            Text(
              title ?? "لا يوجد بيانات",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15.5,
                  color: Colors.black26.withOpacity(0.2),
                  fontFamily: "Popins"),
            ),
          ],
        ),
      ),
    );
  }
}
