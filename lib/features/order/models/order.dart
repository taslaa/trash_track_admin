import 'package:json_annotation/json_annotation.dart';
import 'package:trash_track_admin/features/order/models/order_details.dart';
import 'package:trash_track_admin/features/user/models/user.dart';

part 'order.g.dart';

@JsonSerializable()
class Order {
  int? id;
  String? orderNumber;
  DateTime? orderDate;
  double? total;
  bool? isCanceled;
  int? userId;
  UserEntity? user;
  List<OrderDetails>? orderDetails;

  Order({
    this.id,
    this.orderNumber,
    this.orderDate,
    this.total,
    this.isCanceled,
    this.userId,
    this.user,
    this.orderDetails,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
