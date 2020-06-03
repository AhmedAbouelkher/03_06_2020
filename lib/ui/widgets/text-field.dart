import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  TextEditingController textEditingController = TextEditingController();
  final String labelText;
  final String hintText;
  final TextStyle hintStyle;
  final TextInputType textInputType;

  CustomTextField(
      {this.labelText, this.hintText, this.hintStyle, this.textInputType});
  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width - 90,
          child: TextFormField(
            controller: widget.textEditingController,
             keyboardType: widget.textInputType,
            decoration: InputDecoration(
                labelText: widget.labelText,
                hintText: widget.hintText,
                hintStyle:
                    widget.hintStyle ?? TextStyle(color: Colors.black54)),
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
              widget.textEditingController.clear();
            });
          },
        )
      ],
    );
  }
}
