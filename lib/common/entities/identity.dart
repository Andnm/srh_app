import 'dart:io';

class IdentityCardInfo {
  String? id;
  String? identityCardNumber;
  String? fullName;
  String? dob;
  String? gender;
  String? nationality;
  String? placeOrigin;
  String? placeResidence;
  String? personalIdentification;
  String? expiredDate;

  IdentityCardInfo({
    this.id,
    this.identityCardNumber,
    this.fullName,
    this.dob,
    this.gender,
    this.nationality,
    this.placeOrigin,
    this.placeResidence,
    this.personalIdentification,
    this.expiredDate,
  });

  factory IdentityCardInfo.fromJson(Map<String, dynamic> json) =>
      IdentityCardInfo(
        id: json["id"] ?? "",
        identityCardNumber: json["identityCardNumber"] ?? "",
        fullName: json["fullName"] ?? "",
        dob: json['dob'] ?? "",
        gender: json["gender"] ?? "",
        nationality: json["nationality"] ?? "",
        placeOrigin: json["placeOrigin"] ?? "",
        placeResidence: json["placeResidence"] ?? "",
        personalIdentification: json["personalIdentification"] ?? "",
        expiredDate: json["expiredDate"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "identityCardNumber": identityCardNumber ?? null,
        "fullName": fullName ?? null,
        "dob": dob ?? null,
        "gender": gender ?? null,
        "nationality": nationality ?? null,
        "placeOrigin": placeOrigin ?? null,
        "placeResidence": placeResidence ?? null,
        "personalIdentification": personalIdentification ?? null,
        "expiredDate": expiredDate ?? null,
      };
  @override
  String toString() {
    return 'IdentityCardInfo{id: $id, identityCardNumber: $identityCardNumber, fullName: $fullName, dob: $dob, gender: $gender, nationality: $nationality, placeOrigin: $placeOrigin, placeResidence: $placeResidence, personalIdentification: $personalIdentification, expiredDate: $expiredDate}';
  }
}

class IdentityCardImage {
  String? identityCardId;
  String? id;
  String? imageUrl;
  bool? isFront;

  IdentityCardImage({
    this.identityCardId,
    this.id,
    this.imageUrl,
    this.isFront,
  });

  factory IdentityCardImage.fromJson(Map<String, dynamic> json) =>
      IdentityCardImage(
        identityCardId: json["identityCardId"] ?? "",
        id: json["id"] ?? "",
        imageUrl: json["imageUrl"] ?? "",
        isFront: json['isFront'] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "identityCardId": identityCardId,
        "id": id,
        "imageUrl": imageUrl,
        "isFront": isFront,
      };
}

class IdentityCardImageDownload {
  String? id;
  String? path;

  IdentityCardImageDownload({
    this.id,
    this.path,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "path": path,
      };
}
