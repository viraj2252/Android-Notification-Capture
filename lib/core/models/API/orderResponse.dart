class OrderStatus {
  String? code;
  String? message;
  OrderResponse? orderResponse;
  SecondaryResponse? secondaryResponse;
  int? statusCode;

  OrderStatus(
      {this.code, this.message, this.orderResponse, this.secondaryResponse, this.statusCode});

  OrderStatus.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    statusCode = json['statusCode'];
    message = json['message'];
    orderResponse = json['order_response'] != null
        ? new OrderResponse.fromJson(json['order_response'])
        : null;
    secondaryResponse = json['secondary_response'] != null
        ? new SecondaryResponse.fromJson(json['secondary_response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.orderResponse != null) {
      data['order_response'] = this.orderResponse!.toJson();
    }
    if (this.secondaryResponse != null) {
      data['secondary_response'] = this.secondaryResponse!.toJson();
    }
    return data;
  }
}

class OrderResponse {
  String? clientOrderId;
  String? cummulativeQuoteQty;
  String? executedQty;
  List<Fills>? fills;
  bool? isIsolated;
  int? orderId;
  String? origQty;
  String? price;
  String? side;
  String? status;
  String? symbol;
  String? timeInForce;
  int? transactTime;
  String? type;

  OrderResponse(
      {this.clientOrderId,
      this.cummulativeQuoteQty,
      this.executedQty,
      this.fills,
      this.isIsolated,
      this.orderId,
      this.origQty,
      this.price,
      this.side,
      this.status,
      this.symbol,
      this.timeInForce,
      this.transactTime,
      this.type});

  OrderResponse.fromJson(Map<String, dynamic> json) {
    clientOrderId = json['clientOrderId'];
    cummulativeQuoteQty = json['cummulativeQuoteQty'];
    executedQty = json['executedQty'];
    if (json['fills'] != null) {
      fills = <Fills>[];
      json['fills'].forEach((v) {
        fills!.add(new Fills.fromJson(v));
      });
    }
    isIsolated = json['isIsolated'];
    orderId = json['orderId'];
    origQty = json['origQty'];
    price = json['price'];
    side = json['side'];
    status = json['status'];
    symbol = json['symbol'];
    timeInForce = json['timeInForce'];
    transactTime = json['transactTime'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clientOrderId'] = this.clientOrderId;
    data['cummulativeQuoteQty'] = this.cummulativeQuoteQty;
    data['executedQty'] = this.executedQty;
    if (this.fills != null) {
      data['fills'] = this.fills!.map((v) => v.toJson()).toList();
    }
    data['isIsolated'] = this.isIsolated;
    data['orderId'] = this.orderId;
    data['origQty'] = this.origQty;
    data['price'] = this.price;
    data['side'] = this.side;
    data['status'] = this.status;
    data['symbol'] = this.symbol;
    data['timeInForce'] = this.timeInForce;
    data['transactTime'] = this.transactTime;
    data['type'] = this.type;
    return data;
  }
}

class Fills {
  String? commission;
  String? commissionAsset;
  String? price;
  String? qty;

  Fills({this.commission, this.commissionAsset, this.price, this.qty});

  Fills.fromJson(Map<String, dynamic> json) {
    commission = json['commission'];
    commissionAsset = json['commissionAsset'];
    price = json['price'];
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commission'] = this.commission;
    data['commissionAsset'] = this.commissionAsset;
    data['price'] = this.price;
    data['qty'] = this.qty;
    return data;
  }
}

class SecondaryResponse {
  String? clientOrderId;
  bool? isIsolated;
  int? orderId;
  String? symbol;
  int? transactTime;

  SecondaryResponse(
      {this.clientOrderId,
      this.isIsolated,
      this.orderId,
      this.symbol,
      this.transactTime});

  SecondaryResponse.fromJson(Map<String, dynamic> json) {
    clientOrderId = json['clientOrderId'];
    isIsolated = json['isIsolated'];
    orderId = json['orderId'];
    symbol = json['symbol'];
    transactTime = json['transactTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clientOrderId'] = this.clientOrderId;
    data['isIsolated'] = this.isIsolated;
    data['orderId'] = this.orderId;
    data['symbol'] = this.symbol;
    data['transactTime'] = this.transactTime;
    return data;
  }
}