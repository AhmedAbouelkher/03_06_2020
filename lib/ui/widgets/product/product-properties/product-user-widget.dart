import 'package:flutter/material.dart';

import 'package:haftaa/user/user.dart';

class ProductUserWidget extends StatefulWidget {
  Future<User> _user;
  TextStyle _textStyle;
  bool showMobile;
  ProductUserWidget(this._user, this._textStyle, this.showMobile);

  @override
  _ProductUserWidgetState createState() => _ProductUserWidgetState();
}

class _ProductUserWidgetState extends State<ProductUserWidget> {
   Future<User> _user;
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _user= widget._user;
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _user,
      builder: (context, AsyncSnapshot<User> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Container(
              child: Text('تحميل ..'),
            );
            break;
          default:
            if (snapshot.hasError) {
              return Container(
                child: Text('مشكلة في التحميل..'),
              );
            } else if (!snapshot.hasData) {
              return Container(
                child: Text('لا يوجد بيانات'),
              );
            } else {
              return Text(

                widget.showMobile?snapshot.data.name?? snapshot.data.email??snapshot.data.mobile:'إعلانات المستخدم' ,
                textAlign: TextAlign.right,
                textDirection: TextDirection.ltr,
                style: widget._textStyle,

              );
            }
        }
      },
    );
  }
}
