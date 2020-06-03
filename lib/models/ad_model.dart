import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:haftaa/Category/BaseCategory.dart';
import 'package:haftaa/Category/CategoryController.dart';
import 'package:haftaa/core/enums.dart';
import 'package:haftaa/entities/ad_entity.dart';
import 'package:haftaa/governorate/governorate.dart';
import 'package:haftaa/governorate/governorateController.dart';
import 'package:haftaa/region/region-controller.dart';
import 'package:haftaa/region/region.dart';
import 'package:haftaa/ui/widgets/product/auction-product-itemGrid.dart';
import 'package:haftaa/ui/widgets/product/request-product-itemGrid.dart';
import 'package:haftaa/ui/widgets/product/sale-product-itemGrid.dart';
import 'package:haftaa/user/user-controller.dart';
import 'package:haftaa/user/user.dart';
import 'package:intl/intl.dart';

import 'package:json_annotation/json_annotation.dart';

class Options {
  final double startPrice;
  final DateTime endDate;
  final int finalPeriodHours;
  final String status;
  final double price;

  AuctionStatus get auctionStatus {
    switch (status) {
      case 'open':
        return AuctionStatus.open;
        break;
      case 'closed':
        return AuctionStatus.closed;
        break;
      default:
    }
  }

  Options({
    this.startPrice,
    this.endDate,
    this.finalPeriodHours,
    this.status,
    this.price,
  });
}

class AdModel extends Equatable {
  final String id;
  final String userId;
  final bool used;
  final DateTime updateDate;
  final String type;
  final String title;
  final String regionId;
  final String mainImageUrl;
  final String governorateId;
  final String description;
  final DateTime creationDate;
  final String categoryId;
  final bool available;
  final List<String> images;
  final Map<dynamic, dynamic> favUsers;
  final bool displayInMobileHome;

  final Options options;

  //Future Work
  Future<User> _user;

  Future<User> get user async {
    if (_user != null) {
      return _user;
    }
    if (userId != null) {
      return await UserController.getUser(userId);
    }
    return null;
  }

  Future<BaseCategory> _category;

  Future<BaseCategory> get category async {
    if (_category != null) {
      return _category;
    }
    if (categoryId != null) {
      return await CategoryController.getCategory(categoryId);
    }
    return null;
  }

  Future<Governorate> _governorate;

  Future<Governorate> get governorate async {
    if (_category != null) {
      return _governorate;
    }
    if (categoryId != null) {
      return await GovernorateController.getGovernorate(governorateId);
    }
    return null;
  }

  Future<Region> _region;

  Future<Region> get region async {
    if (_region != null) {
      return _region;
    }
    if (regionId != null) {
      return await RegionController.getRegion(regionId);
    }
    return null;
  }

  AdType get adType {
    if (type == 'sale') {
      return AdType.sale;
    } else if (type == 'request') {
      return AdType.request;
    } else if (type == 'auction') {
      return AdType.auction;
    } else {
      return null;
    }
  }

  String get arabicTypeName {
    if (adType != null) {
      switch (adType) {
        case AdType.sale:
          return 'للبيع';
          break;
        case AdType.request:
          return 'للشراء';
          break;
        case AdType.auction:
          return 'مزاد';
          break;
        default:
      }
    }
    return null;
  }

  String get formatedCreateDate => creationDate == null
      ? ''
      : new DateFormat('yyyy-MMMM-dd').format(creationDate);

  AdModel({
    this.id,
    this.userId,
    this.used,
    this.updateDate,
    this.type,
    this.title,
    this.regionId,
    this.mainImageUrl,
    this.governorateId,
    this.description,
    this.creationDate,
    this.categoryId,
    this.available,
    this.images,
    this.favUsers,
    this.displayInMobileHome,
    this.options,
  });

  AdModel.fromEntity(AdEntity adEntity)
      : id = adEntity.id,
        userId = adEntity.userId,
        used = adEntity.used,
        updateDate = adEntity.updateDate,
        type = adEntity.type,
        title = adEntity.title,
        regionId = adEntity.regionId,
        mainImageUrl = adEntity.mainImageUrl,
        governorateId = adEntity.governorateId,
        description = adEntity.description,
        //todo :: make sute creation date time not ever null
        creationDate = adEntity.creationDate ?? DateTime.now(),
        categoryId = adEntity.categoryId,
        available = adEntity.available,
        images = adEntity.images,
        favUsers = adEntity.favUsers ?? Map(),
        displayInMobileHome = adEntity.displayInMobileHome,
        options = Options(
            startPrice: adEntity.options['startPrice'] == null
                ? null
                : double.parse(
                    adEntity.options['startPrice']?.toString() ?? 0,
                  ),
            endDate: adEntity.options['endDate'] == null
                ? null
                : DateTime.parse(adEntity.options['endDate']),
            finalPeriodHours: adEntity.options['finalPeriodHours'] == null
                ? null
                : int.parse(adEntity.options['finalPeriodHours'].toString()),
            status: adEntity.options['status'],
            price: adEntity.options['price'] == null
                ? null
                : double.parse(adEntity.options['price'].toString()));

  AdEntity toEntity() {
    return AdEntity(
        id: this.id,
        userId: this.userId,
        used: this.used,
        updateDate: this.updateDate,
        type: this.type,
        title: this.title,
        regionId: this.regionId,
        mainImageUrl: this.mainImageUrl,
        governorateId: this.governorateId,
        description: this.description,
        creationDate: this.creationDate,
        categoryId: this.categoryId,
        available: this.available,
        images: this.images,
        favUsers: this.favUsers,
        displayInMobileHome: this.displayInMobileHome,
        options: this.options);
    //todo: replace null with actual option data
  }

  Widget gridItem() {
    switch (adType) {
      case AdType.sale:
        //return SaleProductItemGrid(this);
        break;
      case AdType.request:
        //return RequestProductItemGrid(this);
        break;
      case AdType.auction:
        //return AuctionProductItemGrid(this);
        break;
    }
    return Center(
      child: Text('نوع الاعلان غير معروف'),
    );
  }

  String descriptionSubString(int lenght) {
    return description.substring(
        0, (description.length > lenght ? lenght : description.length));
  }

  @override
// TODO: implement props
  List<Object> get props => [
        id,
        userId,
        used,
        updateDate,
        type,
        title,
        regionId,
        mainImageUrl,
        governorateId,
        description,
        creationDate,
        categoryId,
        available,
        images,
        favUsers,
        displayInMobileHome,
        options,
        user,
      ];
}
