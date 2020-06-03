import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:haftaa/Contracts/Disposable.dart';
import 'package:haftaa/settings/settings.dart';

class SettingsController implements Disposable {
  static Future<Settings> getSettings() {
    Completer<Settings> completer = Completer<Settings>();
    FirebaseDatabase.instance
        .reference()
        .child('settings')
        .once()
        .then((dataSnapshot) {
      var settings = Settings.fromSnapshot(dataSnapshot);
      completer.complete(settings);
    }).catchError((error) {
      completer.completeError(error);
    });
    return completer.future;
  }

  @override
  dispose() {}
}
