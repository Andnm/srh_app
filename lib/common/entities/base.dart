class BaseResponseEntity {
  String? data;

  BaseResponseEntity({this.data});

  factory BaseResponseEntity.fromJson(Map<String, dynamic> json) =>
      BaseResponseEntity(
        data: json["data"],
      );
}
