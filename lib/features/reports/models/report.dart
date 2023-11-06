import 'package:json_annotation/json_annotation.dart';
import 'package:trash_track_admin/features/garbage/models/garbage.dart';
import 'package:trash_track_admin/features/user/models/user.dart';

part 'report.g.dart';

@JsonSerializable()
class Report {
  int? id;
  String? note;
  ReportState? reportState; // Us
  ReportType? reportType;
  UserEntity? reporterUser; // Use double for latitude and longitude
  int? reporterUserId;
  String? photo;
  Garbage? garbage;
  int? garbageId;

  Report(
      {this.id,
      this.note,
      this.reportState,
      this.reportType,
      this.reporterUser,
      this.reporterUserId,
      this.photo,
      this.garbage,
      this.garbageId});

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);

  Map<String, dynamic> toJson() => _$ReportToJson(this);
}

enum ReportState { waitingForReview, reviewed }

enum ReportType {
  trashOverflow,
  littering,
  garbageBinDamage,
  graffitiVandalism
}
