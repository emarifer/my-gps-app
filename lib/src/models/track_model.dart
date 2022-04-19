class TrackModel {
  int? id;
  double latitude;
  double longitude;
  double altitude;
  String date;

  TrackModel({
    this.id,
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.date,
  });

  factory TrackModel.fromJson(Map<String, dynamic> json) => TrackModel(
        id: json["id"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        altitude: json["altitude"],
        date: json["date"],
      );

  @override
  String toString() {
    return toJson().toString();
  }

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "altitude": altitude,
        "date": date,
      };
}
