class Coordinates {
  double? latitude;
  double? longitude;

  Coordinates({double? latitude, double? longitude});

  @override
  String toString() {
    return 'Coordinates(latitude: $latitude, longitude: $longitude)';
  }
}
