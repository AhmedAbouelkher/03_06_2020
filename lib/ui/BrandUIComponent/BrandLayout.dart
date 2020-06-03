import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:haftaa/Category/BaseCategory.dart';
import 'package:haftaa/Category/CategoryController.dart';
import 'package:haftaa/ui/BrandUIComponent/BrandDetail.dart';
import 'package:haftaa/ListItem/BrandDataList.dart';
import 'package:haftaa/ui/HomeUIComponent/advanced-search.dart';
import 'package:haftaa/ui/pages/products-list.dart';
import 'package:haftaa/ui/widgets/category/category-grid.dart';
import 'package:haftaa/search/search.dart';

class brand extends StatefulWidget {
  @override
  _brandState createState() => _brandState();
}

class _brandState extends State<brand> {
  List<BaseCategory> categoryList = [];

  CategoryController categoryController = CategoryController();
  bool stillLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    categoryController.loadCategories().then((onValue) {
      setState(() {
        categoryList = onValue;
        stillLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //var categoryGrid = CategoryGrid();

    /// Component appbar
    var _appbar = AppBar(
      backgroundColor: Color(0xFFFFFFFF),
      elevation: 0.0,
      title: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Text(
          "الأقسام",
          style: TextStyle(
              fontFamily: "Gotik",
              fontSize: 20.0,
              color: Colors.black54,
              fontWeight: FontWeight.w700),
        ),
      ),
      actions: <Widget>[
        InkWell(
          onTap: () {
            Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (_, __, ___) => new AdvancedSearch()));
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Icon(
              Icons.search,
              size: 27.0,
              color: Colors.black54,
            ),
          ),
        )
      ],
    );

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Scaffold(

          /// Calling variable appbar
          appBar: _appbar,
          body: Container(
              color: Colors.white,
              child: stillLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : productGrid(categoryList)
              // CustomScrollView(
              //     /// Create List Menu
              //     slivers: <Widget>[
              //       SliverPadding(
              //         padding: EdgeInsets.only(top: 0.0),
              //         sliver: SliverFixedExtentList(
              //             itemExtent: 145.0,
              //             delegate: SliverChildBuilderDelegate(

              //                 /// Calling itemCard Class for constructor card
              //                 (context, index) {
              //               return CategoryCard(categoryList[index]);
              //             }, childCount: categoryList.length)),
              //       ),
              //     ],
              //   ),
              )),
    );
  }

  Widget productGrid(List<BaseCategory> list) {
    return GridView.count(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        crossAxisSpacing: 10.0,
        //mainAxisSpacing: 17.0,
        //childAspectRatio: 0.545,
        crossAxisCount: 2,
        primary: false,
        children: List.generate(list.length, (index) {
          return CategoryCard(list[index]);
        }));
  }
}

/// Constructor for itemCard for List Menu
class itemCard extends StatelessWidget {
  /// Declaration and Get data from BrandDataList.dart
  final Brand brand;
  itemCard(this.brand);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
                pageBuilder: (_, __, ___) => new brandDetail(brand),
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
          height: 130.0,
          width: 400.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          child: Hero(
            tag: 'hero-tag-${brand.id}',
            child: Material(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  image: DecorationImage(
                      image: AssetImage(brand.img), fit: BoxFit.cover),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFABABAB).withOpacity(0.3),
                      blurRadius: 1.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    color: Colors.black12.withOpacity(0.1),
                  ),
                  child: Center(
                    child: Text(
                      brand.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Berlin",
                        fontSize: 35.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Constructor for itemCard for List Menu
class CategoryCard extends StatelessWidget {
  /// Declaration and Get data from BrandDataList.dart
  final BaseCategory category;
  CategoryCard(this.category);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 2.0, right: 2.0, top: 3.0, bottom: 3.0),
      child: InkWell(
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
          height: 130.0,
          width: 400.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          child: Hero(
            tag: 'hero-tag-${category.id}',
            child: Material(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  image: DecorationImage(
                      image: category.img == null
                          ? AssetImage("assets/img/category.png")
                          : CachedNetworkImageProvider(
                              category.img,
                            ),
                      fit: BoxFit.cover),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFABABAB).withOpacity(0.3),
                      blurRadius: 1.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      bottom: 0.0,
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            color: Colors.black12.withOpacity(0.1),
                          ),
                          child: Center(
                            child: Container(
                              height: 71,
                              width: MediaQuery.of(context).size.width * 0.5,
                              color: Colors.black12.withOpacity(0.5),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      category.title,
                                      softWrap: false,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Berlin",
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    Text(
                                      (category.itemsCount == null
                                              ? '0'
                                              : category.itemsCount
                                                  .toString()) +
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
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
