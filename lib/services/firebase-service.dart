import 'package:firebase_database/firebase_database.dart';
import 'package:haftaa/core/enums.dart';
import 'package:haftaa/Tools/Tools.dart';

import 'API-service-interface.dart';

class FirebaseService implements IAPIService {
  DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

  @override
  Future<void> createItem(String collectionName, dynamic dataObject) {
    return databaseReference
        .child(Tools.getLastSplitValue(collectionName))
        .push()
        .set(dataObject);
  }

  @override
  createItems() {
    // TODO: implement createItems
    return null;
  }

  @override
  Future<DataSnapshot> getItem(String collectionName) {
    var result = databaseReference.child(collectionName).once();

    // result.then((DataSnapshot dataSnapshot) {
    //   print(dataSnapshot.value);
    //   return dataSnapshot.value;
    // });
    return result;
  }

  @override
  Future<DataSnapshot> getItems (String collectionName) async{
    return await databaseReference
        .child(Tools.getLastSplitValue(collectionName))
        .once();
  }

  @override
  removeItem() {
    // TODO: implement removeItem
    return null;
  }

  @override
  removeItems() {
    // TODO: implement removeItems
    return null;
  }
}
