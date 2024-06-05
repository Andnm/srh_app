enum MESSAGE_TYPE {
  MESSAGE,
  IMAGE,
  CALLSUCCESS,
  CALLMISSED,
}

extension EmergencyType on MESSAGE_TYPE {
  String get type {
    switch (this) {
      case MESSAGE_TYPE.MESSAGE:
        return "Message";
      case MESSAGE_TYPE.IMAGE:
        return "Image";
      case MESSAGE_TYPE.CALLSUCCESS:
        return "CallSuccess";
      case MESSAGE_TYPE.CALLMISSED:
        return "CallMissed";
      default:
        return '';
    }
  }
}
