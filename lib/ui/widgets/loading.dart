import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  String loadingText;
  Widget loadingTextWidget;
  Key key;
  Loading();

  Loading.params({this.key, this.loadingText, this.loadingTextWidget})
      : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        children: <Widget>[
          CircularProgressIndicator(),
          Text(widget.loadingText ?? ''),
          widget.loadingTextWidget ?? Text('')
        ],
      ),
    ));
  }
}
