import 'package:flutter/material.dart';
import 'package:haftaa/governorate/governorate.dart';
import 'package:haftaa/governorate/governorateController.dart';
import 'package:haftaa/validation/validators.dart';

class GovernorateDropdownWidget extends StatefulWidget {
  //List _menuItemlist;
  void Function(Governorate) onChange;
  void Function() onDeleteSeelction;
  String title;
  String hintText;
  Governorate selectedGovernorate;
  bool selectionIsRequired = false;
  GovernorateDropdownWidget({Key key}) : super(key: key) {}
  GovernorateDropdownWidget.custom(
      {this.onChange,
        this.title,
        this.hintText,
        this.onDeleteSeelction,
        this.selectionIsRequired,
        this.selectedGovernorate});

  @override
  _GovernorateDropdownWidgetState createState() {
    return _GovernorateDropdownWidgetState();
  }
}

class _GovernorateDropdownWidgetState extends State<GovernorateDropdownWidget> {
  _GovernorateDropdownWidgetState() {
    fillCategoryList();
  }

  GovernorateController governorateController = new GovernorateController();
  //List<BaseCategory> categories = new List();
  List<DropdownMenuItem<Governorate>> DropdownMenuItemList;

  fillCategoryList() async {
    governorateController.loadCategories().then((catlist) {
      setState(() {
        DropdownMenuItemList =
            catlist.map<DropdownMenuItem<Governorate>>((Governorate category) {
              return DropdownMenuItem(
                child: Text(category.title),
                value: category,
              );
            }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Column(
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
          children: <Widget>[
            Container(
              width: mediaQueryData.size.width - 90,
              child: DropdownButtonFormField<Governorate>(
                key: UniqueKey(),
                validator: (value) => widget.selectionIsRequired
                    ? Validators.notEmptyItemSelection(value)
                    : null,
                onChanged: (selected_governorate) {
                  widget.selectedGovernorate = selected_governorate;
                  setState(() {
                    widget.selectedGovernorate = selected_governorate;
                    widget.onChange(widget.selectedGovernorate);
                  });
                },
                hint: Text(widget.hintText),
                value: (widget.selectedGovernorate != null &&
                    widget.selectedGovernorate.id != null)
                    ? DropdownMenuItemList
                    .where((dropdownMenuItem) =>
                dropdownMenuItem.value.id ==
                    widget.selectedGovernorate.id)
                    .first
                    .value
                    : widget.selectedGovernorate,
                items: DropdownMenuItemList,
              ),
            ),
            IconButton(
              alignment: Alignment.topLeft,
              icon: Icon(
                Icons.cancel,
                color: Colors.blueAccent.shade200,
              ),
              onPressed: () {
                setState(() {
                  widget.selectedGovernorate = null;
                  widget.onDeleteSeelction();
                });
              },
            )
          ],
        ),
      ],
    );
  }
}
