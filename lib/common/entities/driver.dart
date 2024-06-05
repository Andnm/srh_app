import 'notification/notification_booking_request.dart';

class DriverItem {
  String? access_token;
  String? tokenType;
  String? userID;
  int? expiresIn;
  String? userName;
  String? email;
  String? password;
  String? phoneNumber;
  String? name;
  String? avatar;
  double? priority;
  String? dateLogin;
  num? star;
  List<String>? roles;

  DriverItem(
      {this.access_token,
      this.tokenType,
      this.userID,
      this.expiresIn,
      this.userName,
      this.email,
      this.password,
      this.phoneNumber,
      this.name,
      this.avatar,
      this.priority,
      this.dateLogin,
      this.star,
      this.roles});

  factory DriverItem.fromJson(Map<String, dynamic> json) => DriverItem(
      access_token: json["access_token"],
      tokenType: json["tokenType"],
      userID: json["userID"],
      expiresIn: json["expiresIn"],
      userName: json["userName"],
      email: json["email"] ?? '',
      phoneNumber: json["phoneNumber"],
      name: json['name'],
      avatar: json["avatar"],
      priority: json["priority"],
      dateLogin: json["dateLogin"],
      star: json["star"],
      roles: json['roles'] != null ? List<String>.from(json['roles']) : []);

  Map<String, dynamic> toJson() => {
        "access_token": access_token,
        "tokenType": tokenType,
        "userID": userID,
        "expiresIn": expiresIn,
        "userName": userName,
        "email": email,
        "password": password,
        "phoneNumber": phoneNumber,
        "name": name,
        "avatar": avatar,
        "dateLogin": dateLogin,
        "star": star,
        "priority": priority,
        "roles": roles,
      };

  @override
  String toString() {
    return 'DriverItem{access_token: $access_token, tokenType: $tokenType, userID: $userID, expiresIn: $expiresIn, userName: $userName, email: $email, password: $password, phoneNumber: $phoneNumber, name: $name, avatar: $avatar, priority: $priority, dateLogin: $dateLogin, star: $star, roles: $roles}';
  }
}

class DriverExternalLogin {
  String? provider;
  String? idToken;

  DriverExternalLogin({
    this.provider,
    this.idToken,
  });

  Map<String, dynamic> toJson() => {
        "provider": provider,
        "idToken": idToken,
      };
}

class DriverInternalLogin {
  String? email;
  String? password;

  DriverInternalLogin({
    this.email,
    this.password,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}

class OnlineNearByDriver {
  String? id;
  String? email;
  bool? isOnline;
  double? latitude;
  double? longitude;
  double? radius;
  bool? isFemaleDriver;
  OnlineNearByDriver(
      {this.id,
      this.email,
      this.isOnline,
      this.latitude,
      this.longitude,
      this.radius,
      this.isFemaleDriver});

  factory OnlineNearByDriver.fromJson(Map<String, dynamic> json) =>
      OnlineNearByDriver(
        id: json["id"],
        email: json["email"],
        isFemaleDriver: json["IsFemaleDriver"],
        isOnline: json["isOnline"],
        latitude: json["latitude"],
        longitude: json["longitude"],
      );
  Map<String, dynamic> toJson() => {
        "Radius": radius,
        "IsFemaleDriver": isFemaleDriver,
        "Latitude": latitude,
        "Longitude": longitude,
      };
  OnlineNearByDriver copyWith({
    String? id,
    String? email,
    bool? isOnline,
    double? latitude,
    double? longitude,
    double? radius,
    bool? isFemaleDriver,
  }) {
    return OnlineNearByDriver(
      id: id ?? this.id,
      email: email ?? this.email,
      isOnline: isOnline ?? this.isOnline,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radius: radius ?? this.radius,
      isFemaleDriver: isFemaleDriver ?? this.isFemaleDriver,
    );
  }

  @override
  String toString() {
    return 'OnlineNearByDriver{id: $id, email: $email, isOnline: $isOnline, latitude: $latitude, longitude: $longitude, isFemaleDriver: $isFemaleDriver}';
  }
}
