import 'package:cus_dbs_app/common/entities/search_request_model.dart';
import 'package:cus_dbs_app/utils/http.dart';

class SearchRequestAPI {
  static Future<String>? searchRequest({
    required SearchRequestModel? params,
  }) async {
    var response =
        await HttpUtil().post('api/SearchRequest', data: params?.toJson());

    return response.toString();
  }

  static Future<SearchRequestModel>? cancelSearchRequestWithDriverId(
      {required String? driverId, required String? searchRequestId}) async {
    var response = await HttpUtil().put(
      'api/SearchRequest/UpdateStatusToCancel/$searchRequestId?DriverId=$driverId',
    );

    return SearchRequestModel.fromJson(response);
  }

  static Future<SearchRequestModel>? cancelSearchRequest(
      {required String? searchRequestId}) async {
    var response = await HttpUtil().put(
      'api/SearchRequest/UpdateStatusToCancel?SearchRequestId=$searchRequestId',
    );

    return SearchRequestModel.fromJson(response);
  }
}
