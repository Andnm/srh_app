import 'dart:convert';

import 'package:cus_dbs_app/common/entities/car_model.dart';
import 'package:cus_dbs_app/common/entities/vehicle.dart';
import 'package:cus_dbs_app/common/widgets/custom_dropdown_field.dart';
import 'package:cus_dbs_app/common/widgets/custom_text_field.dart';
import 'package:cus_dbs_app/pages/main/account/customer/vehicle/vehicle_controller.dart';
import 'package:cus_dbs_app/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddNewVehiclePage extends StatelessWidget {
  const AddNewVehiclePage({Key? key}) : super(key: key);

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
          title: Text("Thêm thông tin phương tiện"),
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
                            showImagePickerOption(context, 'Front');
                          },
                          child: Stack(
                            children: [
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
                                  : Container(
                                      width: 140,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(10),
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
                            showImagePickerOption(context, 'Behind');
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
                                  : Container(
                                      width: 140,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(10),
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
                            showImagePickerOption(context, 'Left');
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
                                  : Container(
                                      width: 140,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(10),
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
                            showImagePickerOption(context, 'Right');
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
                                  : Container(
                                      width: 140,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(10),
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
                  readOnlyStatus: false,
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
                    await _vehicleController.fetchAllBrandOfCarFromApi();
                    showBrandOfCarList(context);
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
                    if (_vehicleController.checkBrandValueExisted()) {
                      await _vehicleController.fetchAllModelOfBrandFromApi();
                      showModelOfBrandList(context);
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
                  readOnlyStatus: false,
                ),

                //  button
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith<Color>((states) {
                        if (_vehicleController.areAllFieldsFilled()) {
                          return AppColors.primaryElement;
                        } else {
                          return AppColors.primaryBackground;
                        }
                      }),
                    ),
                    child: Text(
                      'Xác nhận thêm',
                      style: TextStyle(
                          color: _vehicleController.areAllFieldsFilled()
                              ? AppColors.primaryElementText
                              : Colors.grey),
                    ),
                    onPressed: _vehicleController.areAllFieldsFilled()
                        ? () async {
                            await _vehicleController.handleAddNewVehicle();
                            Navigator.of(context).pop();
                          }
                        : () {},
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
