import 'package:json_annotation/json_annotation.dart';
import 'package:trash_track_admin/features/country/models/country.dart';

part 'user.g.dart';

@JsonSerializable()
class UserEntity {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? biography;
  DateTime? birthDate;
  Gender? gender; 
  int? countryId;
  Country? country;
  Role? role;
  String? profilePhoto;
  bool? isActive;
  bool? isVerified;

  UserEntity({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.biography,
    this.birthDate,
    this.gender,
    this.country,
    this.countryId,
    this.role,
    this.profilePhoto,
    this.isActive,
    this.isVerified
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);

  Map<String, dynamic> toJson() => _$UserEntityToJson(this);
}

enum Gender {
  male,
  female,
}

enum Role {
  administrator,
  user,
  driver
}