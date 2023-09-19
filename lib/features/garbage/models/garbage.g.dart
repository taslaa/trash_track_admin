// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'garbage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Garbage _$GarbageFromJson(Map<String, dynamic> json) => Garbage(
      description: json['description'] as String?,
      garbageType:
          $enumDecodeNullable(_$GarbageTypeEnumMap, json['garbageType']),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$GarbageToJson(Garbage instance) => <String, dynamic>{
      'description': instance.description,
      'garbageType': _$GarbageTypeEnumMap[instance.garbageType],
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

const _$GarbageTypeEnumMap = {
  GarbageType.plastic: 'Plastic',
  GarbageType.glass: 'Glass',
  GarbageType.metal: 'Metal',
  GarbageType.organic: 'Organic'
};
