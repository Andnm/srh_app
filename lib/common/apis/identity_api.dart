import 'package:cus_dbs_app/common/entities/identity.dart';
import 'package:cus_dbs_app/utils/http.dart';

class IdentityAPI {
  static Future<bool> checkIdentityCardExist() async {
    var response = await HttpUtil().get('api/IdentityCard/CheckExist');
    return response;
  }

  static Future<Map<String, dynamic>> updateIdentityCard({
    IdentityCardInfo? data,
  }) async {
    var response =
        await HttpUtil().put('api/IdentityCard', data: data?.toJson());
    return response;
  }

  static Future<IdentityCardInfo> getIdentityCard() async {
    var response = await HttpUtil().get('api/IdentityCard');
    return IdentityCardInfo.fromJson(response);
  }

  static Future<String> createIdentityCard({
    IdentityCardInfo? identityCardInfo,
  }) async {
    var response =
        await HttpUtil().post('api/IdentityCard', data: identityCardInfo);
    return response;
  }

  // Identity image
  static Future<IdentityCardImage> updateIdentityCardImage(
      {dynamic identityCardImage, required String identityCardImageId}) async {
    var response = await HttpUtil().put(
        'api/IdentityCard/IdentityCardImage/$identityCardImageId',
        data: identityCardImage);

    return IdentityCardImage.fromJson(response);
  }

  static Future<List<IdentityCardImage>> getAllIdentityCardImage(
      {String? identityCardId}) async {
    var response = await HttpUtil()
        .get('api/IdentityCard/IdentityCardImage/$identityCardId');
    return List<IdentityCardImage>.from(
        (response).map((e) => IdentityCardImage.fromJson(e)));
  }

  static Future<dynamic> addNewIdentityCardImage({
    dynamic identityCardImage,
  }) async {
    var response = await HttpUtil()
        .post('api/IdentityCard/IdentityCardImage', data: identityCardImage);
    return response;
  }

  static Future<bool> checkExistIdentity() async {
    var response = await HttpUtil().get('api/IdentityCard/CheckExist');
    return response;
  }

  static Future<bool> checkExistIdentityCardImage(bool isFront) async {
    var response =
        await HttpUtil().get('api/IdentityCard/CheckExistImage/$isFront');
    return response;
  }
}
