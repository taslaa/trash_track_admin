// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

City _$CityFromJson(Map<String, dynamic> json) => City(
      id: json['id'] as int?,
      name: json['name'] as String?,
      zipCode: json['zipCode'] as String?,
      isActive: json['isActive'] as bool?,
      countryId: json['countryId'] as int?,
      country: json['country'] == null
          ? null
          : Country.fromJson(json['country'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CityToJson(City instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'zipCode': instance.zipCode,
      'isActive': instance.isActive,
      'countryId': instance.countryId,
      'country': instance.country,
    };
