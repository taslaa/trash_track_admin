import 'package:trash_track_admin/features/order/models/order.dart';
import 'package:trash_track_admin/shared/services/base_service.dart';
import 'package:http/http.dart' as http;

class OrdersService extends BaseService<Order> {
  OrdersService() : super("Orders");

  @override
  Order fromJson(data) {
    return Order.fromJson(data);
  }

  Future<void> toggleOrderStatus(int orderId) async {
    final response = await http.put(
      Uri.parse(
          'https://localhost:7090/api/Orders/ToggleOrderStatus?id=$orderId'),
    );

    if (response.statusCode == 204) {
    } else {
      print('Error toggling order status: ${response.statusCode}');
    }
  }
}
