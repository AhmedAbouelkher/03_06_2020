import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:haftaa/governorate/governorate.dart';

class GovernorateController {
  static final governmentRefrence =
  FirebaseDatabase.instance.reference().child('governorates');

  Query _categoriesQuery = governmentRefrence.orderByKey();
  Governorate category;

  static Future<Governorate> getGovernorate(String governorateId) async {
    Completer<Governorate> completer = Completer<Governorate>();
    Governorate _governorate;
    await FirebaseDatabase.instance
        .reference()
        .child('governorates/${governorateId}')
        .once()
        .then((DataSnapshot snapshot) {
      _governorate = Governorate.fromSnapshot(snapshot);
      completer.complete(_governorate);
    });
    return completer.future;
  }

  Future<List<Governorate>> getList() async {
    final completer = Completer<List<Governorate>>();

    List<Governorate> _catList = new List<Governorate>();
    governmentRefrence.once().then((DataSnapshot snapshot) {
      Map values = snapshot.value;
      values.forEach((key, value) {
        _catList.add(Governorate.fromMap(key, values[key]));
      });
    });

    if (!completer.isCompleted) {
      completer.complete(_catList);
    }
    return completer.future;
  }

  Future<List<Governorate>> loadCategories() async {
    Completer completer = new Completer<List<Governorate>>();
    List<Governorate> list = new List<Governorate>();
    Stream<Event> sse = _categoriesQuery.onChildAdded;

    sse.listen((Event event) {
      onCategoryAdded(event, list).then((List<Governorate> newsList) {
        return new Future.delayed(new Duration(seconds: 0), () => newsList);
      }).then((_) {
        if (!completer.isCompleted) {
          completer.complete(list);
        }
      });
    });
    return completer.future;
  }

  Future<List<Governorate>> onCategoryAdded(
      Event event, List<Governorate> newsList) async {
    Governorate category = Governorate.fromSnapshot(event.snapshot);
    print("ADD: " + category.title);
    newsList.add(category);
    return newsList;
  }
}
