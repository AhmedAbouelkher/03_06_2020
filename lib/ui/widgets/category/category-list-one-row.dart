import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haftaa/Category/BaseCategory.dart';
import 'package:haftaa/Category/CategoryController.dart';
import 'package:haftaa/ui/pages/products-list.dart';
import 'package:haftaa/search/search.dart';

class CategoryListOneRow extends StatefulWidget {
  String categoryId;
  CategoryListOneRow(this.categoryId);
  @override
  _CategoryListOneRowState createState() => _CategoryListOneRowState();
}

class _CategoryListOneRowState extends State<CategoryListOneRow> {
  Future _categoryFuture;
  CategoryController categoryController = new CategoryController();

  @override
  void initState() {
    super.initState();
    _categoryFuture = categoryController.getList(widget.categoryId);
  }

  /// Custom text
  static var _customTextStyleBlack = TextStyle(
      fontFamily: "Gotik",
      color: Colors.black,
      fontWeight: FontWeight.w700,
      fontSize: 15.0);

  @override
  Widget build(BuildContext context) {
    return

        /// Item first above "Week Promotion" with image Promotion
        FutureBuilder<List<BaseCategory>>(
      future: _categoryFuture,
      builder:
          (BuildContext context, AsyncSnapshot<List<BaseCategory>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
            break;
          default:
            if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            } else if (snapshot.hasData && snapshot.data.length == 0) {
              return rowContainer(0.0, snapshot);
            } else {
              return rowContainer(125, snapshot);
            }
        }
      },
    );
  }

  Widget rowContainer(
      double height, AsyncSnapshot<List<BaseCategory>> snapshot) {
    return
//Expanded(child: categoryListView(snapshot.data));
        /// Item first above "Week Promotion" with image Promotion
        Container(
      color: Colors.white,
      height: height,
      child: Column(
        children: <Widget>[
          // Padding(
          //     padding: EdgeInsets.only(left: 20.0, top: 10.0, bottom: 3.0),
          //     child: Text("Week Promotion", style: _customTextStyleBlack)),
          Expanded(child: categoryListView(snapshot.data)),
        ],
      ),
    );
  }

  Widget _categoryItem(BaseCategory category) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 15.0)),
          CategoryItemValue(
            category: category,

            //      tap: onClickCategory,
          ),
        ],
      ),
    );
  }

  Widget categoryListView(List<BaseCategory> categoryList) {
    List<Widget> categoryItems = [];
    categoryItems.add(Padding(
      padding: const EdgeInsets.only(left: 20.0),
    ));

    categoryList.forEach((category) {
      categoryItems.add(_categoryItem(category));
    });

    return ListView(
      scrollDirection: Axis.horizontal,
      children: categoryItems,
    );
  }
}

///Item Popular component class
class itemPopular extends StatelessWidget {
  String image, title;

  itemPopular({this.image, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        image: DecorationImage(image: NetworkImage(image), fit: BoxFit.cover),
      ),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            color: Colors.black.withOpacity(0.3),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 80.0, left: 10.0),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Gotik",
                fontSize: 15.5,
                letterSpacing: 0.7,
                fontWeight: FontWeight.w600,
              ),
            ),
          )),
    );
  }
}

/// Component category item bellow FlashSale
class CategoryItemValue extends StatelessWidget {
  BaseCategory category;
  GestureTapCallback tap;

  CategoryItemValue({this.tap, this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ProductSearchModel _searchModel =
            ProductSearchModel.FromSearchParams(category: this.category);

        Navigator.of(context).push(
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => new ProductList.Search(
                  _searchModel, 'القسم (${category.title})'),
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
      child: Container(
        height: 100.0,
        width: 160.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(3.0)),
          image: DecorationImage(
              image: NetworkImage(category.img), fit: BoxFit.cover),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(3.0)),
            color: Colors.black.withOpacity(0.25),
          ),
          child: Container(
            height: 75,
            width: 500,
            color: Colors.black12.withOpacity(0.1),
            child: Column(
              children: <Widget>[
                Text(
                  category.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Berlin",
                    fontSize: 25.0,
                  ),
                ),
                Text(
                  (category.itemsCount == null
                          ? '0'
                          : category.itemsCount.toString()) +
                      ' عنصر',
                  style: TextStyle(
                      fontFamily: "Sans",
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.0),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
