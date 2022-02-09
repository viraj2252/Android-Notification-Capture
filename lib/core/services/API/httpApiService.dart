import 'dart:convert';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:notification/core/models/API/apiRequest.dart';
import 'package:notification/core/models/API/orderResponse.dart';
import 'package:notification/core/services/API/iApiService.dart';
import 'package:http/http.dart' as http;

class HttpApiService extends ApiService {
  final String _baseUrl = "https://tradingbot-functions-kcrozkptwq-uc.a.run.app/webhook";

  @override
  Future<OrderStatus?> placeOrder(ApiRequest order) async {
    try {
      var response = await http.post(Uri(host: _baseUrl), 
        headers: {"Content-Type": "application/json"},
        body: order.toJson());

        var res = response.statusCode == 200 ? OrderStatus.fromJson(json.decode(response.body)) : OrderStatus(statusCode: response.statusCode, message: response.body);
        return Future.value(res);
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance
          .recordError(e, stackTrace, reason: 'Error in _callback');

      return Future.value(null);
    }
  }
  
}
