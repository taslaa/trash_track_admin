import 'package:json_annotation/json_annotation.dart';

part 'garbage.g.dart';

@JsonSerializable()
class Garbage {
  String? description;
  GarbageType? garbageType; // Use the GarbageType enum here
  double? latitude; // Use double for latitude and longitude
  double? longitude;

  Garbage({
    this.description,
    this.garbageType,
    this.latitude,
    this.longitude,
  });

  factory Garbage.fromJson(Map<String, dynamic> json) =>
      _$GarbageFromJson(json);

  Map<String, dynamic> toJson() => _$GarbageToJson(this);
}

enum GarbageType {
  type1,
  type2,
  type3,
}
