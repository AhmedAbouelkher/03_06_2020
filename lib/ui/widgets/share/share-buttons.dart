import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
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

class WhatsappShareButton extends StatefulWidget {
  String message;
  WhatsappShareButton(this.message);

  @override
  _WhatsappShareButtonState createState() => _WhatsappShareButtonState();
}

class _WhatsappShareButtonState extends State<WhatsappShareButton> {


  bool _isCreatingLink = false;
  String _linkMessage;



  @override
  void initState() {
    super.initState();
    initDynamicLinks();
  }

  void initDynamicLinks() async {
    final PendingDynamicLinkData data =
    await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      Navigator.pushNamed(context, deepLink.path);
    }

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          final Uri deepLink = dynamicLink?.link;

          if (deepLink != null) {
            Navigator.pushNamed(context, deepLink.path);
          }
        }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
  }

  Future<void> _createDynamicLink(bool short) async {
    setState(() {
      _isCreatingLink = true;
    });

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://cx4k7.app.goo.gl',
      link: Uri.parse('https://dynamic.link.example/helloworld'),
      androidParameters: AndroidParameters(
        packageName: 'emo.apps.haftaa',
        minimumVersion: 0,
      ),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink = await parameters.buildShortLink();
      url = shortLink.shortUrl;
    } else {
      url = await parameters.buildUrl();
    }

    setState(() {
      _linkMessage = url.toString();
      _isCreatingLink = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(!_isCreatingLink)
      _createDynamicLink(true);

    return IconButton(
      icon: Image.asset("assets/icon/whatsapp.png"),
      onPressed: ()async {

          if (_linkMessage != null) {
            await FlutterShareMe().shareToWhatsApp(msg: '$_linkMessage');
          }


      },
    );
  }
}
