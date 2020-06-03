import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:haftaa/Contracts/Disposable.dart';
import 'package:haftaa/region/region.dart';

class RegionController implements Disposable {
  List<Region> regionList = List<Region>();

  StreamController<List<Region>> regionsStreamController =
  StreamController<List<Region>>();

  Stream<List<Region>> get regionsStream => regionsStreamController.stream;
  Sink<List<Region>> get regionsSink => regionsStreamController.sink;

  RegionController() {
    regionsStreamController.add(regionList);
  }

  static final regionReference =
  FirebaseDatabase.instance.reference().child('regions');

  static Future<Region> getRegion(String id) async {
    Completer<Region> completer = Completer<Region>();
    Region region;
    await FirebaseDatabase.instance
        .reference()
        .child('regions/${id}')
        .once()
        .then((DataSnapshot snapshot) {
      region = Region.fromSnapshot(snapshot);
      completer.complete(region);
    });
    return completer.future;
  }

  Future<List<Region>> loadRegions(String governorateID) async {
    regionList.clear();
    regionsSink.add(regionList);
    Completer completer = new Completer<List<Region>>();
    if (governorateID == null) {
      completer.complete(null);
      return completer.future;
    }

    List<Region> list = new List<Region>();
    Stream<Event> sse = regionReference
        .orderByChild('governorateId')
        .equalTo(governorateID)
        .onChildAdded;

    sse.listen((Event event) {
      onRegionAdded(event, list).then((List<Region> newsList) {
        return new Future.delayed(new Duration(seconds: 0), () => newsList);
      }).then((_) {
        if (!completer.isCompleted) {
          regionList = list;
          regionsSink.add(regionList);
          completer.complete(list);
        }
      });
    });

    return completer.future;
  }

  Future<List<Region>> onRegionAdded(
      Event event, List<Region> regionList) async {
    Region region = Region.fromSnapshot(event.snapshot);
    print("ADD: " + region.title);
    regionList.add(region);

    return regionList;
  }

  @override
  dispose() {
    regionsStreamController.close();
  }
}
