import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  DatabaseReference databaseReference;
  FirebaseService() {
    databaseReference = FirebaseDatabase.instance.reference();
  }

  getItem(String childName) {
    databaseReference.child(childName).once().then((DataSnapshot dataSnapshot) {
      print(dataSnapshot.value);
      return dataSnapshot.value;
    });
  }

  addItem(String childName, var dataObject) {
    databaseReference.child(childName).push().set(dataObject);
  }

  updateItem(String documentName, String id, Map<String, dynamic> jsonObject) {
    databaseReference
        .reference()
        .child(documentName)
        .child(id)
        .update(jsonObject);
  }

  deleteItem(String documentName, String id) {
    databaseReference
    .reference()
    .child(documentName)
    .child(id)
    .remove();
  }
}
