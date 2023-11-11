import 'package:flutter/foundation.dart';
import 'package:trash_track_admin/features/user/models/user.dart';

class SelectedValuesModel extends ChangeNotifier {
  DateTime selectedDate = DateTime.now();
  int selectedVehicleId = 0;
  List<UserEntity> selectedUsers = [];

  void updateDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void updateVehicle(int vehicleId) {
    selectedVehicleId = vehicleId;
    notifyListeners();
  }

  void updateUser(List<UserEntity> users) {
    selectedUsers = users;
    notifyListeners();
  }

   void reset() {
    selectedUsers.clear();
    selectedVehicleId = 0;
    notifyListeners();
  }
}
