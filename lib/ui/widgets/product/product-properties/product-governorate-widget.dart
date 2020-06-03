import 'package:flutter/material.dart';
import 'package:haftaa/governorate/governorate.dart';

class ProductGovernorateWidget extends StatefulWidget {
  Future<Governorate> _governorate;
  TextStyle _textStyle;
  ProductGovernorateWidget(this._governorate, this._textStyle);

  @override
  _ProductGovernorateWidgetState createState() =>
      _ProductGovernorateWidgetState();
}

class _ProductGovernorateWidgetState extends State<ProductGovernorateWidget> {
  Future<Governorate> _governorate;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _governorate = widget._governorate;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _governorate,
      builder: (context, AsyncSnapshot<Governorate> snapshot) {
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
                child: Text('خطأ:المحافظة غير متاحة'),
              );
            } else if (!snapshot.hasData) {
              return Container(
                child: Text('لا يوجد بيانات'),
              );
            } else {
              return Text(
                snapshot.data.title,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: widget._textStyle,
              );
            }
        }
      },
    );
  }
}
