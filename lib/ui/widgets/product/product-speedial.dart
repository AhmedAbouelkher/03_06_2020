import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get_it/get_it.dart';
import 'package:haftaa/services/calls-and-messages-service.dart';
import 'package:haftaa/services/contacts_service.dart';
import 'package:haftaa/user/user.dart';

class ProductSpeeDial extends StatefulWidget {
  Future<User> _user;
  ProductSpeeDial(this._user);

  @override
  _ProductSpeeDialState createState() => _ProductSpeeDialState();
}

class _ProductSpeeDialState extends State<ProductSpeeDial> {
  final CallsAndMessagesService _callAndMessageSerive =
      GetIt.instance<CallsAndMessagesService>();

  User _user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    widget._user.then((user) {
      setState(() {
        _user = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      // both default to 16
      marginRight: 35,
      marginBottom: 35,
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      // this is ignored if animatedIcon is non null
      // child: Icon(Icons.add),
      visible: true,
      // If true user is forced to close dial manually
      // by tapping main button and overlay is not rendered.
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      tooltip: 'Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 8.0,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
            child: Icon(Icons.call),
            backgroundColor: Colors.green,
            label: (_user == null
                ? 'تحميل ..'
                : (_user.mobile == null
                    ? 'للأسف لا يوجد رقم'
                    : 'اتصل ${_user.mobile}')),
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => _user.mobile == null
                ? () {}
                : _callAndMessageSerive.call(_user.mobile)),
        SpeedDialChild(
            child: Icon(Icons.message),
            backgroundColor: Colors.blueAccent,
            label: (_user == null
                ? 'تحميل ..'
                : (_user.mobile == null ? 'للأسف لا يوجد رقم' : 'أرسل رسالة')),
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => _user.mobile == null
                ? () {}
                : _callAndMessageSerive.sendSms(_user.mobile)),
        // SpeedDialChild(
        //     child: Icon(Icons.person_add),
        //     backgroundColor: Colors.blue,
        //     label: (_user == null ? 'تحميل ..' : 'أضف إلى أرقامي'),
        //     labelStyle: TextStyle(fontSize: 18.0),
        //     onTap: () {
        //       // Permissions.checkPermissionStatus(PermissionGroup.contacts)
        //       //     .then((permissionStatus) {
        //       //   if (permissionStatus == PermissionStatus.granted) {
        //       //     //trying to add contact
        //       //     addContact();
        //       //   } else {
        //       //     //request permission
        //       //     Permissions.requestPermissions([PermissionGroup.contacts])
        //       //         .then((Map<PermissionGroup, PermissionStatus>
        //       //             requestResult) {
        //       //       var ss = requestResult;
        //       //     });
        //       //   }
        //       // });
        //     }),
      ],
    );
  }

  void addContact() {
    Item phoneNumber = Item.fromMap({"label": "mobile", "value": '324234'});
    ConatctsService.addContact(Contact(
        phones: [phoneNumber], givenName: _user.name, familyName: "SOME DATA"));
  }
}
