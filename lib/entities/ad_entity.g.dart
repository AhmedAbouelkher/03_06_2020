// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ad_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdEntity _$AdEntityFromJson(Map<String, dynamic> json) {
  return AdEntity(
    id: json['id'] as String,
    userId: json['userId'] as String,
    used: json['used'] as bool,
    updateDate: json['updateDate'] == null
        ? null
        : DateTime.parse(json['updateDate'] as String),
    type: json['type'] as String,
    title: json['title'] as String,
    regionId: json['regionId'] as String,
    mainImageUrl: json['mainImageUrl'] as String,
    governorateId: json['governorateId'] as String,
    description: json['description'] as String,
    creationDate: json['creationDate'] == null
        ? null
        : DateTime.parse(json['creationDate'] as String),
    categoryId: json['categoryId'] as String,
    available: json['available'] as bool,
    images: (json['images'] as List)?.map((e) => e as String)?.toList(),
    favUsers: json['favUsers'] as Map<String, dynamic>,
    displayInMobileHome: json['displayInMobileHome'] as bool,
    options: json['options'],
  );
}

Map<String, dynamic> _$AdEntityToJson(AdEntity instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'used': instance.used,
      'updateDate': instance.updateDate?.toIso8601String(),
      'type': instance.type,
      'title': instance.title,
      'regionId': instance.regionId,
      'mainImageUrl': instance.mainImageUrl,
      'governorateId': instance.governorateId,
      'description': instance.description,
      'creationDate': instance.creationDate?.toIso8601String(),
      'categoryId': instance.categoryId,
      'available': instance.available,
      'images': instance.images,
      'favUsers': instance.favUsers,
      'displayInMobileHome': instance.displayInMobileHome,
      'options': instance.options,
    };
