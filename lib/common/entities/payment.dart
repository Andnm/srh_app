class PaymentItem {
  String? fullName;
  String? orderId;
  String? orderInfo;
  num? amount;

  PaymentItem({this.fullName, this.orderId, this.orderInfo, this.amount});

  PaymentItem.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    orderId = json['orderId'];
    orderInfo = json['orderInfo'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['orderId'] = this.orderId;
    data['orderInfo'] = this.orderInfo;
    data['amount'] = this.amount;
    return data;
  }
}

class MoMoPaymentResponse {
  String? errorMessage;
  Data? data;
  bool? succeed;
  int? code;

  MoMoPaymentResponse({this.errorMessage, this.data, this.succeed, this.code});

  MoMoPaymentResponse.fromJson(Map<String, dynamic> json) {
    errorMessage = json['errorMessage'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    succeed = json['succeed'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorMessage'] = this.errorMessage;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['succeed'] = this.succeed;
    data['code'] = this.code;
    return data;
  }

  @override
  String toString() {
    return 'MoMoPaymentResponse{errorMessage: $errorMessage, data: $data, succeed: $succeed, code: $code}';
  }
}

class Data {
  String? requestId;
  int? errorCode;
  String? orderId;
  String? message;
  String? localMessage;
  String? requestType;
  String? payUrl;
  String? signature;
  String? qrCodeUrl;
  String? deeplink;
  String? deeplinkWebInApp;

  Data(
      {this.requestId,
      this.errorCode,
      this.orderId,
      this.message,
      this.localMessage,
      this.requestType,
      this.payUrl,
      this.signature,
      this.qrCodeUrl,
      this.deeplink,
      this.deeplinkWebInApp});

  Data.fromJson(Map<String, dynamic> json) {
    requestId = json['requestId'];
    errorCode = json['errorCode'];
    orderId = json['orderId'];
    message = json['message'];
    localMessage = json['localMessage'];
    requestType = json['requestType'];
    payUrl = json['payUrl'];
    signature = json['signature'];
    qrCodeUrl = json['qrCodeUrl'];
    deeplink = json['deeplink'];
    deeplinkWebInApp = json['deeplinkWebInApp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['requestId'] = this.requestId;
    data['errorCode'] = this.errorCode;
    data['orderId'] = this.orderId;
    data['message'] = this.message;
    data['localMessage'] = this.localMessage;
    data['requestType'] = this.requestType;
    data['payUrl'] = this.payUrl;
    data['signature'] = this.signature;
    data['qrCodeUrl'] = this.qrCodeUrl;
    data['deeplink'] = this.deeplink;
    data['deeplinkWebInApp'] = this.deeplinkWebInApp;
    return data;
  }
}
