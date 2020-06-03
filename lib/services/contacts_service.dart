// Import package
import 'dart:typed_data';
import 'package:contacts_service/contacts_service.dart';

class ConatctsService {
// Get all contacts on device
  Future<Iterable<Contact>> get contacts async =>
      await ContactsService.getContacts();
// Get all contacts without thumbnail (faster)
  Future<Iterable<Contact>> get contactsWithoutThumbnail async =>
      await ContactsService.getContacts(withThumbnails: false);

// Android only: Get thumbnail for an avatar afterwards (only necessary if `withThumbnails: false` is used)
  Future<Uint8List> avatar(Contact conatct) async =>
      await ContactsService.getAvatar(conatct);

// Get contacts matching a string
  Future<Iterable<Contact>> searchConatcts(String name) async =>
      await ContactsService.getContacts(query: name);

// Add a contact
// The contact must have a firstName / lastName to be successfully added
  static void addContact(Contact newContact) async {
    await ContactsService. addContact(newContact)
        .then((onValue) {
          var ss= onValue;
        })
        .catchError((onError) {
      var dd = onError;
    });
  }

// Delete a contact
// The contact must have a valid identifier
  void deleteContact(Contact contact) async =>
      await ContactsService.deleteContact(contact);

// Update a contact
// The contact must have a valid identifier
  void updateContact(Contact contact) async =>
      await ContactsService.updateContact(contact);
}
