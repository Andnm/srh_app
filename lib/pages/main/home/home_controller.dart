import 'dart:async';

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cus_dbs_app/app/search_request_status_type.dart';
import 'package:cus_dbs_app/common/apis/customer_api.dart';
import 'package:cus_dbs_app/common/entities/address_model.dart';
import 'package:cus_dbs_app/common/entities/direction_detail.dart';
import 'package:cus_dbs_app/common/entities/driver.dart';
import 'package:cus_dbs_app/common/entities/emergency.dart';
import 'package:cus_dbs_app/common/entities/notification/notification_booking_request.dart';
import 'package:cus_dbs_app/common/entities/notification/notification_search_request.dart';
import 'package:cus_dbs_app/common/entities/search_request_model.dart';
import 'package:cus_dbs_app/common/widgets/dialogs/alert_dialog.dart';
import 'package:cus_dbs_app/pages/main/account/wallet/index.dart';

import 'package:cus_dbs_app/pages/main/home/map/index.dart';
import 'package:cus_dbs_app/pages/main/home/widget/customer/home_customer.dart';
import 'package:cus_dbs_app/pages/main/main/index.dart';
import 'package:cus_dbs_app/routes/routes.dart';
import 'package:cus_dbs_app/services/socket_service.dart';
import 'package:cus_dbs_app/values/booking.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/apis/driver_api.dart';
import '../../../../common/entities/booking.dart';
import '../../../../common/entities/place.dart';

import '../../../app/booking_status_type.dart';
import '../../../app/emergency.dart';
import '../../../app/payment_method_type.dart';
import '../../../common/apis/emergency_api.dart';
import '../../../common/apis/payment_api.dart';
import '../../../common/apis/search_request.dart';
import '../../../common/apis/wallet_api.dart';

import '../../../common/entities/booking_image.dart';
import '../../../common/entities/wallet.dart';
import '../../../common/widgets/info_dialog.dart';

import '../../../global.dart';
import '../../../store/user_store.dart';
import '../../../utils/connectivity.dart';
import '../../../values/colors.dart';
import '../../../values/roles.dart';
import 'index.dart';

class HomeController extends GetxController {
  MapController get mapPageController => Get.find<MapController>();
  WalletController get walletController => Get.find<WalletController>();
  bool get isEnoughMoney =>
      walletController.state.currentMoney >= state.priceOfSearchRequest.value;

  TextEditingController textSearchPickCl = TextEditingController();
  TextEditingController textSearchDropOffCl = TextEditingController();
  TextEditingController emergencyNoteController = TextEditingController();
  List<TextEditingController>? controllers;

  final state = HomeState();
  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  RxBool isBottomSheet = false.obs;

  RxBool isInitializedLocation = false.obs;
  String? lastOldDriverId;

  RxBool isShowWidgets = false.obs;
  RxBool isFinishCheckOut = false.obs;
  RxBool isResponsedBooking = false.obs;

  final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');

  CameraController? cameraController;
  List<CameraDescription>? cameras;

  final RxInt imageIndex = 0.obs;
  final RxBool isCaptured = false.obs;
  final RxBool isCheckInApi = true.obs;

  final Map<String, String> imageTypeMap = {
    "Ảnh khách hàng": "Customer",
    "Mặt trước xe": "Front",
    "Mặt sau xe": "Behind",
    "Mặt trái xe": "Left",
    "Mặt phải xe": "Right",
  };
  final List<String> imageTypes = [
    "Ảnh khách hàng",
    "Mặt trước xe",
    "Mặt sau xe",
    "Mặt trái xe",
    "Mặt phải xe",
  ];
  final List<String> noteTypes = [
    "Khách hàng",
    "Mặt trước xe",
    "Mặt sau xe",
    "Mặt trái xe",
    "Mặt phải xe",
  ];

  RxString notes = "".obs;
  String? noteEmergency;
  String? senderAddress;
  List<File> capturedImages = [];
  String? selectedReason;
  TextEditingController otherReasonController = TextEditingController();

  final LayerLink layerLink = LayerLink();
  var timerCountDown;

  NotificationDriver? get driverInfo => state.appBookingData.value?.driver;

  NotificationCustomer? get customerInfo =>
      state.appBookingData.value?.customer;
  BookingNotiCustomerBookedOnBehalf? get customerOnBehalfInfo =>
      state.appBookingData.value?.searchRequest?.customerBookedOnBehalf;
  RxBool isDoneCaptured = false.obs;

  bool isFromTerminated = false;
  bool isNotCompleteBookingResult = false;

  bool get isBookByMySelfStatusForCustomer => BookingTypes.isBookByMyself.value;
  bool get isBookByMySelfStatusForDriver => customerOnBehalfInfo == null;
  int? get statusBooking => state.appBookingData.value?.status;

  bool get isDriver => state.isRoleDriver.value;

  bool get isPending => state.statusOfBooking.value == BOOKING_STATUS.PENDING;

  bool get isAccept => state.statusOfBooking.value == BOOKING_STATUS.ACCEPT;

  bool get isArrived => state.statusOfBooking.value == BOOKING_STATUS.ARRIVED;
  bool get isCheckIn => state.statusOfBooking.value == BOOKING_STATUS.CHECKIN;

  bool get isOnGoing => state.statusOfBooking.value == BOOKING_STATUS.ONGOING;
  bool get isCheckOut => state.statusOfBooking.value == BOOKING_STATUS.CHECKOUT;
  bool get isComplete => state.statusOfBooking.value == BOOKING_STATUS.COMPLETE;

  bool get isCancel => state.statusOfBooking.value == BOOKING_STATUS.CANCEL;

  bool get isCheckInOrOut => isCheckIn || isCheckOut;
  bool get isShowInfo => isAccept || isArrived || isOnGoing || isCheckInOrOut;
  bool get isFromOnGoingToComplete => isOnGoing || isCheckInOrOut || isComplete;
  // isAccept || isArrived || isOnGoing || (!isDriver && isCheckInOrOut);
  bool get isAvailableCancel => isAccept || isArrived || isCheckIn;
  bool get isAvailableEmergency => isOnGoing || isCheckOut;
  //Customer
  bool get isSearchRequest => isPending || isShowDriver;

  bool get isShowDriver =>
      state.statusOfBooking.value == BOOKING_STATUS.SHOW_DRIVER;

  bool get isBooking =>
      state.statusOfBooking.value == BOOKING_STATUS.SEARCH_DRIVER;

  //Driver
  bool get isShowOnOffDriver => isPending || isComplete || isCancel;

  @override
  Future<void> onInit() async {
    super.onInit();
    print("init location");
    await InternetChecker.startListening();
    await SignalRService.initialize();
    await initLocation();

    controllers =
        List.generate(noteTypes.length, (_) => TextEditingController());
    if (!isDriver) {
      await checkIsFromTerminated();
    }
    await getPriceConfiguration();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  Future<void> getPriceConfiguration() async {
    try {
      var priceConfigurationPrice = await CustomerAPI.getPriceConfiguration();
      if (priceConfigurationPrice != null) {
        state.priceConfigurationPrice = priceConfigurationPrice;
      }
    } catch (e) {
      print("error to get price configuration $e");
    }
  }

  Future<void> checkIsFromTerminated() async {
    var response = await CustomerAPI.checkExistSearchRequestProcessing();
    if (response != null && response is SearchRequestModel) {
      isFromTerminated = true;
      SearchRequestModel searchRequestModel = response;
      updateSearchRequestModel(searchRequestModel: searchRequestModel);
      Get.toNamed(AppRoutes.mapCustomer);
    } else {
      var checkExistBookingResult =
          await CustomerAPI.checkExistBookingNotComplete();
      if (checkExistBookingResult) {
        isFromTerminated = true;
        isNotCompleteBookingResult = true;
        Get.toNamed(AppRoutes.mapCustomer);
      } else {
        return;
      }
    }
  }

  Future<void> initLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Kiểm tra xem dịch vụ vị trí có được bật không
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      } else {
        isInitializedLocation.value = true;
      }
    }

    // Kiểm tra quyền vị trí
    permissionGranted = await location.hasPermission();

    if (permissionGranted == PermissionStatus.denied ||
        permissionGranted == PermissionStatus.deniedForever) {
      // Yêu cầu cấp quyền vị trí trước khi hiển thị hộp thoại
      permissionGranted = await location.requestPermission();
      print("permissionGranted: ${permissionGranted.toString()}");
      if (permissionGranted == PermissionStatus.denied ||
          permissionGranted == PermissionStatus.deniedForever) {
        while (true) {
          await Get.defaultDialog(
            title: "Yêu cầu cấp quyền",
            middleText:
                "Ứng dụng cần quyền truy cập vị trí để hoạt động chính xác. Vui lòng cấp quyền.",
            textConfirm: "OK",
            confirmTextColor: Colors.white,
            onConfirm: () async {
              await ph.openAppSettings();
              // Wait until the user has granted permission before closing the dialog
              while (true) {
                await Future.delayed(Duration(seconds: 1));
                permissionGranted = await location.hasPermission();
                if (permissionGranted == PermissionStatus.granted) {
                  isInitializedLocation.value = true;
                  Get.back();
                  break;
                }
              }
            },
            barrierDismissible:
                false, // Prevents the dialog from being dismissed
          );

          permissionGranted = await location.hasPermission();
          if (permissionGranted == PermissionStatus.granted) {
            isInitializedLocation.value = true;
            break;
          }
        }
      } else {
        isInitializedLocation.value = true;
      }
    } else {
      isInitializedLocation.value = true;
    }
  }

  Future<void> initCamera() async {
    try {
      if (cameraController != null && cameraController!.value.isInitialized) {
        return;
      }

      await availableCameras().then((availableCameras) {
        cameras = availableCameras;
        if (cameras!.isNotEmpty) {
          cameraController = CameraController(
            cameras![0],
            ResolutionPreset.high,
            enableAudio: false,
          );
          cameraController!.initialize().then((_) {
            if (!cameraController!.value.isInitialized) {
              return;
            }

            cameraController!
                .lockCaptureOrientation(DeviceOrientation.portraitUp);
            update();
          });
        }
      });
    } catch (e) {
      print("Error initializing camera: $e");
      // Handle the error, show an error message, or perform any necessary actions
    }
  }

  void initCustomer(LocationData locationData) async {
    final address = await mapPageController
        .convertGeoGraphicCoOrdinatesIntoHumanReadableAddress(locationData);
    mapPageController.state.currentAddress.value = address;
    textSearchPickCl.text = address;
    print('address updated::' + textSearchPickCl.text);
  }

  checkAvailabilityOfBookingRequest() {
    // EasyLoading.show(
    //     indicator: const CircularProgressIndicator(),
    //     maskType: EasyLoadingMaskType.clear,
    //     dismissOnTap: true);
    //kiem tra request con ton tai khong
    //goi ham accept booking, con cancel thi sao
    //sau do chuyen sang ham search update driver off booking tiep tuc kiem tra
    // mapPageController.updateBookingStatus(BOOKING_STATUS.ACCEPT);
  }

  Future<void> updateStatusDriver({required bool isOnline}) async {
    try {
      if (isOnline) {
        var onlineDriver = await DriverAPI.switchToOnline();

        print('Activated');
      } else {
        var onlineDriver = await DriverAPI.switchToOffline();

        print('Deactivated');
      }

      await sendDriverLocationToBackend();
      state.isAvailableDriver.value = isOnline;
    } catch (e) {
      print('Driver status: $e ');
    }
  }

  Future<void> sendDriverLocationToBackend() async {
    try {
      PlaceLocation placeLocation = PlaceLocation(
        latitude: mapPageController.state.currentLocation.value.latitude ?? 0.0,
        longitude:
            mapPageController.state.currentLocation.value.longitude ?? 0.0,
      );
      var driverLocation =
          await DriverAPI.updateDriverLocationToBackEnd(params: placeLocation);

      print('Location data sent successfully.');
    } catch (e) {
      print('Error sending location data: $e');
    }
  }

  Future<void> sendCustomerLocationToBackend() async {
    try {
      PlaceLocation placeLocation = PlaceLocation(
        latitude: mapPageController.state.currentLocation.value.latitude ?? 0.0,
        longitude:
            mapPageController.state.currentLocation.value.longitude ?? 0.0,
      );
      var driverLocation = await CustomerAPI.updateCustomerLocationToBackEnd(
          params: placeLocation);

      print('Location data sent successfully.');
    } catch (e) {
      print('Error sending location data: $e');
    }
  }

  //Customer
  void updateBookingStatus(BOOKING_STATUS status) async {
    state.statusOfBooking.value = status;

    print('updateBookingStatus:' + state.statusOfBooking.value.toString());
  }

  void updateSearchRequestStatus(SEARCH_REQUEST_STATUS status) {
    if (status == SEARCH_REQUEST_STATUS.CANCEL) {
      Get.back();
    } else {
      state.statusOfSearchRequest.value = status;
    }
    print('updateSearchRequestStatus:' +
        state.statusOfSearchRequest.value.toString());
  }

  void updatePaymentMethodStatus(PAYMENT_METHOD_STATUS status) {
    state.statusOfPayment.value = status.name;
    print('updatePaymentMethodStatus:' + state.statusOfPayment.value);
  }

  String getIconPath(String bookingPaymentMethod) {
    switch (bookingPaymentMethod) {
      case "Thẻ ATM":
        return "assets/icons/atm.png";
      case "MoMo":
        return "assets/icons/momo.png";
      case "VNPay":
        return "assets/icons/vnpay.png";
      case "SecureWallet":
        return "assets/icons/wallet.png";
      default:
        return "assets/icons/cash.png";
    }
  }

  void updateSearchCustomer(bool isPick, {VoidCallback? callSuccess}) async {
    String tempValue =
        isPick ? textSearchPickCl.text : textSearchDropOffCl.text;
    if (isPick) {
      textSearchPickCl.text = "";
    } else {
      textSearchDropOffCl.text = "";
    }
    Get.toNamed(AppRoutes.search,
            arguments:
                isPick ? textSearchPickCl.text : textSearchDropOffCl.text)
        ?.then((value) async {
      final address = value as AddressModel?;
      if (address != null) {
        if (isPick) {
          textSearchPickCl.text = address.placeName ?? '';
          mapPageController.state.pickUpLocation.value = address;
          await retrieveDirectionDetails();
        } else {
          textSearchDropOffCl.text = address.placeName ?? '';
          mapPageController.state.dropOffLocation.value = address;

          //Vẽ đg
          await retrieveDirectionDetails();
          // Get.find<MainController>().updateIsShowBottom(false);
          // await getAvailableNearbyOnlineDriversOnMap();
          if (callSuccess != null) {
            updateBookingStatus(BOOKING_STATUS.SHOW_DRIVER);

            callSuccess();
          }
        }
      } else {
        // Nếu không chọn địa chỉ, gán lại giá trị đã lưu
        if (isPick) {
          textSearchPickCl.text = tempValue;
        } else {
          textSearchDropOffCl.text = tempValue;
        }
      }
    });
  }

  Future<dynamic> payForSearchRequest() async {
    return await goToPaymentBookingUrl(
        amount: state.priceOfSearchRequest.value,
        dropOffAddress:
            mapPageController.state.dropOffLocation.value?.placeName);
  }

  Future<dynamic> goToPaymentBookingUrl(
      {String? dropOffAddress, required num amount}) async {
    try {
      String responseLinkUrl = '';

      switch (walletController.state.selectedPaymentMethod.value) {
        case "VNPay":
          var response =
              await PaymentAPI.createVNPayPaymenBookingtUrl(amount: amount);
          responseLinkUrl = response;
          if (responseLinkUrl.isNotEmpty) {
            final Uri _url = Uri.parse(responseLinkUrl);
            await launchUrl(_url);
          } else {
            print("No deeplink returned in the response.");
          }
          return response;

        case "MoMo":
          var response = await PaymentAPI.createMoMoPaymentBookingUrl(
              amount: amount, dropOffAddress: dropOffAddress);
          responseLinkUrl = response.data!.deeplink ?? '';
          if (responseLinkUrl.isNotEmpty) {
            final Uri _url = Uri.parse(responseLinkUrl);
            await launchUrl(_url);
          } else {
            print("No deeplink returned in the response.");
          }
          return response;
        case "SecureWallet":
          if (!isEnoughMoney) {
            Get.dialog(Dialog(
              backgroundColor: AppColors.dialogColor,
              child: Padding(
                padding: EdgeInsets.all(16.0.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 16.0.h),
                    Text(
                      'Rất tiếc, Số dư SecureWallet của bạn không đủ để thực hiện thanh toán. Vui lòng lựa chọn phương thức thanh toán khác.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.primaryText.withOpacity(0.8)),
                    ),
                    Divider(
                      height: 20.h,
                      thickness: 1.h,
                      color: Colors.grey[400],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryElement,
                            foregroundColor: AppColors.surfaceWhite,
                            minimumSize: Size(100.w, 40.h),
                          ),
                          child: const Text('Đóng'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ));
            return;
          } else {
            var response = await WalletAPI.payWithWallet(totalMoney: amount);
            return response;
          }

        default:
          Get.snackbar(
            'Thông báo:',
            'Tính năng chưa hỗ trợ, vui lòng chọn phương thức khác',
            backgroundColor: Colors.white,
            colorText: Colors.orange,
            borderWidth: 1,
            boxShadows: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          );
      }

      // Get.back();
    } catch (e) {
      print("Error launch App $e");
    } finally {}
  }

  // Future<void> handleTerminatedAppData() async {
  //   var response = await CustomerAPI.checkExistSearchRequestProcessing();
  //   print("Response: hihi" + response.toString());
  //   if (response != null && response is SearchRequestModel) {
  //     SearchRequestModel searchRequestModel = response;
  //     updateBookingStatus(BOOKING_STATUS.SEARCH_DRIVER);
  //     await Get.toNamed(AppRoutes.mapCustomer);
  //     // updateSearchRequestDetail(searchRequestModel);
  //
  //     await getAvailableNearbyOnlineDriversTerminatedApp(
  //         isFemaleDriver: searchRequestModel.isFemaleDriver);
  //     await CustomerAPI.sendSearchRequestToDriver(
  //         searchRequestId: searchRequestModel.id,
  //         driverId: state.availableNearbyOnlineDriversList[0].id);
  //   }
  // }

  Future<void> searchRequest() async {
    isResponsedBooking.value = true;
    await getAvailableNearbyOnlineDrivers();
    try {
      EasyLoading.show(
          indicator: const CircularProgressIndicator(),
          maskType: EasyLoadingMaskType.clear,
          dismissOnTap: true);
      if (await checkAvailableDriver()) {
        var response = await payForSearchRequest();
        if (response is WalletModel) {
          await findDriverToSearchRequest();
        }
      }
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      print('Error in search request: $e');

      Get.dialog(
        CustomAlertDialog(
          content: "Đã xảy ra lỗi khi tìm tài xế. Vui lòng thử lại.",
          buttonText: "Đóng",
          onPressed: () {
            Get.back();
          },
        ),
      );
    } finally {
      isResponsedBooking.value = false;
    }
  }

  Future<void> findDriverToSearchRequest() async {
    try {
      updateBookingStatus(BOOKING_STATUS.SEARCH_DRIVER);
      await getAvailableNearbyOnlineDrivers();
      if (await checkAvailableDriver()) {
        if (isBookByMySelfStatusForCustomer) {
          state.requestSearchRequestModel = SearchRequestModel(
              pickupLatitude: mapPageController
                  .state.pickUpLocation.value?.latitudePosition,
              pickupLongitude: mapPageController
                  .state.pickUpLocation.value?.longitudePosition,
              dropOffLatitude: mapPageController
                  .state.dropOffLocation.value?.latitudePosition,
              dropOffLongitude: mapPageController
                  .state.dropOffLocation.value?.longitudePosition,
              distance: (((mapPageController.state.tripDirectionDetailsInfo
                              .value?.distanceValueDigits) ??
                          0) /
                      1000) *
                  1.0,
              pickupAddress:
                  mapPageController.state.pickUpLocation.value?.placeName,
              dropOffAddress:
                  mapPageController.state.dropOffLocation.value?.placeName,
              driverId: state.availableNearbyOnlineDriversList[0].id,
              bookingVehicle: state.requestVehicle.value,
              price: state.priceOfSearchRequest.value,
              isFemaleDriver: state.isFemaleDriver.value,
              bookingPaymentMethod:
                  walletController.state.selectedPaymentMethod.value);

          print('Myself search ${state.requestSearchRequestModel.toString()}');
        } else {
          print('CCHECK2');
          state.requestSearchRequestModel = SearchRequestModel(
              pickupLatitude: mapPageController
                  .state.pickUpLocation.value?.latitudePosition,
              pickupLongitude: mapPageController
                  .state.pickUpLocation.value?.longitudePosition,
              dropOffLatitude: mapPageController
                  .state.dropOffLocation.value?.latitudePosition,
              dropOffLongitude: mapPageController
                  .state.dropOffLocation.value?.longitudePosition,
              pickupAddress:
                  mapPageController.state.pickUpLocation.value?.placeName,
              dropOffAddress:
                  mapPageController.state.dropOffLocation.value?.placeName,
              driverId: state.availableNearbyOnlineDriversList[0].id,
              bookingVehicle: state.requestVehicle.value,
              customerBookedOnBehalf: state.requestCustomerBookedOnBehalf,
              bookingType: BookingTypes.getBookForSomeOneStatus,
              distance: (((mapPageController.state.tripDirectionDetailsInfo
                              .value?.distanceValueDigits) ??
                          0) /
                      1000) *
                  1.0,
              price: state.priceOfSearchRequest.value,
              isFemaleDriver: state.isFemaleDriver.value,
              bookingPaymentMethod:
                  walletController.state.selectedPaymentMethod.value);
          print(
              'Onbehalf search: ${state.requestSearchRequestModel.toString()}');
        }

        String? searchRequestId = await SearchRequestAPI.searchRequest(
            params: state.requestSearchRequestModel);

        if (searchRequestId != null) {
          state.requestSearchRequestModel.id = searchRequestId;
          // nhận search id từ notification
          state.appBookingData.value =
              NotificationBookingModel(searchRequestId: searchRequestId);
          removeDriverFromList(state.availableNearbyOnlineDriversList[0].id!);
          print('FINAL OBJECT: ${state.requestSearchRequestModel.toString()}');
          SignalRService.listenEvent("searchRequestDriverMiss",
              (arguments) async {
            print("Miss search request");

            await handleSearchRequestDriverMiss(arguments);
          });
        }
      }
    } catch (e) {
      print('Error in findDriverToSearchRequest: $e');
      // Xử lý lỗi tại đây, ví dụ: hiển thị thông báo lỗi cho người dùng
      Get.dialog(
        CustomAlertDialog(
          content: "Đã xảy ra lỗi khi tìm tài xế. Vui lòng thử lại.",
          buttonText: "Đóng",
          onPressed: () {
            Get.back();
          },
        ),
      );
    } finally {
      isResponsedBooking.value = false;
    }
  }

  Future<void> handleSearchRequestDriverMiss(List<dynamic>? arguments) async {
    if (arguments == null || arguments.isEmpty) {
      print("No arguments received");
      return;
    }

    String oldDriverId = arguments[0].toString();

    if (oldDriverId == lastOldDriverId) {
      print("Driver already processed");
      return;
    }

    lastOldDriverId = oldDriverId;

    if (await checkAvailableDriver()) {
      print(
          "before updateNewDriverToSearchRequest ${state.requestSearchRequestModel}");
      await CustomerAPI.updateNewDriverToSearchRequest(
        searchRequestId: state.requestSearchRequestModel.id!,
        oldDriverId: oldDriverId,
        newDriverId: state.availableNearbyOnlineDriversList[0].id!,
      );
      print(
          "after updateNewDriverToSearchRequest ${state.requestSearchRequestModel}");
      removeDriverFromList(
        state.availableNearbyOnlineDriversList[0].id!,
      );
      return;
    }
  }

  Future<bool> checkAvailableDriver() async {
    print('FLAG1');

    if (state.availableNearbyOnlineDriversList.isEmpty) {
      await cancelRideRequest();
      print('showDiaglog');

      if (isBooking) {
        print(
            'before cancelSearchRequest ${state.requestSearchRequestModel.id}');
        await SearchRequestAPI.cancelSearchRequest(
          searchRequestId: state.requestSearchRequestModel.id,
        );
        // Get.offAll(() => HomeCustomerPage());
        Get.back();
      }
      resetAppStatus();
      // showDialog(
      //     context: Get.context!,
      //     barrierDismissible: false,
      //     builder: (BuildContext context) => InfoDialog(
      //           title: "Tất cả tài xế hiện đang bận",
      //           description: "",
      //         ));
      Get.dialog(CustomAlertDialog(
        content:
            "Tất cả tài xế hiện đang bận.\n Bạn vui lòng thử lại sau ít phút...",
        buttonText: "Đóng",
        title: "Thông báo",
        onPressed: () {
          Get.back();
        },
      ));

      return false;
    } else {
      return true;
    }
  }

  void removeDriverFromList(String? driverID) {
    if (state.availableNearbyOnlineDriversList.isNotEmpty) {
      int index = state.availableNearbyOnlineDriversList
          .indexWhere((driver) => driver.id == driverID);

      if (index != -1) {
        state.availableNearbyOnlineDriversList.removeAt(index);
      }
    }
  }

  Future<void> cancelRideRequest() async {
    //remove ride request from database
    //ham remove search request
  }

  Future<void> calculateFareAmount(DirectionDetails? directionDetails) async {
    print(
        "priceConfigurationPrice: ${state.priceConfigurationPrice.toString()}");

    if (directionDetails == null) {
      return; // Trả về nếu thiếu dữ liệu đầu vào
    }

    double distanceInKm = (directionDetails.distanceValueDigits ?? 0) / 1000;

    // Tính tổng giá dịch vụ
    double servicePrice =
        state.priceConfigurationPrice.baseFareFirst3km!.price!.toDouble();
    if (distanceInKm > 3) {
      int additionalKm = (distanceInKm - 3).floor();
      double remainingDistance = distanceInKm - 3 - additionalKm;
      servicePrice +=
          state.priceConfigurationPrice.fareFerAdditionalKm!.price! *
              additionalKm;
      servicePrice +=
          state.priceConfigurationPrice.fareFerAdditionalKm!.price! *
              remainingDistance;
    }

    // Tính tổng tiền phụ phí
    double surchargeAmount = 0.0;

    // Lấy thời gian hiện tại
    DateTime currentTime = DateTime.now();
    String currentHour =
        "${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')}";

    // Kiểm tra phụ phí giờ cao điểm
    if (state.priceConfigurationPrice.peakHours != null &&
        isWithinTimeRange(
            currentHour, state.priceConfigurationPrice.peakHours!.time!)) {
      surchargeAmount += servicePrice *
          (state.priceConfigurationPrice.peakHours!.isPercent!
              ? state.priceConfigurationPrice.peakHours!.price! / 100
              : state.priceConfigurationPrice.peakHours!.price!);
    }

    // Kiểm tra phụ phí giờ đêm
    if (state.priceConfigurationPrice.nightSurcharge != null &&
        isWithinTimeRange(
            currentHour, state.priceConfigurationPrice.nightSurcharge!.time!)) {
      surchargeAmount += servicePrice *
          (state.priceConfigurationPrice.nightSurcharge!.isPercent!
              ? state.priceConfigurationPrice.nightSurcharge!.price! / 100
              : state.priceConfigurationPrice.nightSurcharge!.price!);
    }

    // Tính tổng phí dịch vụ và phụ phí
    double totalAmountWithServiceFee = servicePrice + surchargeAmount;

    state.priceOfSearchRequest.value = totalAmountWithServiceFee.toInt();
  }

  bool isWithinTimeRange(String currentHour, String timeRange) {
    try {
      List<String> rangeParts = timeRange.split('-');
      if (rangeParts.length != 2) {
        throw new FormatException(
            "Time range should contain exactly one '-' character.");
      }

      String startHour = rangeParts[0];
      String endHour = rangeParts[1];

      if (currentHour.compareTo(startHour) >= 0 &&
          currentHour.compareTo(endHour) <= 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error: ${e.toString()}");
      return false;
    }
  }

  Future<void> getAvailableNearbyOnlineDrivers() async {
    // var onlineDrivers = await CustomerAPI.getOnlineNearByDrivers(
    //   currentLatitude: mapPageController.state.currentLocation.value.latitude,
    //   currentLongtitude:
    //       mapPageController.state.currentLocation.value.longitude,
    //   radius: 3.0,
    // );
    try {
      OnlineNearByDriver onlineDriverRequest = OnlineNearByDriver(
          latitude: mapPageController.state.currentLocation.value.latitude,
          longitude: mapPageController.state.currentLocation.value.longitude,
          isFemaleDriver: state.isFemaleDriver.value,
          radius: 3.0);
      var onlineDrivers =
          await CustomerAPI.getOnlineNearByDrivers(params: onlineDriverRequest);
      state.availableNearbyOnlineDriversList.value = onlineDrivers;

      print(
          'Get OnlineDrivers : ${state.availableNearbyOnlineDriversList.value.toString()}');
    } catch (e) {
      print("Error to get online drivers: ${e.toString()}");
    }
  }

  Future<void> getAvailableNearbyOnlineDriversTerminatedApp(
      {bool? isFemaleDriver}) async {
    // var onlineDrivers = await CustomerAPI.getOnlineNearByDrivers(
    //   currentLatitude: mapPageController.state.currentLocation.value.latitude,
    //   currentLongtitude:
    //       mapPageController.state.currentLocation.value.longitude,
    //   radius: 3.0,
    // );

    try {
      EasyLoading.show(
          indicator: const CircularProgressIndicator(),
          maskType: EasyLoadingMaskType.clear,
          dismissOnTap: true);

      OnlineNearByDriver onlineDriverRequest = OnlineNearByDriver(
          latitude: mapPageController.state.currentLocation.value.latitude,
          longitude: mapPageController.state.currentLocation.value.longitude,
          isFemaleDriver: isFemaleDriver,
          radius: 3.0);
      var onlineDrivers =
          await CustomerAPI.getOnlineNearByDrivers(params: onlineDriverRequest);
      state.availableNearbyOnlineDriversList.value = onlineDrivers;
      print(
          'Get OnlineDrivers : ${state.availableNearbyOnlineDriversList.value.toString()}');
      EasyLoading.dismiss();
    } catch (e) {
      print("error to getAvailableNearbyOnlineDriversTerminatedApp $e ");
    } finally {
      EasyLoading.dismiss();
    }
  }

  updateAvailableNearbyOnlineDriversOnMap() {
    print("start UPDATE availableNearbyOnlineDrivers");
    for (OnlineNearByDriver? eachOnlineNearbyDriver
        in state.availableNearbyOnlineDriversList) {
      if (eachOnlineNearbyDriver == null) {
        return;
      }
      LatLng driverCurrentPosition = LatLng(
          eachOnlineNearbyDriver.latitude ?? 0.0,
          eachOnlineNearbyDriver.longitude ?? 0.0);

      Marker driverMarker = Marker(
        markerId:
            MarkerId("driver ID = " + eachOnlineNearbyDriver.id.toString()),
        position: driverCurrentPosition,
        icon: mapPageController.state.driverDefaultIcon.value,
      );

      mapPageController.state.markerSet.add(driverMarker);
      print("UPDATE availableNearbyOnlineDrivers");
    }
  }

  Future<void> updateSearchRequestDetail(
      NotificationSearchRequestModel searchRequestModel) async {
    state.appBookingData.value = NotificationBookingModel(
      id: searchRequestModel.id,
      driverId: searchRequestModel.driverId,
      searchRequestId: searchRequestModel.id,
      customer: searchRequestModel.customer,
      status: searchRequestModel.status,
      searchRequest: searchRequestModel,
    );
    print("updateSearchRequestDetail ${state.appBookingData.value.toString()}");
    if (isDriver) {
      mapPageController.updateCustomerLocation(
        mapPageController.convertAddress(true, searchRequestModel),
        mapPageController.convertAddress(false, searchRequestModel),
      );
    }
    switch (searchRequestModel.status) {
      case 0:
        updateSearchRequestStatus(SEARCH_REQUEST_STATUS.PROCESSING);
        break;
      case 1:
        updateSearchRequestStatus(SEARCH_REQUEST_STATUS.COMPLETED);
        break;
      case 2:
        updateSearchRequestStatus(SEARCH_REQUEST_STATUS.CANCEL);
        break;
      default:
        updateSearchRequestStatus(SEARCH_REQUEST_STATUS.PROCESSING);
        break;
    }
    switch (searchRequestModel.bookingPaymentMethod) {
      case 0:
        updatePaymentMethodStatus(PAYMENT_METHOD_STATUS.CASH);
        break;
      case 1:
        updatePaymentMethodStatus(PAYMENT_METHOD_STATUS.SECUREWALLET);
        break;
      case 2:
        updatePaymentMethodStatus(PAYMENT_METHOD_STATUS.MOMO);
        break;
      case 3:
        updatePaymentMethodStatus(PAYMENT_METHOD_STATUS.VNPAY);
        break;
      default:
        updatePaymentMethodStatus(PAYMENT_METHOD_STATUS.SECUREWALLET);
        break;
    }
  }

  void updateSearchRequestModel(
      {SearchRequestModel? searchRequestModel, String? driverId}) {
    if (searchRequestModel != null) {
      state.requestSearchRequestModel = searchRequestModel;
    }

    if (driverId != null) {
      state.requestSearchRequestModel.driverId = driverId;
    }
  }

  Future<void> updateBookingDetail(int? status,
      {NotificationBookingModel? notificationBookingModel}) async {
    if (notificationBookingModel != null) {
      state.appBookingData.value = notificationBookingModel;
      if (isDriver) {
        mapPageController.updateCustomerLocation(
          mapPageController.convertAddress(
              true, notificationBookingModel.searchRequest),
          mapPageController.convertAddress(
              false, notificationBookingModel.searchRequest),
        );
      } else {
        mapPageController
            .updateDriverLocation(notificationBookingModel.driverLocation);
      }
    }
    switch (status) {
      case 0:
        updateBookingStatus(BOOKING_STATUS.PENDING);
        break;
      case 1:
        updateBookingStatus(BOOKING_STATUS.ACCEPT);

        break;
      case 2:
        updateBookingStatus(BOOKING_STATUS.ARRIVED);
        break;
      case 3:
        updateBookingStatus(BOOKING_STATUS.CHECKIN);
        break;
      case 4:
        updateBookingStatus(BOOKING_STATUS.ONGOING);
        break;
      case 5:
        updateBookingStatus(BOOKING_STATUS.CHECKOUT);
        break;
      case 6:
        updateBookingStatus(BOOKING_STATUS.COMPLETE);
        break;
      case 7:
        updateBookingStatus(BOOKING_STATUS.CANCEL);
        break;

      default:
        updateBookingStatus(BOOKING_STATUS.ACCEPT);
        break;
    }
    switch (notificationBookingModel?.searchRequest?.bookingPaymentMethod) {
      case 0:
        updatePaymentMethodStatus(PAYMENT_METHOD_STATUS.CASH);
        break;
      case 1:
        updatePaymentMethodStatus(PAYMENT_METHOD_STATUS.SECUREWALLET);
        break;
      case 2:
        updatePaymentMethodStatus(PAYMENT_METHOD_STATUS.MOMO);
        break;
      case 3:
        updatePaymentMethodStatus(PAYMENT_METHOD_STATUS.VNPAY);
        break;
      default:
        updatePaymentMethodStatus(PAYMENT_METHOD_STATUS.SECUREWALLET);
        break;
    }
    print(
        'statusOfBooking::$status ::' + state.statusOfBooking.value.toString());
    if (!isDriver) {
      SignalRService.listenEvent("TrackingDriverLocation", (arguments) async {
        if (arguments is List && arguments.isNotEmpty) {
          var locationData = arguments[0];
          if (locationData is Map<String, dynamic>) {
            double? driverLatitude = locationData['latitude'];
            double? driverLongitude = locationData['longitude'];
            if (driverLatitude != null && driverLongitude != null) {
              await updateDriverLocationFromSocket(
                  newDriverLatitude: driverLatitude,
                  newDriverLongitude: driverLongitude);
            }
          }
        }
      });
      if (isNotCompleteBookingResult) {
        mapPageController.state.dropOffLocation.value = mapPageController
            .convertAddress(true, notificationBookingModel?.searchRequest);
        mapPageController.state.dropOffLocation.value = mapPageController
            .convertAddress(false, notificationBookingModel?.searchRequest);
      }
      await retrieveDirectionDetails();
    }
  }

  String getStatusBookingCustomer() {
    switch (state.statusOfBooking.value) {
      case BOOKING_STATUS.PENDING:
        return '';
      case BOOKING_STATUS.ACCEPT:
        return 'Tài xế đang trên đường đến';
      case BOOKING_STATUS.ARRIVED:
        return 'Tài xế đã đến nơi';
      case BOOKING_STATUS.CHECKIN:
        return 'Đang kiểm tra tình trạng xe';
      case BOOKING_STATUS.ONGOING:
        return 'Đang đến địa điểm trả khách';
      case BOOKING_STATUS.CHECKOUT:
        return 'Đang kiểm tra tình trạng xe';
      default:
        return 'Unknown';
    }
  }

  //Driver
  Future<void> responseBooking(
      {BookingRequestModel? bookingRequestModel}) async {
    try {
      checkAvailabilityOfBookingRequest();
      BookingRequestModel notificationBookingModel;
      if (bookingRequestModel != null) {
        notificationBookingModel = bookingRequestModel;
      } else {
        notificationBookingModel = BookingRequestModel(
            id: state.appBookingData.value?.id,
            driverId: state.appBookingData.value?.driverId);
      }
      double? distanceFromCurrentLocationToDropOffLocation;

      switch (state.statusOfBooking.value) {
        case BOOKING_STATUS.ACCEPT:
          distanceFromCurrentLocationToDropOffLocation =
              await mapPageController.calculateDistanceByGoogleMapAPI(
            mapPageController.state.currentLocation.value.latitude ?? 0.0,
            mapPageController.state.currentLocation.value.longitude ?? 0.0,
            mapPageController.state.pickUpLocation.value?.latitudePosition ??
                0.0,
            mapPageController.state.pickUpLocation.value?.longitudePosition ??
                0.0,
          );

          if (distanceFromCurrentLocationToDropOffLocation != null &&
              distanceFromCurrentLocationToDropOffLocation > 1) {
            Get.dialog(
              CustomAlertDialog(
                content: "Khoảng cách bạn quá xa so với địa điểm đón khách.",
                buttonText: "Đóng",
                onPressed: () {
                  Get.back();
                },
              ),
            );
            return; // Exit the function updateBookingStatus
          }
          break;

        case BOOKING_STATUS.ONGOING:
          distanceFromCurrentLocationToDropOffLocation =
              await mapPageController.calculateDistanceByGoogleMapAPI(
            mapPageController.state.currentLocation.value.latitude ?? 0.0,
            mapPageController.state.currentLocation.value.longitude ?? 0.0,
            mapPageController.state.dropOffLocation.value?.latitudePosition ??
                0.0,
            mapPageController.state.dropOffLocation.value?.longitudePosition ??
                0.0,
          );

          if (distanceFromCurrentLocationToDropOffLocation! > 1) {
            Get.dialog(
              CustomAlertDialog(
                content: "Khoảng cách bạn quá xa so với địa điểm trả khách.",
                buttonText: "Đóng",
                onPressed: () {
                  Get.back();
                },
              ),
            );
            return; // Exit the function updateBookingStatus
          }
          break;

        default:
          break;
      }

      EasyLoading.show(
          indicator: const CircularProgressIndicator(),
          maskType: EasyLoadingMaskType.clear,
          dismissOnTap: true);

      var response = await DriverAPI.responseBooking(
          bookingStatus: state.statusOfBooking.value,
          params: notificationBookingModel);
      EasyLoading.dismiss();

      state.appBookingData.value =
          state.appBookingData.value?.copyWith(bookingId: response.id);
      if (response.status != null && response.status!.isNotEmpty) {
        updateBookingStatus(response.status!.type);
      }

      await sendDriverLocationToBackend();
      await retrieveDirectionDetails();

      print(' response: $response');
    } catch (e) {
      print('Error in responseBooking: $e');
      // Xử lý lỗi tại đây, ví dụ: hiển thị thông báo lỗi cho người dùng
      Get.dialog(
        CustomAlertDialog(
          content: "Đã xảy ra lỗi khi xử lý yêu cầu. Vui lòng thử lại.",
          buttonText: "Đóng",
          onPressed: () {
            Get.back();
          },
        ),
      );
    } finally {
      EasyLoading.dismiss();
      isResponsedBooking.value = false;
    }
  }

  Future<void> cancelBooking() async {
    try {
      String cancelReason = selectedReason == 'Khác'
          ? otherReasonController.text
          : selectedReason ?? '';

      if (cancelReason.isEmpty) {
        Get.snackbar(
          'Lỗi',
          'Vui lòng chọn lý do hủy chuyến',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.errorRed,
          colorText: AppColors.whiteColor,
        );
        return;
      }
      EasyLoading.show(
          indicator: const CircularProgressIndicator(),
          maskType: EasyLoadingMaskType.clear,
          dismissOnTap: true);

      if (AppRoles.isDriver) {
        isResponsedBooking.value = true;
        await DriverAPI.cancelBooking(
          bookingId: state.appBookingData.value?.id,
          cancelReason: cancelReason,
          capturedImages: capturedImages,
        );
        isResponsedBooking.value = false;
        resetAppStatus();
      } else {
        isResponsedBooking.value = true;
        await CustomerAPI.cancelBooking(
          bookingId: state.appBookingData.value?.id,
          cancelReason: cancelReason,
        );
        isResponsedBooking.value = false;
        resetAppStatus();
        // Get.offAll(() => HomeCustomerPage());
        EasyLoading.dismiss();
        Get.back();
      }

      Get.back();
    } catch (e) {
      print('Error in cancelBooking: $e');
      // Xử lý lỗi tại đây, ví dụ: hiển thị thông báo lỗi cho người dùng
      Get.dialog(
        CustomAlertDialog(
          content: "Đã xảy ra lỗi khi hủy chuyến. Vui lòng thử lại.",
          buttonText: "Đóng",
          onPressed: () {
            Get.back();
          },
        ),
      );
    } finally {
      selectedReason = "";
      isResponsedBooking.value = false;
      EasyLoading.dismiss();
    }
  }

  Future<void> checkInAndOut() async {
    try {
      EasyLoading.show(
          indicator: const CircularProgressIndicator(),
          maskType: EasyLoadingMaskType.clear,
          dismissOnTap: true);

      BookingImage bookingImageRequest = BookingImage(
        bookingId: state.appBookingData.value?.id,
        bookingImageFile: state.imageFiles.last,
        bookingImageType: imageTypeMap[imageTypes[imageIndex.value]] ?? "",
      );
      await DriverAPI.checkInAndOut(
        params: bookingImageRequest,
        isCheckIn: isCheckInApi.value,
      );
      EasyLoading.dismiss();
    } catch (e) {
      print("Error to check in and out: " + e.toString());
    } finally {
      isResponsedBooking.value = false;
      EasyLoading.dismiss();
    }
  }

  Future<void> addNotes({required bool isCheckIn}) async {
    try {
      if (isCheckIn) {
        var response = await DriverAPI.addCheckInNote(
            bookingId: state.appBookingData.value?.id,
            checkInNote: notes.value ?? "");
        notes.value = "";
        print("${response.toString()}");
        clearTextFields();
      } else {
        var response = await DriverAPI.addCheckOutNote(
            bookingId: state.appBookingData.value?.id,
            checkOutNote: notes.value ?? "");
        notes.value = "";
        print("${response.toString()}");
        clearTextFields();
      }
    } catch (e) {
      print("Error Add Check In Note${e}");
    } finally {
      isResponsedBooking.value = false;
    }
  }

  void saveNotes() {
    String combinedNotes = "";
    for (int i = 0; i < noteTypes.length; i++) {
      if (controllers![i].text.isNotEmpty) {
        combinedNotes += "${noteTypes[i]}: ${controllers![i].text}\n";
      }
    }
    print("NOTES: ${combinedNotes}");
    notes.value = combinedNotes;
  }

  void clearTextFields() {
    for (var controller in controllers!) {
      controller.clear();
    }
  }

  void showCheckInOutNoteDialog() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true, // Cho phép cuộn trong ModalBottomSheet
      builder: (context) {
        return SingleChildScrollView(
          // Bọc nội dung trong SingleChildScrollView
          child: Padding(
            padding: EdgeInsets.only(
              bottom:
                  MediaQuery.of(context).viewInsets.bottom, // Thêm padding dưới
              left: 20.0.w,
              right: 20.0.w,
              top: 20.0.w,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Đặt kích thước tối thiểu
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 16.0.h),
                  child: Text(
                    "Nhập ghi chú",
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...List.generate(noteTypes.length, (index) {
                  return Padding(
                    padding: EdgeInsets.all(8.0.w),
                    child: TextField(
                      controller: controllers![index],
                      decoration: InputDecoration(
                        labelText: noteTypes[index],
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.clear,
                          ),
                          onPressed: () {
                            controllers![index].clear();
                          },
                        ),
                      ),
                      maxLength: 100,
                      maxLines: 2,
                    ),
                  );
                }),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          saveNotes();
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 15.h, horizontal: 20.h),
                          backgroundColor: AppColors.primaryElement,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                        ),
                        child: Text(
                          "Lưu",
                          style: TextStyle(
                              fontSize: 18.sp,
                              color: AppColors.textFieldColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> sendTrackingData(
      {required String customerId,
      required double latitude,
      required double longitude}) async {
    try {
      await SignalRService?.invoke(
          "TrackingDriverLocation", [customerId, latitude, longitude]);
      print(
          "Tracking data sent successfully. $customerId $latitude $longitude ");
    } catch (err) {
      print("Error sending tracking data: $err");
    }
  }

  Future<void> updateDriverLocationFromSocket(
      {required double newDriverLatitude,
      required double newDriverLongitude}) async {
    if (mapPageController.state.driverLocation.value != null) {
      mapPageController.state.driverLocation.value!.latitudePosition =
          newDriverLatitude;
      mapPageController.state.driverLocation.value!.longitudePosition =
          newDriverLongitude;
      print(
          "DRIVER LOCATION UPDATED: ${mapPageController.state.driverLocation.value!.latitudePosition} ${mapPageController.state.driverLocation.value!.longitudePosition}");
      await updatePolylineAllTrip();
    } else {
      return;
    }
  }

  String getStatusBookingDriver() {
    switch (state.statusOfBooking.value) {
      case BOOKING_STATUS.ACCEPT:
        return 'Đã tới';
      case BOOKING_STATUS.ARRIVED:
        return 'Checkin';
      case BOOKING_STATUS.CHECKIN:
        return 'Bắt đầu chuyến';
      case BOOKING_STATUS.ONGOING:
        return 'CheckOut';
      case BOOKING_STATUS.CHECKOUT:
        return 'Trả khách';
      case BOOKING_STATUS.COMPLETE:
        return 'Thanh Toán';
      default:
        return 'Unknown';
    }
  }

  Future<void> retrieveDirectionDetails() async {
    switch (state.statusOfBooking.value) {
      case BOOKING_STATUS.PENDING:
        if (!isDriver) {
          await mapPageController.retrieveMapDirectionDetails(
            pickUpLocation:
                mapPageController.state.pickUpLocation.value ?? AddressModel(),
            dropOffLocation:
                mapPageController.state.dropOffLocation.value ?? AddressModel(),
          );
        }
        break;
      case BOOKING_STATUS.SHOW_DRIVER:
        if (!isDriver) {
          await mapPageController.retrieveMapDirectionDetails(
            pickUpLocation:
                mapPageController.state.pickUpLocation.value ?? AddressModel(),
            dropOffLocation:
                mapPageController.state.dropOffLocation.value ?? AddressModel(),
          );
        }
        break;
      case BOOKING_STATUS.ACCEPT:
        if (isDriver) {
          await mapPageController.retrieveMapDirectionDetails(
            pickUpLocation: mapPageController.convertMyAddressDriver(),
            dropOffLocation: mapPageController.state.pickUpLocation.value,
          );
          // await mapPageController.updatePolyline(
          //     pickupLocation: mapPageController.convertMyAddressDriver()!,
          //     dropOffLocation: mapPageController.state.pickUpLocation.value!);
        } else {
          await mapPageController.retrieveMapDirectionDetails(
            pickUpLocation: mapPageController.state.pickUpLocation.value,
            dropOffLocation: mapPageController.state.driverLocation.value,
          );
          // SignalRService.listenEvent("TrackingDriverLocation",
          //     (arguments) async {
          //   if (arguments is List && arguments.isNotEmpty) {
          //     var locationData = arguments[0];
          //     if (locationData is Map<String, dynamic>) {
          //       double? driverLatitude = locationData['latitude'];
          //       double? driverLongitude = locationData['longitude'];
          //       if (driverLatitude != null && driverLongitude != null) {
          //         await updateDriverLocationFromSocket(
          //             newDriverLatitude: driverLatitude,
          //             newDriverLongitude: driverLongitude);
          //       }
          //     }
          //   }
          // });
        }

        break;

      case BOOKING_STATUS.ARRIVED:
        // print(
        //     'ARRIVED Location: ${mapPageController.convertMyAddressDriver().toString()}');
        // print(
        //     'ARRIVED Location: ${mapPageController.state.dropOffLocation.toString()}');
        //
        // await mapPageController.retrieveMapDirectionDetails(
        //   pickUpLocation: mapPageController.state.pickUpLocation.value,
        //   dropOffLocation: mapPageController.state.dropOffLocation.value,
        // );

        break;
      case BOOKING_STATUS.CHECKIN:
        break;
      case BOOKING_STATUS.ONGOING:
        if (!isDriver) {
          mapPageController.myLocationEnabled.value = false;
          await mapPageController.retrieveMapDirectionDetails(
            pickUpLocation: mapPageController.state.driverLocation.value,
            dropOffLocation: mapPageController.state.dropOffLocation.value,
          );
        } else {
          await mapPageController.retrieveMapDirectionDetails(
            pickUpLocation: mapPageController.convertMyAddressDriver(),
            dropOffLocation: mapPageController.state.dropOffLocation.value,
          );
        }

        break;
      case BOOKING_STATUS.CHECKOUT:
        if (!isDriver) {
          // mapPageController.myLocationEnabled.value = false;
          await mapPageController.retrieveMapDirectionDetails(
            pickUpLocation: mapPageController.state.driverLocation.value,
            dropOffLocation: mapPageController.state.dropOffLocation.value,
          );
        }
        break;
      default:
        break;
    }
  }

  Future<void> updatePolylineAllTrip() async {
    switch (state.statusOfBooking.value) {
      case BOOKING_STATUS.PENDING:
        break;
      case BOOKING_STATUS.SHOW_DRIVER:
        break;
      case BOOKING_STATUS.ACCEPT:
        if (isDriver) {
          await mapPageController.updatePolyline(
              pickupLocation: mapPageController.convertMyAddressDriver()!,
              dropOffLocation: mapPageController.state.pickUpLocation.value!);
        } else {
          print(
              "before updatePolyline pick ${mapPageController.state.pickUpLocation.value}");
          print(
              "after updatePolyline drop ${mapPageController.state.driverLocation.value}");
          await mapPageController.updatePolyline(
              pickupLocation: mapPageController.state.pickUpLocation.value!,
              dropOffLocation: mapPageController.state.driverLocation.value!);
        }

        break;

      case BOOKING_STATUS.ARRIVED:
        if (isDriver) {
          await mapPageController.updatePolyline(
              pickupLocation: mapPageController.convertMyAddressDriver()!,
              dropOffLocation: mapPageController.state.pickUpLocation.value!);
        } else {
          print(
              "before updatePolyline pick ${mapPageController.state.pickUpLocation.value}");
          print(
              "after updatePolyline drop ${mapPageController.state.driverLocation.value}");
          await mapPageController.updatePolyline(
              pickupLocation: mapPageController.state.pickUpLocation.value!,
              dropOffLocation: mapPageController.state.driverLocation.value!);
        }
        break;
      case BOOKING_STATUS.CHECKIN:
        if (isDriver) {
          await mapPageController.updatePolyline(
              pickupLocation: mapPageController.convertMyAddressDriver()!,
              dropOffLocation: mapPageController.state.pickUpLocation.value!);
        } else {
          print(
              "before updatePolyline pick ${mapPageController.state.pickUpLocation.value}");
          print(
              "after updatePolyline drop ${mapPageController.state.driverLocation.value}");
          await mapPageController.updatePolyline(
              pickupLocation: mapPageController.state.pickUpLocation.value!,
              dropOffLocation: mapPageController.state.driverLocation.value!);
        }
        break;
      case BOOKING_STATUS.ONGOING:
        if (!isDriver) {
          await mapPageController.updatePolyline(
              pickupLocation: mapPageController.state.driverLocation.value!,
              dropOffLocation: mapPageController.state.dropOffLocation.value!);
        } else {
          await mapPageController.updatePolyline(
              pickupLocation: mapPageController.convertMyAddressDriver()!,
              dropOffLocation: mapPageController.state.dropOffLocation.value!);
        }

        break;
      case BOOKING_STATUS.CHECKOUT:
        break;
      default:
        break;
    }
  }

  void resetAppStatus() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // state.appBookingData.value = NotificationBookingModel();
      // textSearchPickCl.clear();
      isFromTerminated = false;
      isNotCompleteBookingResult = false;
      textSearchDropOffCl.clear();

      mapPageController.resetMapStatus();
      updateBookingStatus(BOOKING_STATUS.PENDING);
      Get.find<MainController>().updateIsShowBottom(true);

      await mapPageController.controllerOfGoogleMap?.animateCamera(
        CameraUpdate.newCameraPosition(
          await CameraPosition(
            target: LatLng(
              mapPageController.state.currentLocation.value.latitude ?? 0.0,
              mapPageController.state.currentLocation.value.longitude ?? 0.0,
            ),
            zoom: 15,
          ),
        ),
      );
      mapPageController.myLocationEnabled.value = true;
    });
  }

  Future pickImageFromCamera(String bookingImageType) async {
    try {
      final xFile = await cameraController!.takePicture();

      File pickedFile = File(xFile.path);
      state.imageFiles.add(pickedFile);

      isCaptured.value = true;
      print("Image Index after pick ${imageIndex.value.toString()}");
    } catch (e) {
      print("Error to pickImageFromCamera ${e}");
    } finally {
      isResponsedBooking.value = false;
    }
  }

  Future<void> showPhoneBottomSheet(String phoneNumber) async {
    await showCupertinoModalPopup(
      context: Get.context!,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          // message: Text(
          //   phoneNumber,
          //   style: TextStyle(fontSize: 20.sp),
          // ),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Get.back();
                callPhoneNumber(phoneNumber);
              },
              child: Text(
                phoneNumber,
                style: TextStyle(
                  fontSize: 20.sp,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> requestEmergencyOfCustomer({
    required Emergency emergencyInfo,
  }) async {
    try {
      var response = await EmergencyAPI.requestEmergencyOfCustomer(
          emergencyInfo: emergencyInfo);
    } catch (e) {
      print("Error to request emergency");
    }
  }

  Future<void> requestEmergencyOfDriver({
    required Emergency emergencyInfo,
  }) async {
    try {
      var response = await EmergencyAPI.requestEmergencyOfDriver(
          emergencyInfo: emergencyInfo);
    } catch (e) {
      print("Error to request emergency");
    }
  }

  Future<void> showCustomerEmergencyActionsBottomSheet() async {
    showCupertinoModalPopup(
      context: Get.context!,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Khẩn cấp'),
        message: const Text('Vui lòng chọn hỗ trợ'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            /// This parameter indicates the action would be a default
            /// default behavior, turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () async {
              Emergency emergencyInfo = Emergency(
                  senderAddress: "",
                  booking: state.appBookingData.value,
                  emergencyType: EMERGENCY_TYPE.POLICE.type);
              await sendCustomerLocationToBackend();
              await requestEmergencyOfCustomer(
                emergencyInfo: emergencyInfo,
              );
              await callPhoneNumber("113");
            },
            child: const Text(
              'GỌI 113',
              style: TextStyle(color: AppColors.errorRed),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Get.dialog(CustomAlertDialog(
                buttonText: "Gửi",
                title: "Gửi khẩn cấp",
                onPressed: () async {
                  noteEmergency = emergencyNoteController.text;
                  senderAddress = mapPageController.state.currentAddress.value;
                  Emergency emergencyInfo = Emergency(
                      senderAddress: senderAddress,
                      booking: state.appBookingData.value,
                      note: noteEmergency,
                      emergencyType: EMERGENCY_TYPE.CALL.type);
                  await sendCustomerLocationToBackend();
                  await requestEmergencyOfCustomer(
                    emergencyInfo: emergencyInfo,
                  );
                  Get.back();
                  Get.back();
                },
                showTextField: true,
                backgroundColor: AppColors.errorRed,
                textController: emergencyNoteController,
              ));
            },
            child: const Text(
              'Hãy gọi cho tôi ngay',
              style: TextStyle(color: AppColors.primaryElement),
            ),
          ),
          CupertinoActionSheetAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as delete or exit and turns
            /// the action's text color to red.
            // isDestructiveAction: true,
            onPressed: () {
              Get.dialog(CustomAlertDialog(
                buttonText: "Gửi",
                title: "Gửi khẩn cấp",
                onPressed: () async {
                  print("Emergency Note ${emergencyNoteController.text}");
                  noteEmergency = emergencyNoteController.text;
                  senderAddress = mapPageController.state.currentAddress.value;
                  Emergency emergencyInfo = Emergency(
                      senderAddress: senderAddress,
                      booking: state.appBookingData.value,
                      note: noteEmergency,
                      emergencyType: EMERGENCY_TYPE.CHAT.type);
                  await sendCustomerLocationToBackend();
                  await requestEmergencyOfCustomer(
                    emergencyInfo: emergencyInfo,
                  );
                  Get.back();
                  Get.back();
                },
                showTextField: true,
                backgroundColor: AppColors.errorRed,
                textController: emergencyNoteController,
              ));
            },
            child: const Text(
              'Tôi cần được hỗ trợ',
              style: TextStyle(color: AppColors.primaryElement),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showDriverEmergencyActionsBottomSheet() async {
    showCupertinoModalPopup(
      context: Get.context!,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Khẩn cấp'),
        message: const Text('Vui lòng chọn hỗ trợ'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            /// This parameter indicates the action would be a default
            /// default behavior, turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () async {
              Emergency emergencyInfo = Emergency(
                  senderAddress: "",
                  booking: state.appBookingData.value,
                  emergencyType: EMERGENCY_TYPE.POLICE.type);
              await sendDriverLocationToBackend();
              await requestEmergencyOfDriver(
                emergencyInfo: emergencyInfo,
              );
              await callPhoneNumber("113");
            },
            child: const Text(
              'GỌI 113',
              style: TextStyle(color: AppColors.errorRed),
            ),
          ),
          CupertinoActionSheetAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as delete or exit and turns
            /// the action's text color to red.
            // isDestructiveAction: true,
            onPressed: () {
              Get.dialog(CustomAlertDialog(
                buttonText: "Gửi",
                title: "Gửi khẩn cấp",
                onPressed: () async {
                  print("Emergency Note ${emergencyNoteController.text}");
                  noteEmergency = emergencyNoteController.text;
                  senderAddress = mapPageController.state.currentAddress.value;
                  Emergency emergencyInfo = Emergency(
                      senderAddress: senderAddress,
                      booking: state.appBookingData.value,
                      note: noteEmergency,
                      emergencyType: EMERGENCY_TYPE.CALL.type);
                  await sendDriverLocationToBackend();
                  await requestEmergencyOfDriver(
                    emergencyInfo: emergencyInfo,
                  );
                  Get.back();
                  Get.back();
                },
                showTextField: true,
                backgroundColor: AppColors.errorRed,
                textController: emergencyNoteController,
              ));
            },
            child: const Text(
              'Gọi cho nhân viên hệ thống',
              style: TextStyle(color: AppColors.primaryElement),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> callPhoneNumber(String phoneNumber) async {
    final String url = 'tel:$phoneNumber';
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Không thể gọi số điện thoại: $phoneNumber';
      }
    } catch (e) {
      Get.dialog(
        AlertDialog(
          title: Text('Lỗi'),
          content: Text('Đã xảy ra lỗi khi gọi số điện thoại: $phoneNumber'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void onClose() async {
    if (cameraController != null && cameraController!.value.isInitialized) {
      cameraController?.dispose();
    }
    await SignalRService.disconnect();

    print("on close home controller");
    await InternetChecker.stopListening();
    cameraController?.dispose();
    if (isDriver) {
      await updateStatusDriver(isOnline: false);
    }
    await SignalRService.disconnect();

    await Global.removeFcmToken();
    await UserStore.to.clearStorage();

    // await InternetChecker.stopListening();
    super.onClose();
  }
}
