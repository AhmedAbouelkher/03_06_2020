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

  CategoriesDropdownWidget({Key key, this.displayDropDownOnly})
      : super(key: key) {}

  CategoriesDropdownWidget.Custom(
      {this.onChange,
      this.title,
      this.hintText,
      this.selectionIsRequired,
      this.selectedCategory,
      this.displayDropDownOnly});

  CategoriesDropdownWidget.subCategories(
      {this.onChange,
      this.title,
      this.hintText,
      this.selectionIsRequired,
      this.selectedCategory,
      this.displayDropDownOnly,
      this.parentcategory});

  @override
  _CategoriesDropdownWidgetState createState() {
    return _CategoriesDropdownWidgetState();
  }
}

class _CategoriesDropdownWidgetState extends State<CategoriesDropdownWidget> {
  _CategoriesDropdownWidgetState() {
    fillCategoryList();
  }

  CategoryController categoryController = new CategoryController();

  //List<BaseCategory> categories = new List();
  List<DropdownMenuItem<BaseCategory>> dropdownMenuItemList =
      List<DropdownMenuItem<BaseCategory>>();

  fillCategoryList() {
    if (widget?.parentcategory != null) {
      widget.parentcategory.childCategories.then((catlist) {
        setState(() {
          dropdownMenuItemList = catlist
              .map<DropdownMenuItem<BaseCategory>>((BaseCategory category) {
            return DropdownMenuItem<BaseCategory>(
              child: Text(
                category.title ?? '',
                style: TextStyle(fontSize: 13),
              ),
              value: category,
            );
          }).toList();
        });
      });
    } else {
      categoryController.loadCategories().then((catlist) {
        setState(() {
          dropdownMenuItemList = catlist
              .map<DropdownMenuItem<BaseCategory>>((BaseCategory category) {
            return DropdownMenuItem<BaseCategory>(
              child: Text(
                category.title ?? '',
                style: TextStyle(fontSize: 13),
              ),
              value: category,
            );
          }).toList();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var dropdownButtonFormField = DropdownButtonFormField<BaseCategory>(
      decoration: InputDecoration(
        icon: Icon(Icons.category),
      ),
      validator: (value) => widget.selectionIsRequired
          ? Validators.notEmptyItemSelection(value)
          : null,
      onChanged: (selected_category) {
        setState(() {
          widget.selectedCategory = selected_category;
          widget.onChange(widget.selectedCategory);
        });
      },
      hint: Text(
        widget.hintText ?? '',
        style: TextStyle(fontSize: 13),
      ),
      items: dropdownMenuItemList,
      value: (widget.selectedCategory != null &&
              widget.selectedCategory.id != null)
          ? dropdownMenuItemList
              .where((dropdownMenuItem) =>
                  dropdownMenuItem.value.id == widget.selectedCategory.id)
              .first
              .value
          : widget.selectedCategory,
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
}
