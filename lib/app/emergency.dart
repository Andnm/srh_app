enum EMERGENCY_TYPE { CHAT, CALL, POLICE }

extension EmergencyType on EMERGENCY_TYPE {
  String get type {
    switch (this) {
      case EMERGENCY_TYPE.CHAT:
        return "Chat";
      case EMERGENCY_TYPE.CALL:
        return "Call";
      case EMERGENCY_TYPE.POLICE:
        return "Police";
      default:
        return '';
    }
  }
}

enum EMERGENCY_STATUS { PENDING, PROCESSING, SOLVED }

extension EmergencyStatus on EMERGENCY_STATUS {
  String get type {
    switch (this) {
      case EMERGENCY_STATUS.PENDING:
        return "Pending";
      case EMERGENCY_STATUS.PROCESSING:
        return "Processing";
      case EMERGENCY_STATUS.SOLVED:
        return "Solved";
      default:
        return '';
    }
  }
}
