class WaypointModel {
  int? id;
  String name;  
  double latitude;
  double longitude;
  double altitude;
  String date;

  WaypointModel({
    this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.date,
  });

  factory WaypointModel.fromJson(Map<String, dynamic> json) => WaypointModel(
        id: json["id"],
        name: json["name"],
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
        "name": name,
        "latitude": latitude,
        "longitude": longitude,
        "altitude": altitude,
        "date": date,
      };
}
