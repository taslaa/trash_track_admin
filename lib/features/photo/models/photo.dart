import 'package:json_annotation/json_annotation.dart';
import 'package:trash_track_admin/features/garbage/models/garbage.dart';

part 'photo.g.dart';

@JsonSerializable()
class Photo {
  String? data; 
  String? contentType;

  int? garbageId;
  Garbage? garbage;

  Photo({this.data, this.contentType, this.garbageId, this.garbage});

  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoToJson(this);
}
