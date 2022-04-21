import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:background_location/background_location.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gpx/gpx.dart';
import 'package:latlong2/latlong.dart';

import '../models/track_model.dart';
import 'providers.dart';

class TrackDataProvider extends ChangeNotifier {
  final MapController mapController = MapController();
  final lines = <Polyline>[];
  final markers = <Marker>[];

  String trackName = '';
  final List<LatLng> lineProvider = [];
  final List<double?> elevations = [];
  final List<DateTime?> times = [];

  bool onOffTrackRecord = false;

  String _fileTrackName = '';

  String get fileTrackName => _fileTrackName;

  set fileTrackName(String value) {
    _fileTrackName = value.replaceAll(' ', '-');

    if (_fileTrackName.isEmpty) {
      _fileTrackName = DateTime.now().toString().replaceAll(' ', '-');
      _fileTrackName = _fileTrackName.replaceAll(':', '-');
      _fileTrackName = _fileTrackName.split('.')[0];
    }

    notifyListeners();
  }

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
        mapController.move(lineProvider[0], 18);
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
    List<Location> trackSegments = [];

    if (onOffTrackRecord) {
      BackgroundLocation.stopLocationService();
      trackSegments.clear();
      onOffTrackRecord = false;
      notifyListeners();
    } else {
      await BackgroundLocation.setAndroidNotification(
        title: 'Sevicio de adquisición de Track iniciando…',
        message: 'Grabrando Track…',
        icon: '@mipmap/ic_launcher',
      );

      await BackgroundLocation.startLocationService(distanceFilter: 2);

      BackgroundLocation.getLocationUpdates((location) {
        trackSegments.add(location);

        trackSegments = [..._removeDuplicates(trackSegments)];

        _addPointToDB(trackSegments.last);

        List<LatLng> line = [];
        for (var point in trackSegments) {
          line.add(LatLng(point.latitude!, point.longitude!));
        }

        lines.add(
          Polyline(
            strokeWidth: 4.0,
            color: Colors.redAccent,
            points: [...line],
          ),
        );
        if (lines.length >= 2) {
          lines.removeAt(lines.length - 2);
        }
        line.clear();

        notifyListeners();

        markers.add(
          Marker(
            point: lines.last.points.last,
            builder: (_) =>
                const Icon(Icons.navigation, color: Color(0xff0000ff)),
          ),
        );
        if (markers.length >= 2) {
          markers.removeAt(markers.length - 2);
        }

        notifyListeners();
      });

      onOffTrackRecord = true;
    }
  }

  void resetPosition() {
    if (lines.isNotEmpty && lines.last.points.isNotEmpty) {
      mapController.move(lines.last.points.last, 18);
      notifyListeners();
    }
  }

  loadTrack() async {
    final List<TrackModel> track = await DBProvider.db.getTrackFromDB();

    if (track.isNotEmpty) {
      List<LatLng> points = [];

      for (var point in track) {
        points.add(LatLng(point.latitude, point.longitude));
      }

      lines.add(
        Polyline(
          strokeWidth: 4.0,
          color: Colors.blue.shade700,
          points: [...points],
        ),
      );
      notifyListeners();
      points.clear();
    }
  }

  void writeGpx() async {
    final List<TrackModel> track = await DBProvider.db.getTrackFromDB();

    if (track.isNotEmpty) {
      List<Wpt> wpts = [];

      for (var point in track) {
        wpts.add(Wpt(
          lat: point.latitude,
          lon: point.longitude,
          ele: point.altitude,
          time: DateTime.parse(point.date),
        ));
      }

      final Gpx gpx = Gpx()
        ..creator = 'my_gps_app'
        ..metadata = Metadata(name: _fileTrackName, time: DateTime.now())
        ..trks = [
          Trk(trksegs: [Trkseg(trkpts: wpts)])
        ];

      final String gpxString = GpxWriter().asString(gpx, pretty: true);

      final dir = Directory('/storage/emulated/0/MyTracks');

      if (!dir.existsSync()) {
        await dir.create();
      }

      // print(_fileTrackName);

      final File file = File(dir.path + '/$_fileTrackName.gpx');
      await file.writeAsString(gpxString);

      // Borrar puntos del Track en la DB
      await DBProvider.db.deleteTrack();
    }
  }

  void _addPointToDB(Location location) async {
    final newPoint = TrackModel(
      latitude: location.latitude!,
      longitude: location.longitude!,
      altitude: location.altitude!,
      date: DateTime.now().toString(),
    );

    await DBProvider.db.newTrackPoint(newPoint);
  }

  List<Location> _removeDuplicates(List<Location> values) {
    // List<Location> noRepeats = [];

    // for (int i = 0; i < value.length; i++) {
    //   if (i < value.length - 1) {
    //     if (value[i].latitude != value[i + 1].latitude) {
    //       noRepeats.add(value[i]);
    //     }
    //   } else {
    //     noRepeats.add(value[i]);
    //   }
    // }

    if (values.length >= 2) {
      if (values[values.length - 2].latitude == values.last.latitude) {
        values.removeLast();
      }
    }
    return values;
  }
}

/**
 * how to save files and create folders in ‘storage/emulated/0/. VER:
 * https://aimensayoud.medium.com/how-to-save-files-and-create-folders-in-storage-emulated-0-in-android-flutter-2-2-2acefc4a578b
 * 
 * Uso del permiso de almacenamiento en Flutter. VER: 
 * https://mukhtharcm.com/storage-permission-in-flutter/
 * 
 * How To Create Folder in Local Storage/External Flutter? VER:
 * https://stackoverflow.com/questions/59093733/how-to-create-folder-in-local-storage-external-flutter
 * 
 * How to remove duplicates from list of objects in flutter. VER:
 * https://stackoverflow.com/questions/70132374/how-to-remove-duplicates-from-list-of-objects-in-flutter
 * 
 */
