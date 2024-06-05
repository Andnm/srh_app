import 'package:cus_dbs_app/common/entities/vehicle.dart';
import 'package:cus_dbs_app/utils/http.dart';

class VehicleItemAPI {
  static Future<List<VehicleItem>> getAllVehicle() async {
    var response = await HttpUtil().get('api/Vehicle');

    return List<VehicleItem>.from(
        (response).map((e) => VehicleItem.fromJson(e)));
  }

  static Future<String> addNewVehicle({VehicleItem? vehicleItem}) async {
    var response = await HttpUtil().post('api/Vehicle', data: vehicleItem);
    return response;
  }

  static Future<VehicleItem> updateVehicle(
      {required String? vehicleId, required VehicleItem? vehicleItem}) async {
    var response =
        await HttpUtil().put('api/Vehicle/$vehicleId', data: vehicleItem);

    return VehicleItem.fromJson(response);
  }

  static Future<List<VehicleItemImage>> getAllVehicleImage(
      {String? vehicleId}) async {
    var response = await HttpUtil().get('api/Vehicle/VehicleImage/$vehicleId');
    return List<VehicleItemImage>.from(
        (response).map((e) => VehicleItemImage.fromJson(e)));
  }

  static Future<dynamic> addNewVehicleImage({dynamic vehicleItemImage}) async {
    var response = await HttpUtil()
        .post('api/Vehicle/VehicleImage', data: vehicleItemImage);

    return response;
  }

  static Future<VehicleItemImage> updateVehicleImage(
      {required String vehicleImageId, dynamic dataImage}) async {
    var response = await HttpUtil()
        .put('api/Vehicle/VehicleImage/$vehicleImageId', data: dataImage);
    return VehicleItemImage.fromJson(response);
  }

  static Future<dynamic> deleteVehicle({String? vehicleId}) async {
    var response = await HttpUtil().delete('api/Vehicle/$vehicleId');
    return response;
  }
}
