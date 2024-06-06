class User {
  String? id;
  String? name;
  String? phoneNumber;
  String? userName;
  String? email;
  String? address;
  num? star;
  String? avatar;
  String? gender;
  String? dob;
  bool? isPublicGender;
  bool? isActive;
  String? role;

  User({
    this.id,
    this.name = '',
    this.phoneNumber = '',
    this.userName = '',
    this.email = '',
    this.address = '',
    this.star = 0,
    this.avatar = '',
    this.gender = '',
    this.dob = '',
    this.isPublicGender = true,
    this.isActive = true,
    this.role = '',
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] ?? '';
    phoneNumber = json['phoneNumber'] ?? '';
    userName = json['userName'] ?? '';
    email = json['email'] ?? '';
    address = json['address'] ?? '';
    star:
    json['star'] ?? 0;
    avatar = json['avatar'] ?? '';
    gender = json['gender'] ?? '';
    dob = json['dob'] ?? '';
    isPublicGender = json['isPublicGender'] ?? true;
    isActive = json['isActive'] ?? true;
    role = json['role'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phoneNumber'] = this.phoneNumber;
    data['userName'] = this.userName;
    data['email'] = this.email;
    data['address'] = this.address;
    data['star'] = this.star;
    data['avatar'] = this.avatar;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['isPublicGender'] = this.isPublicGender;
    data['isActive'] = this.isActive;
    data['role'] = this.role;
    return data;
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, phoneNumber: $phoneNumber, userName: $userName, email: $email, address: $address, star: $star, avatar: $avatar, gender: $gender, dob: $dob, isPublicGender: $isPublicGender, isActive: $isActive, role: $role}';
  }
}
