import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gpx/gpx.dart';
import 'package:latlong2/latlong.dart';
import 'package:background_location/background_location.dart';

class TrackDataProvider extends ChangeNotifier {
  final MapController mapController = MapController();
  final lines = <Polyline>[];
  final markers = <Marker>[];

  String trackName = '';
  final List<LatLng> lineProvider = [];
  final List<double?> elevations = [];
  final List<DateTime?> times = [];

  bool onOffTrackRecord = false;

  void processTrackData(String data) {
    final xmlGpx = GpxReader().fromString(data);
    trackName = xmlGpx.metadata?.name ?? '';

    final List<Trkseg> trksegs = xmlGpx.trks[0].trksegs;

    if (trksegs.isNotEmpty) {
      for (var trkseg in trksegs) {
        final List<LatLng> points = [];
        final List<Wpt> trkList = trkseg.trkpts;

        for (var trkp in trkList) {
          points.add(LatLng(trkp.lat!, trkp.lon!));
          elevations.add(trkp.ele);
          times.add(trkp.time);
        }

        // Hay que añadir la lista de punto sin referencia
        lines.add(
          Polyline(
            strokeWidth: 4.0,
            color: Colors.blue.shade700,
            points: [...points],
          ),
        );

        lineProvider.addAll([...points]);
        points.clear();
      }
    }
  }

  void processWaypointsData(String data) {
    final xmlGpx = GpxReader().fromString(data);
    // Lista de Waipoints del track
    List<Wpt> trkWpt = xmlGpx.wpts;
    // print(trkWpt);

    if (trkWpt.isNotEmpty) {
      for (var wpt in trkWpt) {
        markers.add(
          Marker(
            point: LatLng(wpt.lat!, wpt.lon!),
            builder: (_) => Tooltip(
              message: '${wpt.name} (${wpt.ele} m)',
              child: const Icon(Icons.gps_fixed, color: Colors.red),
              showDuration: const Duration(seconds: 5),
            ),
          ),
        );
      }
    }
  }

  Future<void> addTrackToMap() async {
    // Limpiamos los datos anteriores
    // removeDataTrack();

    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path!.contains('.gpx')) {
      final File file = File(result.files.single.path!);
      String data = await file.readAsString();
      // print(data);
      processTrackData(data);
      processWaypointsData(data);
      Future.delayed(const Duration(milliseconds: 300), () {
        mapController.move(lineProvider[0], 16);
      });
      notifyListeners();
    }
  }

  void removeDataTrack() {
    // Limpiamos ldatos
    elevations.clear();
    lineProvider.clear();
    lines.clear();
    markers.clear();
    times.clear();
    trackName = '';

    notifyListeners();
  }

  Future<void> startRecordingPosition() async {
    List<LatLng> trackSegment = [];
    List<LatLng> addPoints(Location location) {
      trackSegment.add(LatLng(location.latitude!, location.longitude!));

      notifyListeners();
      return trackSegment;
    }

    if (onOffTrackRecord) {
      BackgroundLocation.stopLocationService();
      trackSegment.clear();
      onOffTrackRecord = false;
      notifyListeners();
    } else {
      await BackgroundLocation.setAndroidNotification(
        title: 'Sevicio de adquisición de Track iniciando…',
        message: 'Grabrando Track…',
        icon: '@mipmap/ic_launcher',
      );

      await BackgroundLocation.startLocationService(distanceFilter: 5);

      BackgroundLocation.getLocationUpdates((location) {
        lines.add(
          Polyline(
            strokeWidth: 4.0,
            color: Colors.redAccent,
            points: addPoints(location),
          ),
        );
      });

      onOffTrackRecord = true;
      notifyListeners();
    }
  }
}
