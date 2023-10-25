import 'package:trash_track_admin/features/schedules/models/schedule.dart';
import 'package:trash_track_admin/features/services/models/service.dart';
import 'package:trash_track_admin/shared/services/base_service.dart';

class ScheduleService extends BaseService<Schedule> {
  ScheduleService() : super("Schedules"); 

  @override
  Schedule fromJson(data) {
    return Schedule.fromJson(data);
  }
}
