class AppRoles {
  static const customerRole = 'Customer'; // Use a constant string
  static const driverRole = 'Driver'; //
  static List<String>? roles = [];

  static bool get isRegister => (roles?.length ?? 0) > 0;
  static bool get isDriver => roles?[0] == driverRole;
}
