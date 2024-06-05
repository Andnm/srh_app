enum BOOKING_STATUS {
  PENDING,
  SHOW_DRIVER,
  SEARCH_DRIVER,
  ACCEPT,
  ARRIVED,
  CHECKIN,
  ONGOING,
  CHECKOUT,
  COMPLETE,

  CANCEL,
  RATING
}

// extension BookingStatusName on BOOKING_STATUS {
//   String get name {
//     switch (this) {
//       case BOOKING_STATUS.PENDING:
//         return "Pending";
//       case BOOKING_STATUS.ACCEPT:
//         return "Accept";
//       case BOOKING_STATUS.ARRIVED:
//         return "Arrived";
//       case BOOKING_STATUS.ONGOING:
//         return "OnGoing";
//       case BOOKING_STATUS.COMPLETE:
//         return "Complete";
//       case BOOKING_STATUS.CANCEL:
//         return "Cancel";
//       default:
//         return '';
//     }
//   }
// }

extension BookingStatusType on String {
  BOOKING_STATUS get type {
    switch (this) {
      case "Pending":
        return BOOKING_STATUS.PENDING;
      case "Accept":
        return BOOKING_STATUS.ACCEPT;
      case "Arrived":
        return BOOKING_STATUS.ARRIVED;
      case "CheckIn":
        return BOOKING_STATUS.CHECKIN;
      case "OnGoing":
        return BOOKING_STATUS.ONGOING;
      case "CheckOut":
        return BOOKING_STATUS.CHECKOUT;
      case "Complete":
        return BOOKING_STATUS.COMPLETE;
      case "Cancel":
        return BOOKING_STATUS.CANCEL;
      default:
        return BOOKING_STATUS.PENDING;
    }
  }
}

enum DRIVER_STATUS { ONLINE, BUSY }

extension DriverStatusName on DRIVER_STATUS {
  bool get value {
    switch (this) {
      case DRIVER_STATUS.ONLINE:
        return true;
      case DRIVER_STATUS.BUSY:
        return false;
    }
  }
}

enum NOTIFICATION_STATUS {
  SEARCHREQUEST,
  BOOKING,
  WALLET_ADD_FUNDS,
  BOOKING_PAYMENT_SUCCESS,
  BOOKING_PAYMENT_FAILED
}

extension NotificationStatusName on NOTIFICATION_STATUS {
  String get name {
    switch (this) {
      case NOTIFICATION_STATUS.SEARCHREQUEST:
        return "SearchRequest";
      case NOTIFICATION_STATUS.BOOKING:
        return "Booking";
      case NOTIFICATION_STATUS.BOOKING_PAYMENT_SUCCESS:
        return "PaymentBookingSuccess";
      case NOTIFICATION_STATUS.BOOKING_PAYMENT_FAILED:
        return "PaymentBookingFail";
      case NOTIFICATION_STATUS.WALLET_ADD_FUNDS:
        return "WalletAddFunds";    
      default:
        return '';
    }
  }
}
