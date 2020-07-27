import 'dart:async';

import 'package:flutter/material.dart';
import 'package:haftaa/Category/BaseCategory.dart';
import 'package:haftaa/Category/CategoryController.dart';
import 'package:haftaa/validation/validators.dart';

class CategoriesDropdownWidget extends StatefulWidget {
  //List _menuItemlist;
  void Function(BaseCategory) onChange;
  String title;
  String hintText;
  BaseCategory selectedCategory;
  bool selectionIsRequired = false;
  bool displayDropDownOnly = false;
  BaseCategory parentcategory;
  CategoryController categoryController = new CategoryController();
  List<DropdownMenuItem<BaseCategory>> dropdownMenuItemList = [];
  Future<List<BaseCategory>> categoriesFuture;

  StreamController<BaseCategory> streamController =
      StreamController<BaseCategory>();

  Stream<BaseCategory> get categorySelecting => streamController.stream;

  CategoriesDropdownWidget({Key key, this.displayDropDownOnly})
      : super(key: key);

  CategoriesDropdownWidget.Custom(
      {this.onChange,
      this.title,
      this.hintText,
      this.selectionIsRequired,
      this.selectedCategory,
      this.displayDropDownOnly}) {
    categoriesFuture = categoryController.loadCategories();
//    .then((catlist) {
//      dropdownMenuItemList =
//          catlist.map<DropdownMenuItem<BaseCategory>>((BaseCategory category) {
//        return DropdownMenuItem<BaseCategory>(
//          child: Text(
//            category.title ?? '',
//            style: TextStyle(fontSize: 13),
//          ),
//          value: category,
//        );
//      }).toList();
//    });
  }

  CategoriesDropdownWidget.subCategories(
      {this.onChange,
      this.title,
      this.hintText,
      this.selectionIsRequired,
      this.selectedCategory,
      this.displayDropDownOnly,
      this.parentcategory}) {
    if (parentcategory != null) {
      categoriesFuture = parentcategory.childCategories;

//          .then((catlist) {
//        dropdownMenuItemList = catlist
//            .map<DropdownMenuItem<BaseCategory>>((BaseCategory category) {
//          return DropdownMenuItem<BaseCategory>(
//            child: Text(
//              category.title ?? '',
//              style: TextStyle(fontSize: 13),
//            ),
//            value: category,
//          );
//        }).toList();
//      });
    }
  }

  @override
  _CategoriesDropdownWidgetState createState() {
    return _CategoriesDropdownWidgetState();
  }
}

class _CategoriesDropdownWidgetState extends State<CategoriesDropdownWidget> {
  _CategoriesDropdownWidgetState() {
    //fillCategoryList();
  }

  //CategoryController categoryController = new CategoryController();

  //List<BaseCategory> categories = new List();
//  List<DropdownMenuItem<BaseCategory>> dropdownMenuItemList =
//      List<DropdownMenuItem<BaseCategory>>();

  //fillCategoryList() {}

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var dropdownButtonFormField = FutureBuilder<List<BaseCategory>>(
      future: widget.categoriesFuture,
      // a previously-obtained Future<String> or null
      builder:
          (BuildContext context, AsyncSnapshot<List<BaseCategory>> snapshot) {
        List<Widget> children;
        if (snapshot.hasData) {
          widget.dropdownMenuItemList = snapshot.data
              .map<DropdownMenuItem<BaseCategory>>((BaseCategory category) {
            return DropdownMenuItem<BaseCategory>(
              child: Text(
                category.title ?? '',
                style: TextStyle(fontSize: 13),
              ),
              value: category,
            );
          }).toList();
          return DropdownButtonFormField<BaseCategory>(
            decoration: InputDecoration(
              icon: Icon(Icons.category),
            ),
            validator: (value) => widget.selectionIsRequired
                ? Validators.notEmptyItemSelection(value)
                : null,
            onChanged: (selected_category) {
              widget.streamController.add(selected_category);
              widget.selectedCategory = selected_category;

              widget.onChange(widget.selectedCategory);
            },
            hint: Text(
              widget.hintText ?? '',
              style: TextStyle(fontSize: 13),
            ),
            items: widget.dropdownMenuItemList,
            value: _getSelectedCategory(),
          );
        } else if (snapshot.hasError) {
          children = <Widget>[
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Error: ${snapshot.error}'),
            )
          ];
        } else {
          children = <Widget>[
            SizedBox(
              child: CircularProgressIndicator(),
              width: 60,
              height: 60,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('Awaiting result...'),
            )
          ];
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        );
      },
    );

    return widget.displayDropDownOnly
        ? dropdownButtonFormField
        : Column(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                child: Text(
                  widget.title,
                  style: TextStyle(fontFamily: "Gotik", color: Colors.black26),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20.0)),
              Row(
                textDirection: TextDirection.rtl,
                children: <Widget>[
                  Container(
                    width: mediaQueryData.size.width - 90,
                    child: dropdownButtonFormField,
                  ),
                  IconButton(
                    alignment: Alignment.topLeft,
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.blueAccent.shade200,
                    ),
                    onPressed: () {
                      setState(() {
                        widget.selectedCategory = null;
                      });
                    },
                  )
                ],
              ),
            ],
          );
  }

  BaseCategory _getSelectedCategory() {
// return    (widget.selectedCategory != null && widget.selectedCategory.id != null)
//        ? widget.dropdownMenuItemList
//            .where((dropdownMenuItem) =>
//                dropdownMenuItem.value.id == widget.selectedCategory.id)
//            .first
//            .value
//        : widget.selectedCategory;

    if (widget.selectedCategory != null && widget.selectedCategory.id != null) {
      var item = widget.dropdownMenuItemList
          .where((dropdownMenuItem) =>
              dropdownMenuItem.value.id == widget.selectedCategory.id)
          .first
          .value;
      return item;
    } else {
      return widget.selectedCategory;
    }
  }
}
