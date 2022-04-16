import 'package:latlong2/latlong.dart';

class Utils {
  static String? calculateDistance(List<LatLng> lineProvider) {
    if (lineProvider.isNotEmpty) {
      const Distance distance = Distance();
      double totalDistanceInKm = 0;

      for (int i = 0; i < lineProvider.length - 1; i++) {
        totalDistanceInKm += distance(lineProvider[i], lineProvider[i + 1]);
      }
      return '${(totalDistanceInKm / 1000).toStringAsFixed(2)} km';
    }
    return null;
  }

  static List<String>? maxElevation(List<double?> elevations) {
    if (elevations.isNotEmpty && elevations[0] != null) {
      elevations.sort();

      return ['${elevations.last} m', '${elevations.first} m'];
    }
    return null;
  }

  static String? calculateDuration(List<DateTime?> times) {
    if (times.isNotEmpty && times.last != null && times.first != null) {
      int minutes = times.last!.difference(times.first!).inMinutes;
      int hours = minutes ~/ 60;
      minutes = minutes - hours * 60;

      return '$hours horas y $minutes minutos';
    }
    return null;
  }
}
