class NotificationEntity {
  String? id;
  bool? seen;
  dynamic? action;
  String? title;
  String? body;
  dynamic? data;
  String? typeModel;
  String? dateCreated;
  String? dateUpdated;

  NotificationEntity(
      {this.id,
      this.seen,
      this.action,
      this.title,
      this.body,
      this.data,
      this.typeModel,
      this.dateCreated,
      this.dateUpdated});

  NotificationEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    seen = json['seen'];
    action = json['action'];
    title = json['title'];
    body = json['body'];
    data = json['data'];
    typeModel = json['typeModel'];
    dateCreated = json['dateCreated'];
    dateUpdated = json['dateUpdated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['seen'] = this.seen;
    data['action'] = this.action;
    data['title'] = this.title;
    data['body'] = this.body;
    data['data'] = this.data;
    data['typeModel'] = this.typeModel;
    data['dateCreated'] = this.dateCreated;
    data['dateUpdated'] = this.dateUpdated;
    return data;
  }
}