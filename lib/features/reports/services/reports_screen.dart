import 'package:trash_track_admin/features/country/models/country.dart';
import 'package:trash_track_admin/features/reports/models/report.dart';
import 'package:trash_track_admin/shared/services/base_service.dart';

class ReportsService extends BaseService<Report> {
  ReportsService() : super("Reports"); 

  @override
  Report fromJson(data) {
    return Report.fromJson(data);
  }

}
