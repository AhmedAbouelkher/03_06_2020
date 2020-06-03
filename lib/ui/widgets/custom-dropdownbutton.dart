import 'package:flutter/material.dart';

class CustomDropdownWidget extends StatefulWidget {
  //List _menuItemlist;
  String Function(dynamic) validator;
  void Function(dynamic) onChange;
  var items;
  String title;
  String hintText;
  dynamic selectedValue;
  String helperText;
  Icon icon;
  bool selectionIsRequired = false;

  CustomDropdownWidget({Key key}) : super(key: key) {}

  CustomDropdownWidget.Custom(
      {this.validator,
      this.items,
      this.onChange,
      this.title,
      this.hintText,
      this.selectionIsRequired,
      this.selectedValue,
      this.helperText,
      this.icon});

  @override
  _CustomDropdownWidgetState createState() {
    return _CustomDropdownWidgetState();
  }
}

class _CustomDropdownWidgetState extends State<CustomDropdownWidget> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Column(
      textDirection: TextDirection.rtl,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 20.0),
          child: Text(
            widget.title,

            style: TextStyle(

              fontFamily: "Gotik",
              color: Colors.black26,
            ),
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 20.0)),
        Row(
          textDirection: TextDirection.rtl,
          children: <Widget>[
            Container(
              width: mediaQueryData.size.width - 90,
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  helperText: widget.helperText,
                  icon: widget.icon,
                ),
                validator: (value) => widget.validator(value) ?? null,
                onChanged: (value) {
                  setState(() {
                    widget.selectedValue = value;
                    widget.onChange(widget.selectedValue);
                  });
                },
                hint: Text(

                  widget.hintText,
                  style: TextStyle(fontSize: 13),
                ),
                value: widget.selectedValue,
                items: widget.items,
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
                  widget.selectedValue = null;
                });
              },
            )
          ],
        ),
      ],
    );
  }
}
