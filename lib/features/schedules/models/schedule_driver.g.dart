// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_driver.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleDriver _$ScheduleDriverFromJson(Map<String, dynamic> json) =>
    ScheduleDriver(
      id: json['id'] as int?,
      scheduleId: json['scheduleId'] as int?,
      driverId: json['driverId'] as int?,
      driver: json['driver'] == null
          ? null
          : UserEntity.fromJson(json['driver'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ScheduleDriverToJson(ScheduleDriver instance) =>
    <String, dynamic>{
      'id': instance.id,
      'scheduleId': instance.scheduleId,
      'driverId': instance.driverId,
      'driver': instance.driver,
    };
