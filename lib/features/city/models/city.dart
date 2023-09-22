import 'package:json_annotation/json_annotation.dart';
import 'package:trash_track_admin/features/country/models/country.dart';

part 'city.g.dart';

@JsonSerializable()
class City {
  int? id;
  String? name;
  String? zipCode;
  bool? isActive;
  int? countryId;
  Country? country;

  City({
    this.id,
    this.name,
    this.zipCode,
    this.isActive,
    this.countryId,
    this.country,
  });

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);

  Map<String, dynamic> toJson() => _$CityToJson(this);
}
