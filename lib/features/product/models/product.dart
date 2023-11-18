import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  int? id;
  String? name;
  String? description;
  String? code;
  String? photo;
  double? price;
  ProductType? type;

  Product({this.id, this.name, this.description, this.code, this.photo, this.price, this.type});

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}

enum ProductType { trashBin, trashBag, protectiveGear }
