import 'package:flutter/foundation.dart';

class ApiRequest{
  String signal;
  int interval = 60;
  String ticker;
  double entryPrice;
  double stopLoss;
  String password;

  ApiRequest({
    required this.signal,
    required this.interval,
    required this.ticker,
    required this.entryPrice,
    required this.stopLoss,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'signal': signal,
        'interval': interval,
        'ticker': ticker,
        'entryPrice': entryPrice,
        'stopLoss': stopLoss,
        'password': password,
      };
}