import 'package:trash_track_admin/features/services/models/service.dart';
import 'package:trash_track_admin/shared/services/base_service.dart';

class ServicesService extends BaseService<Service> {
  ServicesService() : super("Service"); 

  @override
  Service fromJson(data) {
    return Service.fromJson(data);
  }
}
