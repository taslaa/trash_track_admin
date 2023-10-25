import 'package:trash_track_admin/features/reservations/models/reservation.dart';
import 'package:trash_track_admin/shared/services/base_service.dart';

class ReservationService extends BaseService<Reservation> {
  ReservationService() : super("Reservation"); // "users" is the endpoint for your user API

  @override
  Reservation fromJson(data) {
    return Reservation.fromJson(data);
  }
}