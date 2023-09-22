import 'package:http/http.dart' as http;
import 'package:trash_track_admin/features/user/models/user.dart';
import 'package:trash_track_admin/shared/services/base_service.dart';

class UserService extends BaseService<UserEntity> {
  UserService() : super("Users"); 

  @override
  UserEntity fromJson(data) {
    return UserEntity.fromJson(data);
  }

  //  Future<bool> changePassword(int userId, String newPassword) async {
  //   try {
  //     // final response = await http.put(
  //     //   //Uri.parse('$baseUrl/users/$userId/change-password'), 
  //     //   //body: {'newPassword': newPassword},
  //     // );

  //     if (response.statusCode == 200) {
  //       // Password change was successful
  //       return true;
  //     } else {
  //       // Password change request failed
  //       return false;
  //     }
  //   } catch (e) {
  //     // Handle exceptions or errors
  //     return false;
  //   }
  // }
}
