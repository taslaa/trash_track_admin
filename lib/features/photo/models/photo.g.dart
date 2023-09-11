// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Photo _$PhotoFromJson(Map<String, dynamic> json) => Photo(
      data: json['data'] as String?,
      contentType: json['contentType'] as String?,
      garbageId: json['garbageId'] as int?,
      garbage: json['garbage'] == null
          ? null
          : Garbage.fromJson(json['garbage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PhotoToJson(Photo instance) => <String, dynamic>{
      'data': instance.data,
      'contentType': instance.contentType,
      'garbageId': instance.garbageId,
      'garbage': instance.garbage,
    };
