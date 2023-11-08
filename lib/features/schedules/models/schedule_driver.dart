import 'package:json_annotation/json_annotation.dart';
import 'package:trash_track_admin/features/user/models/user.dart';

part 'schedule_driver.g.dart';

@JsonSerializable()
class ScheduleDriver {
  int? id;
  int? scheduleId;
  int? driverId;
  UserEntity? driver;

  ScheduleDriver({this.id, this.scheduleId, this.driverId, this.driver});

  factory ScheduleDriver.fromJson(Map<String, dynamic> json) =>
      _$ScheduleDriverFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleDriverToJson(this);
}
        