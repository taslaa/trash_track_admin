import 'package:flutter/foundation.dart';

class GarbageSelectedValuesModel extends ChangeNotifier {
  int selectedGarbageTypeIndex = 0;

  void updateGarbageType(int index) {
    selectedGarbageTypeIndex = index;
    notifyListeners();
  }

  void reset() {
    selectedGarbageTypeIndex = 0;
    notifyListeners();
  }
}
