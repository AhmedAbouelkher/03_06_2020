import 'package:flutter/material.dart';
import 'package:haftaa/Category/BaseCategory.dart';

class ProductCategoryWidget extends StatefulWidget {
  Future<BaseCategory> _category;
  TextStyle _textStyle;
  ProductCategoryWidget(this._category, this._textStyle);

  @override
  _ProductCategoryWidgetState createState() => _ProductCategoryWidgetState();
}

class _ProductCategoryWidgetState extends State<ProductCategoryWidget> {
  Future<BaseCategory> _category;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _category = widget._category;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _category,
      builder: (context, AsyncSnapshot<BaseCategory> snapshot) {
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
                child: Text('${snapshot.error}'),
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
