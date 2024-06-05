import 'package:cus_dbs_app/common/apis/customer_api.dart';
import 'package:cus_dbs_app/common/entities/booking.dart';
import 'package:cus_dbs_app/pages/main/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cus_dbs_app/common/widgets/divider_custom.dart';
import 'package:get/get.dart';

import '../entities/notification/notification_booking_request.dart';

class NewRatingDialog extends StatefulWidget {
  final String bookingId;

  const NewRatingDialog({Key? key, required this.bookingId}) : super(key: key);

  @override
  _RatingBarWidgetState createState() => _RatingBarWidgetState();
}

class _RatingBarWidgetState extends State<NewRatingDialog> {
  double _rating = 5;
  String _selectedOption = '';
  String commentValue = '';
  TextEditingController commentController = TextEditingController();
  HomeController get homeController => Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              "Đánh giá chuyến đi",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/avatarman.png",
                    width: 60,
                    height: 60,
                  ),
                ),
                SizedBox(
                  width: 700,
                  height: 15,
                ),
                Center(
                  child: RatingBar.builder(
                    initialRating: _rating,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemSize: 35,
                    itemPadding: EdgeInsets.symmetric(
                      horizontal: 6.0,
                    ),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber.shade800,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _selectedOption = '';
                        _rating = rating;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Divider(
                  thickness: 1,
                  color: Colors.grey.shade300,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      _getRatingImage(_rating),
                      width: 30,
                      height: 30,
                    ),
                    Text(
                      _getRatingText(_rating),
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                DividerCustom(),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        _rating == 5
                            ? 'Điều gì khiến bạn hài lòng về chuyến đi?'
                            : 'Điều gì khiến bạn KHÔNG hài lòng về chuyến đi?',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      _buildRatingOptionsList(_rating),

                      Text(
                        'Chia sẻ thêm',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Nhập chia sẻ của bạn",
                          labelStyle: TextStyle(fontSize: 12),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[500]!),
                          ),
                        ),
                        controller: commentController,
                        onChanged: (value) {
                          setState(() {
                            commentValue = commentController.text.trim();
                          });
                        },
                      ),

                      // button
                      SizedBox(
                        height: 30,
                      ),

                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _selectedOption.isNotEmpty ||
                                  commentController.text.isNotEmpty
                              ? () async {
                                  String bookingId = widget.bookingId;

                                  EasyLoading.show(
                                    indicator:
                                        const CircularProgressIndicator(),
                                    maskType: EasyLoadingMaskType.clear,
                                    dismissOnTap: true,
                                  );

                                  try {
                                    String comment = [
                                      if (_selectedOption.isNotEmpty)
                                        _selectedOption,
                                      if (commentValue.isNotEmpty) commentValue
                                    ].join(', ');

                                    BookingRating bookingRating = BookingRating(
                                      bookingId: bookingId,
                                      star: _rating.toInt(),
                                      comment: comment,
                                    );

                                    var bookingRatingResponse =
                                        await CustomerAPI.rateBooking(
                                      params: bookingRating,
                                    );

                                    print('bookingRatingResponse ' +
                                        bookingRatingResponse.toString());

                                    Get.back();
                                  } catch (e) {
                                    Get.snackbar(
                                      "Lỗi",
                                      'Chỉ được rating khi chuyến đi đã hoàn thành!',
                                      backgroundColor: Colors.white,
                                      colorText: Colors.red,
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
                                  } finally {
                                    EasyLoading.dismiss();
                                  }
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade400,
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17),
                            ),
                          ),
                          child: const Text(
                            "Gửi",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 3,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getRatingImage(double rating) {
    switch (rating.toInt()) {
      case 5:
        return "assets/icons/happiest.png";
      case 4:
        return "assets/icons/happier.png";
      case 3:
        return "assets/icons/normal.png";
      case 2:
        return "assets/icons/sadder.png";
      case 1:
        return "assets/icons/saddest.png";
      default:
        return "assets/icons/happiest.png";
    }
  }

  String _getRatingText(double rating) {
    switch (rating.toInt()) {
      case 5:
        return "Chuyến đi thật tuyệt vời";
      case 4:
        return "Chuyến đi khá tốt";
      case 3:
        return "Chuyến đi ổn";
      case 2:
        return "Chuyến đi tệ";
      case 1:
        return "Chuyến đi rất tệ";
      default:
        return "Không xác định";
    }
  }

  List<String> _optionsForRating(double rating) {
    switch (rating.toInt()) {
      case 5:
        return [
          'Tài xế thân thiện',
          'Giá cả hợp lý',
          'Dịch vụ chuyên nghiệp',
          'An toàn và tin cậy'
        ];
      case 4:
      case 3:
        return [
          'Tài xế không thạo đường',
          'Tài xế đến trễ',
          'Tài xế không liên hệ trước khi tới',
          'Lý do khác'
        ];
      case 2:
        return [
          'Tài xế trả khách không đúng địa điểm',
          'Tài xế cố tình kéo dài lộ trình',
          'Tài xế thiếu tập trung',
          'Tài xế lái xe không cẩn thận'
        ];
      case 1:
        return [
          'Thái độ tài xế không tốt',
          'Tài xế thiếu tập trung',
          'Tài xế trả khách không đúng địa điểm',
          'Tài xế lái xe không cẩn thận'
        ];
      default:
        return ['Lựa chọn khác'];
    }
  }

  Widget _buildRatingOptionsList(double rating) {
    List<String> options = _optionsForRating(rating);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: options.map((option) {
        bool isSelected = option == _selectedOption;
        return _buildOption(option, isSelected);
      }).toList(),
    );
  }

  Widget _buildOption(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOption = text;
        });
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue.shade400 : Colors.grey.shade100,
              border: Border.all(
                color: isSelected ? Colors.blue.shade400 : Colors.grey.shade300,
              ),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14.0,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
