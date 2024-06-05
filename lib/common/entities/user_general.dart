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

  User(
      {this.id,
      this.name,
      this.phoneNumber,
      this.userName,
      this.email,
      this.address,
      this.star,
      this.avatar,
      this.gender,
      this.dob,
      this.isPublicGender,
      this.isActive});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    userName = json['userName'];
    email = json['email'];
    address = json['address'];
    star:
    json['star'] ?? 0;
    avatar = json['avatar'];
    gender = json['gender'];
    dob = json['dob'];
    isPublicGender = json['isPublicGender'];
    isActive = json['isActive'];
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
    return data;
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, phoneNumber: $phoneNumber, userName: $userName, email: $email, address: $address, star: $star, avatar: $avatar, gender: $gender, dob: $dob, isPublicGender: $isPublicGender, isActive: $isActive}';
  }
}
