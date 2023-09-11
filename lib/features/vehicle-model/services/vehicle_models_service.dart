import 'package:trash_track_admin/features/vehicle-model/models/vehicle_model.dart';
import 'package:trash_track_admin/shared/services/base_service.dart';

class VehicleModelsService extends BaseService<VehicleModel> {
  VehicleModelsService() : super("VehicleModels"); 

  @override
  VehicleModel fromJson(data) {
    return VehicleModel.fromJson(data);
  }
}
