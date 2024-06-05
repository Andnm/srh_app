bool isExpiredToken(String dateString, int expires_in) {
  // ignore: unnecessary_null_comparison
  if (dateString.isEmpty || expires_in == -1) {
    return false;
  }
  var time = DateTime.parse(dateString);
  if (time.add(Duration(minutes: expires_in)).compareTo(DateTime.now()) > 0) {
    return true;
  } else {
    return false;
  }
}
