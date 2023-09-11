import 'dart:convert';
import 'package:http/http.dart' as http;

class EnumsService {
  EnumsService();

  Future<Map<int, String>> getVehicleTypes() async {
    final response = await http
        .get(Uri.parse('https://localhost:7090/api/Enums/vehicle-types'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      final Map<int, String> vehicleTypeMap = {};

      for (var item in data) {
        if (item is Map<String, dynamic> &&
            item.containsKey('key') && // Change to 'key'
            item.containsKey('value')) { // Change to 'value'
          final int typeValue = item['key']; // Change to 'key'
          final String typeName = item['value']; // Change to 'value'

          vehicleTypeMap[typeValue] = typeName;
        }
      }

      return vehicleTypeMap;
    } else {
      throw Exception('Failed to load vehicle types');
    }
  }
}

