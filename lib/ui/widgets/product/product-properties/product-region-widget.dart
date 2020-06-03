import 'package:flutter/material.dart';
import 'package:haftaa/region/region.dart';

class ProductRegionWidget extends StatefulWidget {
  Future<Region> _region;
  TextStyle _textStyle;
  ProductRegionWidget(this._region, this._textStyle);

  @override
  _ProductRegionWidgetState createState() => _ProductRegionWidgetState();
}

class _ProductRegionWidgetState extends State<ProductRegionWidget> {
   Future<Region> _region;
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _region = widget._region;
  }
  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder(
      future: _region,
      builder: (context, AsyncSnapshot<Region> snapshot) {
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
               child: Text('خطأ:المنطقة غير متاحة'),
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
