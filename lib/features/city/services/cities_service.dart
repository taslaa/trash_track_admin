import 'package:trash_track_admin/features/city/models/city.dart';
import 'package:trash_track_admin/shared/services/base_service.dart';

class CitiesService extends BaseService<City> {
  CitiesService() : super("Cities"); 

  @override
  City fromJson(data) {
    return City.fromJson(data);
  }
}
