import 'dart:math';

import 'package:geojson/geojson.dart';
import 'package:latlong2/latlong.dart';

class Utils {
  static String? calculateDistance(GeoJsonLine? lineProvider) {
    if (lineProvider != null) {
      const Distance distance = Distance();
      double totalDistanceInKm = 0;
      List<LatLng> trackPoints = [];
      trackPoints.addAll(lineProvider.geoSerie!.toLatLng());

      for (int i = 0; i < trackPoints.length - 1; i++) {
        totalDistanceInKm += distance(trackPoints[i], trackPoints[i + 1]);
      }
      return '${(totalDistanceInKm / 1000).toStringAsFixed(2)} km';
    }
    return null;
  }

  static String? maxElevation(GeoJsonLine? lineProvider) {
    if (lineProvider != null) {
      final List<dynamic> geopoints = [];
      List<double> altitudes = [];
      geopoints.addAll(lineProvider.geoSerie!.geoPoints);

      for (var gp in geopoints) {
        altitudes.add(gp.altitude);
      }
      return '${altitudes.reduce(max)} m';
    }
    return null;
  }
}
