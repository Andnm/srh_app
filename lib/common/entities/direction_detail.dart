class DirectionDetails {
  String? distanceTextString;
  String? durationTextString;
  int? distanceValueDigits;
  int? durationValueDigits;
  String? encodedPoints;

  DirectionDetails({
    this.distanceTextString,
    this.durationTextString,
    this.distanceValueDigits,
    this.durationValueDigits,
    this.encodedPoints,
  });
  factory DirectionDetails.fromMap(Map<String, dynamic> dataMap) {
    return DirectionDetails(
      distanceTextString: dataMap['distanceTextString'],
      durationTextString: dataMap['durationTextString'],
      distanceValueDigits: dataMap['distanceValueDigits'],
      durationValueDigits: dataMap['durationValueDigits'],
      encodedPoints: dataMap['encodedPoints'],
    );
  }

  @override
  String toString() {
    return 'DirectionDetails{distanceTextString: $distanceTextString, durationTextString: $durationTextString, distanceValueDigits: $distanceValueDigits, durationValueDigits: $durationValueDigits, encodedPoints: $encodedPoints}';
  }
}
