class FcmTokenModel {
  String fcmToken;

  FcmTokenModel({
    required this.fcmToken,
  });

  Map<String, dynamic> toJson() => {
        "fcmToken": fcmToken,
      };
}
