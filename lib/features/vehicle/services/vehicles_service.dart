import 'package:trash_track_admin/features/vehicle/models/vehicle.dart';
import 'package:trash_track_admin/shared/services/base_service.dart';

class VehiclesService extends BaseService<Vehicle> {
  VehiclesService() : super("Vehicles"); 

  @override
  Vehicle fromJson(data) {
    return Vehicle.fromJson(data);
  }
}
