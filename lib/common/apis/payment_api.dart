import 'package:cus_dbs_app/common/entities/payment.dart';
import 'package:cus_dbs_app/utils/http.dart';

class PaymentAPI {
  static Future<MoMoPaymentResponse> createMoMoPaymentUrl({
    required PaymentItem dataPayment,
  }) async {
    var response = await HttpUtil()
        .post('api/MoMo/CreatePaymentUrl', data: dataPayment.toJson());

    return MoMoPaymentResponse.fromJson(response);
  }

  static Future<MoMoPaymentResponse> createMoMoPaymentBookingUrl(
      {required String? dropOffAddress, required num? amount}) async {
    var response = await HttpUtil().post('api/MoMo/CreatePaymentBookingUrl',
        data: {"dropOffAddress": dropOffAddress, "amount": amount});

    return MoMoPaymentResponse.fromJson(response);
  }

  static Future<String> createVNPayPaymentUrl({
    required PaymentItem dataPayment,
  }) async {
    var response = await HttpUtil()
        .post('api/VNPay/CreatePaymentUrl', data: dataPayment.toJson());

    return response;
  }

  static Future<String> createVNPayPaymenBookingtUrl(
      {required num? amount}) async {
    var response = await HttpUtil()
        .post('api/VNPay/CreatePaymentBookingUrl', data: {"amount": amount});

    return response;
  }
}
