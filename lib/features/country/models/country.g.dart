// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Country _$CountryFromJson(Map<String, dynamic> json) => Country(
      id: json['id'] as int?,
      name: json['name'] as String?,
      abbreviation: json['abbreviation'] as String?,
      isActive: json['isActive'] as bool?,
    );

Map<String, dynamic> _$CountryToJson(Country instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'abbreviation': instance.abbreviation,
      'isActive': instance.isActive,
    };
