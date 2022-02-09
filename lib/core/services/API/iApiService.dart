import 'package:notification/core/models/API/apiRequest.dart';
import 'package:notification/core/models/API/orderResponse.dart';

abstract class ApiService {
  Future<OrderStatus?> placeOrder(ApiRequest order);
}