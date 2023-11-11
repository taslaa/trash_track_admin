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
            item.containsKey('value')) {
          // Change to 'value'
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

  Future<Map<int, String>> getGarbageTypes() async {
    final response = await http
        .get(Uri.parse('https://localhost:7090/api/Enums/garbage-types'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      final Map<int, String> garbageTypeMap = {};

      for (var item in data) {
        if (item is Map<String, dynamic> &&
            item.containsKey('key') && // Change to 'key'
            item.containsKey('value')) {
          // Change to 'value'
          final int typeValue = item['key']; // Change to 'key'
          final String typeName = item['value']; // Change to 'value'

          garbageTypeMap[typeValue] = typeName;
        }
      }

      return garbageTypeMap;
    } else {
      throw Exception('Failed to load garbage types');
    }
  }

  Future<Map<int, String>> getReportStates() async {
    final response = await http
        .get(Uri.parse('https://localhost:7090/api/Enums/report-states'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      final Map<int, String> reportStatesMap = {};

      for (var item in data) {
        if (item is Map<String, dynamic> &&
            item.containsKey('key') && // Change to 'key'
            item.containsKey('value')) {
          // Change to 'value'
          final int typeValue = item['key']; // Change to 'key'
          final String typeName = item['value']; // Change to 'value'

          reportStatesMap[typeValue] = typeName;
        }
      }

      return reportStatesMap;
    } else {
      throw Exception('Failed to load report states');
    }
  }

  Future<Map<int, String>> getPickupStatus() async {
    final response = await http
        .get(Uri.parse('https://localhost:7090/api/Enums/pickup-status'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      final Map<int, String> pickupStatusMap = {};

      for (var item in data) {
        if (item is Map<String, dynamic> &&
            item.containsKey('key') && // Change to 'key'
            item.containsKey('value')) {
          // Change to 'value'
          final int typeValue = item['key']; // Change to 'key'
          final String typeName = item['value']; // Change to 'value'

          pickupStatusMap[typeValue] = typeName;
        }
      }

      return pickupStatusMap;
    } else {
      throw Exception('Failed to load pickupStatus');
    }
  }

   Future<Map<int, String>> getReservationStatus() async {
    final response = await http
        .get(Uri.parse('http://localhost:5057/api/Enums/reservation-status'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      final Map<int, String> reservationStatusMap = {};

      for (var item in data) {
        if (item is Map<String, dynamic> &&
            item.containsKey('key') && // Change to 'key'
            item.containsKey('value')) {
          // Change to 'value'
          final int typeValue = item['key']; // Change to 'key'
          final String typeName = item['value']; // Change to 'value'

          reservationStatusMap[typeValue] = typeName;
        }
      }

      return reservationStatusMap;
    } else {
      throw Exception('Failed to load reservation status');
    }
  }
}
