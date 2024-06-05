import 'package:cus_dbs_app/common/apis/customer_api.dart';
import 'package:cus_dbs_app/common/entities/booking.dart';
import 'package:cus_dbs_app/pages/main/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rating_dialog/rating_dialog.dart';

class RatingDialogWidget extends StatelessWidget {
  const RatingDialogWidget({super.key, required this.onPress});

  final VoidCallback onPress;
  HomeController get homeController => Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return RatingDialog(
      initialRating: 5,
      title: Text(
        'Đánh giá chuyến đi',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      message: Text(
        'Hãy chia sẻ cho chúng tôi nhiều ý kiến để có thể phát triển tốt hơn.',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 15),
      ),
      image: Image.asset('assets/icons/icon.png', width: 100, height: 100),
      submitButtonText: 'Gửi',
      commentHint: 'Nhập đánh giá của bạn',
      onCancelled: () {
        String customerName =
            homeController.state.appBookingData.value?.customer?.name ??
                'Quý khách';
        Get.snackbar(
          'Cảm ơn',
          'Cảm ơn $customerName đã sử dụng dịch vụ',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        homeController.resetAppStatus();
      },
      onSubmitted: (response) async {
        BookingRating bookingRating = BookingRating(
          bookingId: homeController.state.appBookingData.value?.id,
          star: response.rating.toInt(),
          comment: response.comment,
        );
        print('HE1 $bookingRating');
        var bookingRatingResponse =
            await CustomerAPI.rateBooking(params: bookingRating);
        print(bookingRatingResponse.toString());
        onPress();
      },
    );
  }
}
