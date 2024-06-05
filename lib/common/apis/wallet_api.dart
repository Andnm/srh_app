import 'package:cus_dbs_app/common/entities/wallet.dart';
import 'package:cus_dbs_app/utils/http.dart';

class WalletAPI {
  static Future<WalletModel> getWallet() async {
    var response = await HttpUtil().get('api/Wallet');
    return WalletModel.fromJson(response);
  }

  static Future<WalletModel> postWallet(String userId) async {
    var userData = {
      "userId": userId,
    };

    var response = await HttpUtil().post('api/Wallet', data: userData);

    return WalletModel.fromJson(response);
  }

  static Future<bool> checkExistWallet() async {
    var response = await HttpUtil().get('api/Wallet/CheckExistWallet');
    return response;
  }

  static Future<WalletModel> payWithWallet({num? totalMoney}) async {
    var dataMoney = {
      "totalMoney": totalMoney,
    };

    var response = await HttpUtil().post('api/Wallet/Pay', data: dataMoney);

    return WalletModel.fromJson(response);
  }

  static Future<WalletModel> withDrawFunds(
      num totalMoney, String linkedAccountId) async {
    var dataMoney = {
      "totalMoney": totalMoney,
    };

    var response = await HttpUtil().post(
        'api/Wallet/WithdrawFunds?LinkedAccountId=$linkedAccountId',
        data: dataMoney);

    return WalletModel.fromJson(response);
  }

  static Future<WalletTransactionList> getAllWalletTransactionByDesc(
      {required int pageIndex, required int pageSize}) async {
    var response = await HttpUtil().get(
        'api/Wallet/WalletTransaction?PageIndex=$pageIndex&PageSize=$pageSize&SortKey=DateCreated&SortOrder=DESC');
    return WalletTransactionList.fromJson(response);
  }
}
