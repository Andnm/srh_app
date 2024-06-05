import 'package:cus_dbs_app/middlewares/router_auth.dart';
import 'package:cus_dbs_app/pages/auth/customer/otp_confirm/otp_customer_binding.dart';
import 'package:cus_dbs_app/pages/auth/customer/otp_confirm/otp_customer_view.dart';
import 'package:cus_dbs_app/pages/auth/customer/register/_widgets/create_profile_customer.dart';
import 'package:cus_dbs_app/pages/auth/customer/register/index.dart';
import 'package:cus_dbs_app/pages/auth/customer/signin/_widgets/create_info.dart';
import 'package:cus_dbs_app/pages/auth/customer/signin/sigin_customer_binding.dart';
import 'package:cus_dbs_app/pages/auth/customer/signin/sigin_customer_view.dart';
import 'package:cus_dbs_app/pages/auth/driver/signin/signin_driver_binding.dart';
import 'package:cus_dbs_app/pages/auth/driver/signin/signin_driver_view.dart';
import 'package:cus_dbs_app/pages/chat/chat_binding.dart';
import 'package:cus_dbs_app/pages/chat/chat_view.dart';
import 'package:cus_dbs_app/pages/choose_role/choose_role_binding.dart';
import 'package:cus_dbs_app/pages/choose_role/choose_role_view.dart';
import 'package:cus_dbs_app/pages/main/account/customer/update_identity_card/customer_update_identity_binding.dart';
import 'package:cus_dbs_app/pages/main/account/customer/update_identity_card/customer_update_identity_view.dart';
import 'package:cus_dbs_app/pages/main/account/customer/update_profile/customer_update_profile_binding.dart';
import 'package:cus_dbs_app/pages/main/account/customer/update_profile/customer_update_profile_view.dart';
import 'package:cus_dbs_app/pages/main/account/customer/vehicle/index.dart';
import 'package:cus_dbs_app/pages/main/account/driver/driving_license/index.dart';
import 'package:cus_dbs_app/pages/main/account/driver/identity_card/index.dart';
import 'package:cus_dbs_app/pages/main/account/driver/profile/index.dart';
import 'package:cus_dbs_app/pages/main/account/driver/statistics/index.dart';
import 'package:cus_dbs_app/pages/main/account/payment/_widgets/selected_method_payment.dart';
import 'package:cus_dbs_app/pages/main/account/payment/index.dart';
import 'package:cus_dbs_app/pages/main/account/wallet/index.dart';
import 'package:cus_dbs_app/pages/main/booking/for_other/booked_person_binding.dart';
import 'package:cus_dbs_app/pages/main/booking/for_other/booked_person_view.dart';
import 'package:cus_dbs_app/pages/main/booking_history/index.dart';
import 'package:cus_dbs_app/pages/main/home/home_binding.dart';
import 'package:cus_dbs_app/pages/main/home/home_view.dart';
import 'package:cus_dbs_app/pages/main/home/search/search_destination_page.dart';

import 'package:cus_dbs_app/pages/main/main/customer/main_customer_binding.dart';

import 'package:cus_dbs_app/pages/main/main/main_binding.dart';
import 'package:cus_dbs_app/pages/main/main/main_view.dart';
import 'package:cus_dbs_app/pages/main/notification/index.dart';
import 'package:cus_dbs_app/pages/main/notification/notification_page.dart';
import 'package:cus_dbs_app/pages/voicecall/index.dart';
import 'package:cus_dbs_app/pages/welcome/welcome_binding.dart';
import 'package:cus_dbs_app/pages/welcome/welcome_view.dart';
import 'package:cus_dbs_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/auth/driver/register/register_driver_binding.dart';
import '../pages/auth/driver/register/register_driver_view.dart';
import '../pages/main/account/driver/statistics/statistics_view.dart';
import '../pages/main/booking/index.dart';
import '../pages/main/booking_history/booking_history_page.dart';
import '../pages/main/home/search/search_binding.dart';

class AppPages {
  static final RouteObserver<Route> observer = RouteObserver();
  static List<String> history = [];

  static final List<GetPage> routes = [
    GetPage(
        name: AppRoutes.initial,
        page: () => const WelcomePage(),
        binding: WelcomeBinding()),
    GetPage(
        name: AppRoutes.chooseRole,
        page: () => const ChooseRole(),
        binding: ChooseRoleBinding()),
    GetPage(
      name: AppRoutes.driverSignIn,
      page: () => const DriverSignInPage(),
      binding: DriverSignInBinding(),
    ),
    GetPage(
      name: AppRoutes.driverRegister,
      page: () => const DriverRegisterPage(),
      binding: DriverRegisterBinding(),
    ),
    GetPage(
      name: AppRoutes.otpConfirm,
      page: () => const OtpConfirmPage(),
      binding: OtpConfirmBinding(),
    ),
    GetPage(
      name: AppRoutes.search,
      page: () => SearchDestinationPage(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: AppRoutes.chat,
      page: () => ChatScreen(),
      binding: ChatBinding(),
    ),
    GetPage(
        name: AppRoutes.main,
        page: () => const MainPage(),
        binding: MainBinding(),
        middlewares: [RouteAuthMiddleware(priority: 1)]),
    GetPage(
        name: AppRoutes.mainCustomer,
        page: () => const MainPage(),
        binding: MainCustomerBinding(),
        middlewares: [RouteAuthMiddleware(priority: 1)]),
    GetPage(
      name: AppRoutes.mapCustomer,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.customerSignIn,
      page: () => const CustomerSignInPage(),
      binding: CustomerSignInBinding(),
    ),
    GetPage(
      name: AppRoutes.customerRegister,
      page: () => CustomerRegisterPage(),
      binding: CustomerRegisterBinding(),
    ),
    GetPage(
      name: AppRoutes.updateCustomerProfile,
      page: () => CustomerUpdateProfilePage(),
      binding: CustomerUpdateProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.updateCustomerIdentityCard,
      page: () => CustomerUpdateIdentityPage(),
      binding: CustomerUpdateIdentityBinding(),
    ),
    GetPage(
      name: AppRoutes.viewVehicle,
      page: () => VehiclePage(),
      binding: VehicleBinding(),
    ),
    GetPage(
      name: AppRoutes.chooseVehicle,
      page: () => ChooseVehicleScreen(),
      binding: ChooseVehicleBinding(),
    ),
    GetPage(
      name: AppRoutes.bookedPersonInfor,
      page: () => BookedPersonInformationPage(),
      binding: BookedPersonBinding(),
    ),
    GetPage(
      name: AppRoutes.viewDriverProfile,
      page: () => DriverProfilePage(),
      binding: DriverProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.viewDriverIdentityCard,
      page: () => DriverIdentityPage(),
      binding: DriverIdentityBinding(),
    ),
    GetPage(
      name: AppRoutes.viewStatistics,
      page: () => StatisticsPage(),
      binding: StatisticsBinding(),
    ),
    GetPage(
      name: AppRoutes.viewDrivingLicense,
      page: () => DriverDlcPage(),
      binding: DriverDlcBinding(),
    ),
    GetPage(
      name: AppRoutes.createInfoAfterLoginWithPhoneNumber,
      page: () => CreateNewInfoCustomer(),
      binding: CustomerSignInBinding(),
    ),
    GetPage(
      name: AppRoutes.createInfoAfterLoginWithEmailPassword,
      page: () => CreateNewProfileCustomer(),
      binding: CustomerRegisterBinding(),
    ),
    GetPage(
      name: AppRoutes.viewBookingHistory,
      page: () => BookingHistoryPage(),
      binding: BookingHistoryBinding(),
    ),
    GetPage(
      name: AppRoutes.viewLinkedManagement,
      page: () => LinkedAccountPage(),
      binding: LinkedAccountBinding(),
    ),
    GetPage(
      name: AppRoutes.viewWallet,
      page: () => WalletPage(),
      binding: WalletBinding(),
    ),
    GetPage(
      name: AppRoutes.viewNotificationPage,
      page: () => NotificationPage(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: AppRoutes.VoiceCall,
      page: () => const VoicePage(),
      binding: VoiceBinding(),
    ),
    GetPage(
      name: AppRoutes.selectedPaymentMethodInBooking,
      page: () => SelectedMethodPayment(),
    ),
  ];
}
