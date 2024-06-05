import 'package:cus_dbs_app/common/entities/car_model.dart';
import 'package:cus_dbs_app/utils/http.dart';

class CarAPI {
  static Future<List<BrandEntity>> getAllBrandOfCar() async {
    var response = await HttpUtil().get('api/BrandVehicle');
    return List<BrandEntity>.from(
        (response).map((e) => BrandEntity.fromJson(e)));
  }

  static Future<List<ModelEntity>> getAllModelByBrandOfCar(
      {required String brandVehicleId}) async {
    var response =
        await HttpUtil().get('api/ModelVehicle/BrandVehicle/$brandVehicleId');
    return List<ModelEntity>.from(
        (response).map((e) => ModelEntity.fromJson(e)));
  }
}
