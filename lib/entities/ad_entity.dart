import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:json_annotation/json_annotation.dart';

part 'ad_entity.g.dart';

@JsonSerializable()
class AdEntity extends Equatable {
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
  final dynamic options;

  AdEntity({
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

  AdEntity.fromSnapshot(DataSnapshot snapshot)
      : id = snapshot.key,
        userId = snapshot.value['userId'],
        used = snapshot.value['used'],
        updateDate = snapshot.value['updateDate'],
        type = snapshot.value['type'],
        title = snapshot.value['title'],
        regionId = snapshot.value['regionId'],
        mainImageUrl = snapshot.value['mainImage'],
        governorateId = snapshot.value['governorateId'],
        description = snapshot.value['description'],
        creationDate = snapshot.value['creationDate'] == null
            ? null
            : DateTime.parse(snapshot.value['creationDate']),
        categoryId = snapshot.value['categoryId'],
        available = snapshot.value['available'],
        images = snapshot.value['images'] == null
            ? null
            : (snapshot.value['images'] as List).map<String>((f) => f).toList(),
        favUsers = snapshot.value['favUsers'],
        displayInMobileHome = snapshot.value['displayInMobileHome'],
        options = snapshot.value['options'];

  static AdEntity fromJson(json) => _$AdEntityFromJson(json);

  toJson() => _$AdEntityToJson(this);

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
      ];
}
