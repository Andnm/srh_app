import 'dart:convert';

import 'package:cus_dbs_app/common/entities/car_model.dart';
import 'package:cus_dbs_app/common/entities/vehicle.dart';
import 'package:cus_dbs_app/common/widgets/custom_text_field.dart';
import 'package:cus_dbs_app/pages/main/account/customer/vehicle/vehicle_controller.dart';
import 'package:cus_dbs_app/values/colors.dart';
import 'package:cus_dbs_app/values/server.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateVehiclePage extends StatelessWidget {
  final VehicleItem vehicle;

  const UpdateVehiclePage({Key? key, required this.vehicle}) : super(key: key);

  VehicleController get _vehicleController => Get.find<VehicleController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          leading: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _vehicleController.resetVehicleFormDataInput();

                Get.back();
              }),
          title: Text(_vehicleController.state.editMode.value
              ? "Chỉnh sửa phương tiện"
              : "Thông tin phương tiện"),
          actions: [
            IconButton(
              icon: _vehicleController.state.editMode.value
                  ? Icon(Icons.cancel)
                  : Icon(Icons.edit),
              onPressed: () {
                _vehicleController.toggleEditMode();
              },
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/images/car_logo.png",
                  height: 150,
                  width: 150,
                ),
                SizedBox(height: 20),
                SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Ảnh mặt trước',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(width: 5),
                          ],
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            if (_vehicleController.state.editMode.value) {
                              showImagePickerOption(context, 'Front');
                            }
                          },
                          child: Stack(
                            children: [
                              //có addImageFront tức là lúc đang update
                              //mà có chọn 1 ảnh khác thì ưu tiện hiện ảnh đó trước
                              _vehicleController.state.addImageFront.value !=
                                      null
                                  ? Container(
                                      width: 140,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: MemoryImage(_vehicleController
                                              .state.addImageFront.value!),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : _vehicleController.state.imageFront.value !=
                                          ''
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            '${SERVER_API_URL}${_vehicleController.state.imageFront.value}',
                                            width: 140,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Container(
                                          width: 140,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add,
                                                color: Colors.grey[600],
                                                size: 40,
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                'Tải ảnh lên',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Ảnh mặt sau',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(width: 5),
                          ],
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            if (_vehicleController.state.editMode.value) {
                              showImagePickerOption(context, 'Behind');
                            }
                          },
                          child: Stack(
                            children: [
                              _vehicleController.state.addImageBehind.value !=
                                      null
                                  ? Container(
                                      width: 140,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: MemoryImage(_vehicleController
                                              .state.addImageBehind.value!),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  :
                                  // ignore: unnecessary_null_comparison
                                  _vehicleController.state.imageBehind.value !=
                                              null &&
                                          _vehicleController
                                                  .state.imageBehind.value !=
                                              ''
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            '${SERVER_API_URL}${_vehicleController.state.imageBehind.value}',
                                            width: 140,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Container(
                                          width: 140,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add,
                                                color: Colors.grey[600],
                                                size: 40,
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                'Tải ảnh lên',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Ảnh mặt bên trái',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(width: 5),
                          ],
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            if (_vehicleController.state.editMode.value) {
                              showImagePickerOption(context, 'Left');
                            }
                          },
                          child: Stack(
                            children: [
                              _vehicleController.state.addImageLeft.value !=
                                      null
                                  ? Container(
                                      width: 140,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: MemoryImage(_vehicleController
                                              .state.addImageLeft.value!),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  :
                                  // ignore: unnecessary_null_comparison
                                  _vehicleController.state.imageLeft.value !=
                                              null &&
                                          _vehicleController
                                                  .state.imageLeft.value !=
                                              ''
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            '${SERVER_API_URL}${_vehicleController.state.imageLeft.value}',
                                            width: 140,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Container(
                                          width: 140,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add,
                                                color: Colors.grey[600],
                                                size: 40,
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                'Tải ảnh lên',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Ảnh mặt bên phải',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(width: 5),
                          ],
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            if (_vehicleController.state.editMode.value) {
                              showImagePickerOption(context, 'Right');
                            }
                          },
                          child: Stack(
                            children: [
                              _vehicleController.state.addImageRight.value !=
                                      null
                                  ? Container(
                                      width: 140,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: MemoryImage(_vehicleController
                                              .state.addImageRight.value!),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  :
                                  // ignore: unnecessary_null_comparison
                                  _vehicleController.state.imageRight.value !=
                                              null &&
                                          _vehicleController
                                                  .state.imageRight.value !=
                                              ''
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            '${SERVER_API_URL}${_vehicleController.state.imageRight.value}',
                                            width: 140,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Container(
                                          width: 140,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add,
                                                color: Colors.grey[600],
                                                size: 40,
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                'Tải ảnh lên',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
                // Biển số xe
                SizedBox(height: 20),
                CustomTextField(
                  labelText: "Biển số xe",
                  prefixIcon: Icons.person,
                  controller: _vehicleController.licensePlateController,
                  inputType: TextInputType.text,
                  readOnlyStatus: !_vehicleController.state.editMode.value,
                ),

                // brand
                SizedBox(height: 20),
                CustomTextField(
                  labelText: "Nhãn hiệu",
                  prefixIcon: Icons.language,
                  controller: _vehicleController.brandController,
                  inputType: TextInputType.text,
                  readOnlyStatus: true,
                  onTap: () async {
                    if (_vehicleController.state.editMode.value) {
                      await _vehicleController.fetchAllBrandOfCarFromApi();
                      showBrandOfCarList(context);
                    }
                  },
                ),

                // model
                SizedBox(height: 20),
                CustomTextField(
                  labelText: "Loại xe",
                  prefixIcon: Icons.home,
                  controller: _vehicleController.modelController,
                  inputType: TextInputType.text,
                  readOnlyStatus: true,
                  onTap: () async {
                    if (_vehicleController.state.editMode.value) {
                      if (_vehicleController.checkBrandValueExisted()) {
                        await _vehicleController.fetchAllModelOfBrandFromApi();
                        showModelOfBrandList(context);
                      }
                    }
                  },
                ),
                if (_vehicleController
                    .state.errorSelectedModel.value.isNotEmpty)
                  Text(
                    _vehicleController.state.errorSelectedModel.value,
                    style: TextStyle(color: Colors.red),
                  ),

                // màu xe color
                SizedBox(height: 20),
                CustomTextField(
                  labelText: "Màu xe",
                  prefixIcon: Icons.color_lens,
                  controller: _vehicleController.colorController,
                  inputType: TextInputType.text,
                  readOnlyStatus: !_vehicleController.state.editMode.value,
                ),

                //  button
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: _vehicleController.state.editMode.value
                      ? ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              AppColors.primaryElement,
                            ),
                          ),
                          child: Text(
                            'Cập nhập',
                            style:
                                TextStyle(color: AppColors.primaryElementText),
                          ),
                          onPressed: () async {
                            await _vehicleController
                                .handleCallApiToUpdateVehicle(
                                    newVehicleItem: vehicle);
                          },
                        )
                      : ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.red),
                            overlayColor: MaterialStateProperty.all<Color>(
                                Colors.red.withOpacity(0.1)),
                            side: MaterialStateProperty.all<BorderSide>(
                              BorderSide(color: Colors.red, width: 1),
                            ),
                          ),
                          child: Text(
                            'Xóa phương tiện',
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            Get.defaultDialog(
                              title: "Xác nhận",
                              titleStyle: const TextStyle(fontSize: 20),
                              content: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 15.0),
                                child: Text(
                                  "Bạn có chắc chắn muốn xóa phương tiện này?",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              cancel: SizedBox(
                                height: 50,
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await _vehicleController
                                        .callApiToDeleteVehicle();
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue.shade400,
                                      side: BorderSide.none),
                                  child: const Text(
                                    "Xác nhận",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              confirm: SizedBox(
                                height: 50,
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () => Get.back(),
                                  child: const Text("Không"),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showImagePickerOption(BuildContext context, String imageType) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (builder) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 7,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _vehicleController.pickImageFromGallery(
                          context, imageType);
                    },
                    child: const SizedBox(
                      child: Column(
                        children: [
                          Icon(
                            Icons.image,
                            size: 70,
                          ),
                          Text("Gallery")
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _vehicleController.pickImageFromCamera(
                          context, imageType);
                    },
                    child: const SizedBox(
                      child: Column(
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 70,
                          ),
                          Text("Camera")
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //chọn nhãn hiệu xe
  void showBrandOfCarList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BottomSheet(
          onClosing: () {},
          builder: (BuildContext context) {
            return Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      'Chọn nhãn hiệu xe',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: _vehicleController.state.dataBrands.value
                            .map((brand) => Column(
                                  children: [
                                    _buildSelectedBrandOption(
                                      context,
                                      brand,
                                    )
                                  ],
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSelectedBrandOption(
    BuildContext context,
    BrandEntity brand,
  ) {
    return Obx(
      () => InkWell(
        onTap: () {
          _vehicleController.changeBrandSelection(brand);
          Navigator.of(context).pop();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Row(
            children: [
              Image.asset(
                _vehicleController.getBrandLogoPath(brand.brandName ?? ""),
                height: 30,
                width: 30,
              ),
              SizedBox(width: 15),
              Expanded(
                child: Text(
                  brand.brandName ?? 'Không xác định',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Spacer(),
              if (_vehicleController.state.selectedBrand.value ==
                  brand.brandName)
                Icon(
                  Icons.check,
                  color: Colors.blue.shade400,
                ),
            ],
          ),
        ),
      ),
    );
  }

//Chọn loại xe ứng với nhãn hiệu
  void showModelOfBrandList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BottomSheet(
          onClosing: () {},
          builder: (BuildContext context) {
            return Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      'Chọn loại xe',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: _vehicleController.state.dataModels.value
                            .map(
                              (model) => Column(
                                children: [
                                  _buildSelectedModelOption(
                                    context,
                                    model.modelName ?? "",
                                  )
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSelectedModelOption(
    BuildContext context,
    String modelName,
  ) {
    return Obx(
      () => InkWell(
        onTap: () {
          _vehicleController.changeModelSelection(modelName);
          Navigator.of(context).pop();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Row(
            children: [
              // Image.asset(
              //   'assets/icons/vnpay.png',
              //   height: 25,
              //   width: 25,
              //   fit: BoxFit.cover,
              // ),
              SizedBox(width: 15),
              Expanded(
                child: Text(
                  modelName,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Spacer(),
              if (_vehicleController.state.selectedModel.value == modelName)
                Icon(
                  Icons.check,
                  color: Colors.blue.shade400,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
