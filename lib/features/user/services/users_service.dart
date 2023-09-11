import 'package:http/http.dart' as http;
import 'package:trash_track_admin/features/user/models/user.dart';
import 'package:trash_track_admin/shared/services/base_service.dart';

class UserService extends BaseService<UserEntity> {
  UserService() : super("Users"); // "users" is the endpoint for your user API

  @override
  UserEntity fromJson(data) {
    return UserEntity.fromJson(data);
  }
}
