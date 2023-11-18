import 'package:trash_track_admin/features/product/models/product.dart';
import 'package:trash_track_admin/shared/services/base_service.dart';

class ProductsService extends BaseService<Product> {
  ProductsService() : super("Products"); 

  @override
  Product fromJson(data) {
    return Product.fromJson(data);
  }

}
