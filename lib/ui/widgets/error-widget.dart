import 'package:flutter/material.dart';

class ErrorWidget extends StatelessWidget {
  String errorText;

  ErrorWidget(this.errorText);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(errorText));
  }
}
