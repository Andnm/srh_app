enum PAYMENT_METHOD_STATUS { CASH, SECUREWALLET, MOMO, VNPAY }

extension NotificationStatusName on PAYMENT_METHOD_STATUS {
  String get name {
    switch (this) {
      case PAYMENT_METHOD_STATUS.CASH:
        return "Cash";
      case PAYMENT_METHOD_STATUS.SECUREWALLET:
        return "SecureWallet";
      case PAYMENT_METHOD_STATUS.MOMO:
        return "MoMo";
      case PAYMENT_METHOD_STATUS.VNPAY:
        return "VNPay";

      default:
        return 'SecureWallet';
    }
  }
}
