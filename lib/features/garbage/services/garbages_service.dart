import 'package:http/http.dart' as http;
import 'package:trash_track_admin/features/garbage/models/garbage.dart';
import 'package:trash_track_admin/shared/services/base_service.dart';

class GarbageService extends BaseService<Garbage> {
  GarbageService() : super("Garbages"); 

  @override
  Garbage fromJson(data) {
    return Garbage.fromJson(data);
  }
}
