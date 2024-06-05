import 'package:flutter/material.dart';

class ServiceInfo extends StatelessWidget {
  const ServiceInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin dịch vụ'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(
                  'DỊCH VỤ TÀI XẾ XE Ô TÔ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tài xế sẽ dùng xe của khách hàng đưa khách hàng đến địa điểm theo yêu cầu.',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Chỉ áp dụng đối với 1 điểm đón và 1 điểm đến.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Giá dịch vụ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Giá dịch vụ = Giá mở cửa + [Giá mỗi km theo khung x Số km theo khung] + Chi phí chờ (Nếu có)',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    ListTile(
                      leading: Icon(Icons.circle, size: 8),
                      title: Text(
                        'Giá mở cửa (tối thiểu 3km đầu): 110.000 đồng',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.circle, size: 8),
                      title: Text(
                        'Giá mỗi km tiếp theo: 20.000 đồng/km',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Các chi phí thêm',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    ListTile(
                      leading: Icon(Icons.circle, size: 8),
                      title: Text(
                        'Giờ cao điểm (18:00-19:59): 10% tổng phí dịch vụ',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.circle, size: 8),
                      title: Text(
                        'Phụ phí ban đêm (22:00-5:59): 20% tổng phí dịch vụ',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.circle, size: 8),
                      title: Text(
                        'Phí thời tiết: 5% tổng phí dịch vụ',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.circle, size: 8),
                      title: Text(
                        'Phí Tài xế Luxury: 5% tổng phí dịch vụ',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.circle, size: 8),
                      title: Text(
                        'Phụ phí chờ đợi: 20.000/10 phút (tính từ lúc tài xế đến)',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lưu ý',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Giá trên chưa bao gồm cước phí cầu đường, phí gửi xe, phí phà, phí vào bến xe nếu có',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Với mỗi chuyến đi có phí dịch vụ là 30.000đ khoản phí dành cho Google map và phí công nghệ cung các dịch vụ tiện ích đi kèm',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
