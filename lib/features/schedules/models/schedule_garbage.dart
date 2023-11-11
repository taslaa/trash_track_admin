import 'package:json_annotation/json_annotation.dart';
import 'package:trash_track_admin/features/vehicle/models/vehicle.dart';

part 'schedule_garbage.g.dart';

@JsonSerializable()
class ScheduleGarbage {
  int? id;
  int? scheduleId;
  int? garbageId;


  ScheduleGarbage({this.id, this.scheduleId, this.garbageId});

  factory ScheduleGarbage.fromJson(Map<String, dynamic> json) =>
      _$ScheduleGarbageFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleGarbageToJson(this);
}