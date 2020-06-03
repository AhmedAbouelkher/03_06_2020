import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_share_me/flutter_share_me.dart';

class SystemShareButton extends StatelessWidget {
  String message;
  SystemShareButton(this.message);
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          FlutterShareMe().shareToSystem(msg: this.message);
        },
        icon: Icon(
          Icons.share,
          color: Colors.blueGrey,
        ));
  }
}

class WhatsappShareButton extends StatelessWidget {
  String message;
  WhatsappShareButton(this.message);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Image.asset("assets/icon/whatsapp.png"),
      onPressed: () {
        FlutterShareMe().shareToWhatsApp(msg: this.message);
      },
    );
  }
}
