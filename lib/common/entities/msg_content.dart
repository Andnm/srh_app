class Msgcontent {
  final String? id;
  final String? messageFrom;
  final String? messageTo;
  final String? content;
  final String? type;
  late String? dateCreated;
  late String? dateUpdated;

  Msgcontent(
      {this.id,
      this.messageFrom,
      this.messageTo,
      this.content,
      this.type,
      this.dateCreated,
      this.dateUpdated});

  factory Msgcontent.fromJson(Map<String, dynamic> data) {
    var typeResult = "Text";
    switch (data['type'].toString()) {
      case "0":
        typeResult = "Message";
        break;
      case "1":
        typeResult = "Image";
        break;
      case "2":
        typeResult = "CallSuccess";
        break;
      case "3":
        typeResult = "CallMissed";
        break;
      default:
        typeResult = data['type'].toString();
    }
    return Msgcontent(
      id: data['id'],
      messageFrom: data['messageFrom'],
      messageTo: data['messageTo'],
      content: data['content'],
      type: typeResult,
      dateCreated: data['dateCreated'],
      dateUpdated: data['dateUpdated'],
    );
  }

  @override
  String toString() {
    return 'Msgcontent{id: $id, messageFrom: $messageFrom, messageTo: $messageTo, content: $content, type: $type, dateCreated: $dateCreated, dateUpdated: $dateUpdated}';
  }
}

class MessageQuery {
  String messageTo;
  int PageIndex;
  int PageSize;

  MessageQuery({
    required this.messageTo,
    required this.PageIndex,
    required this.PageSize,
  });

  Map<String, dynamic> toJson() => {
        "PageIndex": PageIndex,
        "PageSize": PageSize,
      };
}

class MessageSwagger {
  List<Msgcontent>? data;
  int? pageIndex;
  int? pageSize;
  int? pageSkip;
  int? totalPage;
  int? totalSize;

  MessageSwagger({
    this.data,
    this.pageIndex,
    this.pageSize,
    this.pageSkip,
    this.totalPage,
    this.totalSize,
  });

  MessageSwagger.fromJson(Map<String, dynamic> json) {
    pageIndex = json['pageIndex'];
    pageSize = json['pageSize'];
    pageSkip = json['pageSkip'];
    totalPage = json['totalPage'];
    totalSize = json['totalSize'];
    if (json['data'] != null) {
      data = <Msgcontent>[];
      json['data'].forEach((v) {
        data?.add(Msgcontent.fromJson(v));
      });
    }
  }
}

class MessageRequestEntity {
  String messageFrom;
  String messageTo;
  String content;
  String type;

  MessageRequestEntity({
    required this.messageFrom,
    required this.messageTo,
    required this.content,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
        "messageFrom": messageFrom,
        "messageTo": messageTo,
        "content": content,
        "type": type,
      };

  @override
  String toString() {
    return 'MessageRequestEntity{messageFrom: $messageFrom, messageTo: $messageTo, content: $content, type: $type}';
  }
}

class CallTokenRequestEntity {
  String? channelName;

  CallTokenRequestEntity({
    this.channelName,
  });

  Map<String, dynamic> toJson() => {
        "channelName": channelName,
      };
}

class CallRequestEntity {
  String? callType;
  String? messageTo;

  CallRequestEntity({
    this.callType,
    this.messageTo,
  });

  Map<String, dynamic> toJson() => {
        "callType": callType,
        "messageTo": messageTo,
      };
}

class ConversationInOut {
  String messageTo;

  ConversationInOut({
    required this.messageTo,
  });

  Map<String, dynamic> toJson() => {
        "messageTo": messageTo,
      };
}
