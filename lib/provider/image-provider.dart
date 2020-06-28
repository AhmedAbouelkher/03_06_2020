import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class UploadImageProvider {
  // Future<File> _pickImage() async {
  //   return await ImagePicker.pickImage(source: ImageSource.gallery);
  // }

  static Future<List<Asset>> getImageList(int maxImages) async {
    var resultList = await MultiImagePicker.pickImages(
      maxImages: maxImages,
      enableCamera: true,
    );
    return resultList;
    // The data selected here comes back in the list
    print(resultList);
    // for (var imageFile in resultList) {
    //   firebaseUpload(imageFile).then((downloadUrl) {
    //     // Get the download URL
    //     print(downloadUrl.toString());
    //   }).catchError((err) {
    //     print(err);
    //   });
    // }
  }

  static Future<dynamic> uploadImageAsset(
      Asset asset, String directoryPath, String uploadedImageFileName,{int quality =100}) async {
    ByteData byteData = await asset.requestOriginal(quality: quality);
    List<int> imageData = byteData.buffer.asUint8List();
    StorageReference ref = FirebaseStorage.instance
        .ref()
        .child(directoryPath)
        .child(uploadedImageFileName);
    StorageUploadTask uploadTask = ref.putData(imageData);

    return (await uploadTask.onComplete).ref.getDownloadURL();
  }
  static Future<dynamic> uploadImageByteData(
      ByteData byteData, String directoryPath, String uploadedImageFileName,{int quality =100}) async {
    //ByteData byteData = await asset.requestOriginal(quality: quality);
    List<int> imageData = byteData.buffer.asUint8List();
    StorageReference ref = FirebaseStorage.instance
        .ref()
        .child(directoryPath)
        .child(uploadedImageFileName);
    StorageUploadTask uploadTask = ref.putData(imageData);

    return (await uploadTask.onComplete).ref.getDownloadURL();
  }

  static Future<File> pickImage() async {
    return await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  static Future<String> uploadImageFile(File imageFile, String directoryPath,
      String uploadedImageFileName) async {
    StorageReference ref = FirebaseStorage.instance
        .ref()
        .child(directoryPath)
        .child(uploadedImageFileName);
    StorageUploadTask uploadTask = ref.putFile(imageFile);
    return await (await uploadTask.onComplete).ref.getDownloadURL();
  }
}
