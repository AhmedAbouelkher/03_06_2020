import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:haftaa/Category/BaseCategory.dart';
import 'package:haftaa/Contracts/Disposable.dart';

class CategoryController extends Disposable {
  @override
  dispose() {}

  static var categoriesReference =
  FirebaseDatabase.instance.reference().child('categories');

  Query _categoriesQuery = categoriesReference.orderByKey();
  BaseCategory category;

  CategoryController();

  static Future<BaseCategory> getCategory(String categoryId) async {
    Completer completer = new Completer<BaseCategory>();
    BaseCategory _category;
    await FirebaseDatabase.instance
        .reference()
        .child('categories/${categoryId}')
        .once()
        .then((DataSnapshot snapshot) {
      _category = BaseCategory.fromSnapshot(snapshot);

      completer.complete(_category);
    });
    return completer.future;
  }

  Future<List<BaseCategory>> getList(String categoryId) async {
    Query categoryRef = categoriesReference;
    final Completer<List<BaseCategory>> completer =
    Completer<List<BaseCategory>>();

    if (categoryId != null && categoryId.isNotEmpty) {
      categoryRef = categoriesReference
          .orderByChild('categoryId')
          .equalTo('${categoryId}');
    }

    List<BaseCategory> _catList = new List<BaseCategory>();
    categoryRef.once().then((DataSnapshot snapshot) {
      Map values = snapshot.value;
      values.forEach((key, value) {
        _catList.add(BaseCategory.fromMap(key, values[key]));
      });
    });

    if (!completer.isCompleted) {
      completer.complete(_catList);
    }
    return completer.future;
  }

  Future<List<BaseCategory>> loadCategories() async {
    Completer completer = new Completer<List<BaseCategory>>();
    List<BaseCategory> list = new List<BaseCategory>();
    Stream<Event> sse = _categoriesQuery.onChildAdded;

    sse.listen((Event event) {
      onCategoryAdded(event, list).then((List<BaseCategory> newsList) {
        return new Future.delayed(new Duration(seconds: 0), () => newsList);
      }).then((_) {
        if (!completer.isCompleted) {
          completer.complete(list);
        }
      });
    });
    return completer.future;
  }

  Future<List<BaseCategory>> onCategoryAdded(
      Event event, List<BaseCategory> newsList) async {
    BaseCategory category = BaseCategory.fromSnapshot(event.snapshot);
    print("ADD: " + category.title);
    newsList.add(category);
    return newsList;
  }

  static List<BaseCategory> toCategories(
      List<Map<String, dynamic>> jsonObjects) {}
}
