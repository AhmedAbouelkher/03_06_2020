import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

enum ImagePathType { localFile, online, assetPath, fileAsset }

class ImageFile {
  bool _isMainPage = false;
  File _imageFileObj;
  String _imageURL;
  String _assestFilePath;
  Asset _fileAsset;
  ImagePathType _pathType;
  bool _deleted = false;
  ImageFile.fromFile(this._imageFileObj) {
    _pathType = ImagePathType.localFile;
  }
  ImageFile.fromURL(this._imageURL) {
    _pathType = ImagePathType.online;
  }
  ImageFile.fromAssetPath(this._assestFilePath) {
    _pathType = ImagePathType.assetPath;
  }
  ImageFile.fromAsset(this._fileAsset) {
    _pathType = ImagePathType.fileAsset;
  }

  String get imageURL => _imageURL;
  set imageURL(url) {
    _imageURL = url;
  }

  ImagePathType get pathType => _pathType;
  File get imageFileObj => _imageFileObj;
  String get assetFilePath => _assestFilePath;
  bool get deleted => _deleted;
  set deleted(bool value) {
    _deleted = value;
  }

  Asset get FileAsset => _fileAsset;
  bool get isMainImage => _isMainPage;
  set isMainImage(value) {
    _isMainPage = value;
  }

  static Widget getImageWidget(ImageFile imagefile) {
    Widget _imagewidget = Container();
    switch (imagefile.pathType) {
      case ImagePathType.assetPath:
        _imagewidget = Image.asset(
          imagefile.assetFilePath,
        );
        break;
      case ImagePathType.localFile:
        _imagewidget = Image.file(
          imagefile.imageFileObj,
        );
        break;
      case ImagePathType.online:
        _imagewidget = CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: imagefile.imageURL,
          placeholder: (context, url) =>
              Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => new Icon(Icons.error),
        );

        break;
      case ImagePathType.fileAsset:
        _imagewidget = AssetThumb(
          asset: imagefile.FileAsset,
          width: 300,
          height: 300,
        );
        break;
      default:
    }
    return _imagewidget;
  }
}
