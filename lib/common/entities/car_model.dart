class BrandEntity {
  String? id;
  String? brandName;

  BrandEntity({this.id, this.brandName});

  BrandEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    brandName = json['brandName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['brandName'] = this.brandName;
    return data;
  }
}

class ModelEntity {
  String? id;
  String? modelName;

  ModelEntity({this.id, this.modelName});

  ModelEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    modelName = json['modelName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['modelName'] = this.modelName;
    return data;
  }
}