import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DocumentUploadGuidelinesIdentity extends StatelessWidget {
  final Function(BuildContext, String) showImagePickerOption;
  final String imageType;

  DocumentUploadGuidelinesIdentity({
    Key? key,
    required this.showImagePickerOption,
    required this.imageType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hướng dẫn tải ảnh lên',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              _buildSampleImages(),
              Center(
                child: Text(
                  'Ví dụ minh họa',
                  style: TextStyle(fontSize: 13),
                ),
              ),
              SizedBox(height: 20),
              _buildSectionTitle('Yêu cầu'),
              SizedBox(height: 10),
              _buildListItem(
                  'Còn hạn ít nhất 1 tháng', Icons.check, Colors.green),
              _buildListItem(
                  'Công dân Việt Nam từ 18 tới 60 tuổi (nam tối đa 60, nữ tối đa 55)',
                  Icons.check,
                  Colors.green),
              _buildListItem(
                  'Mặt trước CCCD là mặt có ảnh và thông tin cá nhân',
                  Icons.check,
                  Colors.green),
              _buildListItem(
                  'Mặt trước hộ chiếu là trang 2,3 có đầy đủ thông tin cá nhân và rõ dấu',
                  Icons.check,
                  Colors.green),
              SizedBox(height: 20),
              Divider(color: Colors.grey),
              SizedBox(height: 20),
              _buildSectionTitle('Điều nên tránh'),
              SizedBox(height: 10),
              _buildListItem('Giấy tờ chụp đầy đủ các thông tin, không mất góc',
                  Icons.close, Colors.red),
              _buildListItem('Hình ảnh không được chụp quá tầm mắt nhìn',
                  Icons.close, Colors.red),
              _buildListItem(
                  'Không chụp ảnh qua màn hình hoặc sử dụng giấy tờ scan. Ảnh chụp rõ nét, không lóa sáng, không can thiệp chỉnh sửa',
                  Icons.close,
                  Colors.red),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  showImagePickerOption(context, imageType);
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'Tải ảnh lên',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSampleImages() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Image.asset(
            'assets/images/identity_card_front.jpg',
            width: 200,
            height: 200,
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: Image.asset(
            'assets/images/identity_card_back.jpg',
            width: 200,
            height: 200,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _buildListItem(String text, IconData icon, Color iconColor) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: iconColor.withOpacity(0.1),
        ),
        child: Icon(
          icon,
          color: iconColor,
        ),
      ),
      title: Text(text),
    );
  }
}
