import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:haftaa/Category/CategoryController.dart';
import 'package:haftaa/Category/BaseCategory.dart';
import 'package:haftaa/ui/pages/products-list.dart';
import 'package:haftaa/search/search.dart';

class CategoryIconsGrid extends StatefulWidget {
  CategoryIconsGrid();

  @override
  _CategoryIconsGridState createState() => _CategoryIconsGridState();
}

class _CategoryIconsGridState extends State<CategoryIconsGrid> {
  CategoryController categoryController = CategoryController();
  Future<List<BaseCategory>> _listFuture;
  List<BaseCategory> _categoryList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listFuture = categoryController.getList(null);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BaseCategory>>(
      future: _listFuture,
      builder: (conetxt, AsyncSnapshot<List<BaseCategory>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return CircularProgressIndicator();
            break;
          default:
            if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data.length == 0)
              return Container();
            else {
              //CategoryIcon Component
              return Container(
                color: Colors.white,
                padding: EdgeInsets.only(top: 20.0),
                alignment: AlignmentDirectional.centerStart,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _justWidgetList(snapshot.data)),
              );
            }
        }
      },
    );
  }
}

List chunk(List list, int chunkSize) {
  List chunks = [];
  int len = list.length;
  for (var i = 0; i < len; i += chunkSize) {
    int size = i + chunkSize;
    chunks.add(list.sublist(i, size > len ? len : size));
  }
  return chunks;
}

List<Widget> _justWidgetList(List<BaseCategory> categories) {
  List<Widget> _listWidgets = [];

  _listWidgets.add(
    Padding(
      padding: EdgeInsets.only(right: 20.0, top: 0.0),
      child: Text(
        "أقسام",
        style: TextStyle(
            fontSize: 13.5, fontFamily: "Sans", fontWeight: FontWeight.w700),
      ),
    ),
  );
  _listWidgets.add(Padding(padding: EdgeInsets.only(top: 20.0)));
  var categoryChunks = chunk(categories, 4);

  (categoryChunks as List).forEach((categoryList_) {
    List _list = categoryList_;
    List<CategoryIconItem> iconList = new List();
    if (_list.length == 4) {
      _list.forEach((category) {
        iconList.add(CategoryIconItem(category: (category as BaseCategory)));
      });
    }

    _listWidgets.add(CategoryIconValue(
      iconList: iconList,
    ));
  });

  return _listWidgets;
}

class CategoryIconItem extends StatelessWidget {
  // GestureTapCallback tap;
  // String icon;
  // String title;
  BaseCategory category;
  CategoryIconItem({this.category});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ProductSearchModel _searchModel =
        ProductSearchModel.FromSearchParams(category: this.category);

        Navigator.of(context).push(
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => new ProductList.Search(
                  _searchModel, 'القسم (${category.title ?? ''})'),
              transitionDuration: Duration(milliseconds: 600),
              transitionsBuilder:
                  (_, Animation<double> animation, __, Widget child) {
                return Opacity(
                  opacity: animation.value,
                  child: child,
                );
              }),
        );
      },
      child: Column(
        children: <Widget>[

          CachedNetworkImage(
            height: 19.2,
            fit: BoxFit.cover,
            imageUrl: category.icon ?? '',
            placeholder: (context, url) =>
                Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => new Icon(Icons.error),
          ),

//          Image.network(
//            category.icon ?? '',
//            height: 19.2,
//          ),
          Padding(padding: EdgeInsets.only(top: 7.0)),
          Text(
            getIconFormatedText(category.title ?? ''),
            style: TextStyle(
              fontFamily: "Sans",
              fontSize: 10.0,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }

  String getIconFormatedText(String theText) {
    if (theText == null) {
      return '         ';
    }
    //جعل النص تسع خانات أو تسع حروف

    //جلب أول كلمة
    String firstWord = theText.split(' ')[0];
    //جلب أول 9 حروف من الكلمة الأولى
    String text =
    firstWord.substring(0, (firstWord.length >= 10) ? 9 : firstWord.length);

//لو الكلمة الأولى أقل من 9 حروف سيتم زيادة الباقي بمسافات
    if (text.length < 10) {
      for (var i = 0; i < (10 - text.length); i++) {
        text += ' ';
      }
    }
    return text;
  }
}

/// Component item Menu icon bellow a ImageSlider
class CategoryIconValue extends StatelessWidget {
  String icon1, icon2, icon3, icon4, title1, title2, title3, title4;
  GestureTapCallback tap1, tap2, tap3, tap4;
  List<CategoryIconItem> iconList;
  CategoryIconValue({
    this.iconList,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: iconList,

      //  <Widget>[

      //   InkWell(
      //     onTap: tap1,
      //     child: Column(
      //       children: <Widget>[
      //         Image.asset(
      //           icon1,
      //           height: 19.2,
      //         ),
      //         Padding(padding: EdgeInsets.only(top: 7.0)),
      //         Text(
      //           title1,
      //           style: TextStyle(
      //             fontFamily: "Sans",
      //             fontSize: 10.0,
      //             fontWeight: FontWeight.w500,
      //           ),
      //         )
      //       ],
      //     ),
      //   ),
      //   InkWell(
      //     onTap: tap2,
      //     child: Column(
      //       children: <Widget>[
      //         Image.asset(
      //           icon2,
      //           height: 26.2,
      //         ),
      //         Padding(padding: EdgeInsets.only(top: 0.0)),
      //         Text(
      //           title2,
      //           style: TextStyle(
      //             fontFamily: "Sans",
      //             fontSize: 10.0,
      //             fontWeight: FontWeight.w500,
      //           ),
      //         )
      //       ],
      //     ),
      //   ),
      //   InkWell(
      //     onTap: tap3,
      //     child: Column(
      //       children: <Widget>[
      //         Image.asset(
      //           icon3,
      //           height: 22.2,
      //         ),
      //         Padding(padding: EdgeInsets.only(top: 4.0)),
      //         Text(
      //           title3,
      //           style: TextStyle(
      //             fontFamily: "Sans",
      //             fontSize: 10.0,
      //             fontWeight: FontWeight.w500,
      //           ),
      //         )
      //       ],
      //     ),
      //   ),
      //   InkWell(
      //     onTap: tap4,
      //     child: Column(
      //       children: <Widget>[
      //         Image.asset(
      //           icon4,
      //           height: 19.2,
      //         ),
      //         Padding(padding: EdgeInsets.only(top: 7.0)),
      //         Text(
      //           title4,
      //           style: TextStyle(
      //             fontFamily: "Sans",
      //             fontSize: 10.0,
      //             fontWeight: FontWeight.w500,
      //           ),
      //         )
      //       ],
      //     ),
      //   ),
      // ],
    );
  }
}
