import 'package:trash_track_admin/features/country/models/country.dart';
import 'package:trash_track_admin/shared/services/base_service.dart';

class CountriesService extends BaseService<Country> {
  CountriesService() : super("Countries"); 

  @override
  Country fromJson(data) {
    return Country.fromJson(data);
  }

}
