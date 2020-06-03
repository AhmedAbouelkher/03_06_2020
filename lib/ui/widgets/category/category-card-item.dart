import 'package:flutter/material.dart';
import 'package:haftaa/Category/BaseCategory.dart';
import 'package:haftaa/ui/BrandUIComponent/BrandDetail.dart';
import 'package:haftaa/ui/pages/products-list.dart';
import 'package:haftaa/search/search.dart';

/// Constructor for itemCard for List Menu
class CategoryCard extends StatelessWidget {
  /// Declaration and Get data from BrandDataList.dart
  final BaseCategory category;
  CategoryCard(this.category);

  @override
  Widget build(BuildContext context) {
    return 
    
    Padding(
      padding:
          const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
      child: InkWell(
        onTap: () {
          ProductSearchModel _searchModel =
              ProductSearchModel.FromSearchParams(category: this.category);

          Navigator.of(context).push(
            PageRouteBuilder(
                pageBuilder: (_, __, ___) =>
                    new ProductList.Search(_searchModel,'القسم (${category.title})'),
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
                      image: NetworkImage(category.img), fit: BoxFit.cover),
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
                      category.title,
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
