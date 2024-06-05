import 'package:cus_dbs_app/common/entities/linked_account_model.dart';
import 'package:cus_dbs_app/utils/http.dart';

class LinkedAccountAPI {
  static Future<List<LinkedAccountModel>> getAllLinkedAccount() async {
    var response = await HttpUtil().get('api/LinkedAccount/All');
    return List<LinkedAccountModel>.from(
        (response).map((e) => LinkedAccountModel.fromJson(e)));
  }

  static Future<LinkedAccountModel> createLinkedAccount(
      {required LinkedAccountModel dataLinkedAccount}) async {
    var response =
        await HttpUtil().post('api/LinkedAccount', data: dataLinkedAccount);
    return LinkedAccountModel.fromJson(response);
  }

  static Future<void> deleteLinkedAccount(
      {required String linkedAccountId}) async {
    var response =
        await HttpUtil().delete('api/LinkedAccount/$linkedAccountId');
    return response;
  }

  //call api để lấy tất cả bank tại Việt nam
  static Future<BankModelList> fetchAllBanks() async {
    var response = await HttpUtil().get(
      'https://api.vietqr.io/v2/banks',
    );
    return BankModelList.fromJson(response);
  }
}
