import 'package:trash_track_admin/shared/models/base_entity.dart';

enum Role {
  administrator,
  user,
}

class UserEntity extends BaseEntity {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final String? password;
  final Role? role;

  const UserEntity({
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.password,
    this.role,
  });

  @override
  List<Object?> get props {
    return [
      id,
      firstName,
      lastName,
      email,
      phoneNumber,
      password,
      role,
    ];
  }
}
