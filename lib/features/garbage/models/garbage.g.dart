// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'garbage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Garbage _$GarbageFromJson(Map<String, dynamic> json) => Garbage(
      address: json['address'] as String?,
      garbageType:
          $enumDecodeNullable(_$GarbageTypeEnumMap, json['garbageType']),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    )..id = json['id'] as int?;

Map<String, dynamic> _$GarbageToJson(Garbage instance) => <String, dynamic>{
      'id': instance.id,
      'address': instance.address,
      'garbageType': _$GarbageTypeEnumMap[instance.garbageType],
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

const _$GarbageTypeEnumMap = {
  GarbageType.plastic: 'plastic',
  GarbageType.glass: 'glass',
  GarbageType.metal: 'metal',
  GarbageType.organic: 'organic',
};
