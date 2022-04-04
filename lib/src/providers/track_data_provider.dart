import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:geojson/geojson.dart';
import 'package:latlong2/latlong.dart';

class TrackDataProvider extends ChangeNotifier {
  final MapController mapController = MapController();
  final markers = <Marker>[];
  final lines = <Polyline>[];

  GeoJsonLine? lineProvider;
  String? trackName;

  Future<void> processTrackData(String data) async {
    // final data = await rootBundle.loadString('assets/tracks.geojson');
    final geojson = GeoJson();
    geojson.processedLines.listen((GeoJsonLine line) {
      lines.add(
        Polyline(
          strokeWidth: 4.0,
          color: Colors.blue.shade700,
          points: line.geoSerie!.toLatLng(),
        ),
      );

      mapController.move(lines[0].points[0], 14);
      lineProvider = line;
      trackName = line.name;
      notifyListeners();
    });
    geojson.endSignal.listen((_) => geojson.dispose());
    unawaited(geojson.parse(data, verbose: true));
  }

  Future<void> processWaypointsData(String data) async {
    final geojson = GeoJson();
    geojson.processedPoints.listen((GeoJsonPoint point) {
      markers.add(
        Marker(
          point: LatLng(point.geoPoint.latitude, point.geoPoint.longitude),
          builder: (_) => Tooltip(
            message: point.geoPoint.name,
            child: const Icon(Icons.gps_fixed, color: Colors.red),
            showDuration: const Duration(seconds: 5),
          ),
        ),
      );
      notifyListeners();
    });
    geojson.endSignal.listen((_) => geojson.dispose());
    unawaited(geojson.parse(data, verbose: true));
  }

  Future<void> addTrackToMap() async {
    // Limpiamos los datos anteriores
    markers.clear();
    lines.clear();
    trackName = null;
    lineProvider = null;
    notifyListeners();

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['js'], // Solo geojson
    );
    // print(result?.files.single.path);
    if (result != null) {
      final File file = File(result.files.single.path!);
      String data = await file.readAsString();
      data = data.replaceAll('MultiLineString', 'LineString');
      data = data.replaceAll('[[[', '[[');
      data = data.replaceAll(']]]', ']]');
      // print(data);
      processWaypointsData(data);
      processTrackData(data);
    }
  }

  void removeDataTrack() {
    markers.clear();
    lines.clear();
    lineProvider = null;
    trackName = null;

    notifyListeners();
  }
}
