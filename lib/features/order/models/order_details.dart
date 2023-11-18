import 'package:json_annotation/json_annotation.dart';
import 'package:trash_track_admin/features/order/models/order.dart';
import 'package:trash_track_admin/features/product/models/product.dart';

part 'order_details.g.dart';

@JsonSerializable()
class OrderDetails {
  int? id;
  int? quantity;
  int? productId;
  Product? product;
  int? orderId;
  Order? order;

  OrderDetails({
    this.id,
    this.quantity,
    this.productId,
    this.product,
    this.orderId,
    this.order,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDetailsToJson(this);
}
