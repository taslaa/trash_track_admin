import 'package:json_annotation/json_annotation.dart';
import 'package:trash_track_admin/features/schedules/models/schedule_driver.dart';
import 'package:trash_track_admin/features/schedules/models/schedule_garbage.dart';
import 'package:trash_track_admin/features/vehicle/models/vehicle.dart';

part 'schedule.g.dart';

@JsonSerializable()
class Schedule {
  int? id;
  DateTime? pickupDate;
  PickupStatus? status;
  int? vehicleId;
  Vehicle? vehicle;
  List<Map<String, int?>>? scheduleDrivers;
  List<Map<String, int?>>? scheduleGarbages;

  Schedule({this.id, this.pickupDate, this.status, this.vehicleId, this.vehicle, this.scheduleDrivers, this.scheduleGarbages});

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleToJson(this);
}

enum PickupStatus { completed, pending, cancelled }