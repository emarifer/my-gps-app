import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:background_location/background_location.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gpx/gpx.dart';
import 'package:latlong2/latlong.dart';

import '../models/track_model.dart';
import '../models/waypoint_model.dart';
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

  String _waypointName = '';

  String get waypointName => _waypointName;

  set waypointName(String value) {
    _waypointName = value;

    if (_waypointName.isEmpty) {
      _waypointName = DateTime.now().toString();
    }

    notifyListeners();
  }

  Location? _lastLocation;

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
              message: '${wpt.name} (${wpt.ele?.toStringAsFixed(2)} m)',
              child: const Icon(Icons.gps_fixed, color: Colors.red),
              showDuration: const Duration(seconds: 5),
            ),
          ),
        );
      }
    }
  }

  Future<void> addTrackToMap() async {
    // Limpiamos los datos anteriores para que
    // la Info solo muestre los datos del track actual
    elevations.clear();
    lineProvider.clear();
    times.clear();
    trackName = '';


    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path!.contains('.gpx')) {
      final File file = File(result.files.single.path!);
      String data = await file.readAsString();
      // print(data);
      processTrackData(data);
      processWaypointsData(data);
      Future.delayed(const Duration(milliseconds: 300), () {
        mapController.move(lineProvider[0], 14);
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
      _lastLocation = null;
      notifyListeners();
    } else {
      await BackgroundLocation.setAndroidNotification(
        title: 'Sevicio de adquisición de Track iniciando…',
        message: 'Grabrando Track…',
        icon: '@mipmap/ic_launcher',
      );

      // Es necesario iniciar, detener y volver a arrancar el servicio
      // por que solo en el primer inicio duplica las localizaciones
      _stopAndRestartTheService();

      BackgroundLocation.getLocationUpdates((location) {
        trackSegments.add(location);

        _addPointToDB(trackSegments.last);
        _lastLocation = trackSegments.last;

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
        if (lines.length >= 2 &&
            lines[lines.length - 2].color == Colors.redAccent) {
          lines.removeAt(lines.length - 2);
        }
        line.clear();

        notifyListeners();

        markers.add(
          Marker(
            key: Key(DateTime.now().toString()),
            point: lines.last.points.last,
            builder: (_) =>
                const Icon(Icons.navigation, color: Color(0xff0000ff)),
          ),
        );
        // if (markers.length >= 2 && markers[markers.length - 2].key != null) {
        //   markers.removeAt(markers.length - 2);
        // }

        // Removemos el penúltimo cursor para actualizar la posición
        // pero no elinamos ninguno de los waypoints que el usuario
        // haya ingresado o que estén en otro track que también se esté renderizando
        _showOneCursor();

        notifyListeners();
      });

      onOffTrackRecord = true;
    }
  }

  Future<void> addUserPoiToMap() async {
    if (_lastLocation != null && lines.last.color == Colors.redAccent) {
      final LatLng point =
          LatLng(_lastLocation!.latitude!, _lastLocation!.longitude!);

      markers.insert(
        0,
        Marker(
          point: point,
          builder: (_) => Icon(Icons.stars, color: Colors.teal.shade600),
        ),
      );

      await _addWaypointToDB();

      notifyListeners();
    }
  }

  void resetPosition() {
    if (lines.isNotEmpty && lines.last.points.isNotEmpty) {
      mapController.move(lines.last.points.last, 14);
      notifyListeners();
    }
  }

  // loadTrack() async {
  //   final List<TrackModel> track = await DBProvider.db.getTrackFromDB();

  //   if (track.isNotEmpty) {
  //     List<LatLng> points = [];

  //     for (var point in track) {
  //       points.add(LatLng(point.latitude, point.longitude));
  //     }

  //     lines.add(
  //       Polyline(
  //         strokeWidth: 4.0,
  //         color: Colors.blue.shade700,
  //         points: [...points],
  //       ),
  //     );
  //     notifyListeners();
  //     points.clear();
  //   }
  // }

  void writeGpx() async {
    final List<TrackModel> track = await DBProvider.db.getTrackFromDB();
    final List<WaypointModel> waypointsList =
        await DBProvider.db.getWaypointsFromDB();

    if (track.isNotEmpty) {
      List<Wpt> wpts = [];
      List<Wpt> userPOI = [];

      for (var point in track) {
        wpts.add(Wpt(
          lat: point.latitude,
          lon: point.longitude,
          ele: point.altitude,
          time: DateTime.parse(point.date),
        ));
      }

      if (waypointsList.isNotEmpty) {
        for (var wpt in waypointsList) {
          userPOI.add(Wpt(
            name: wpt.name,
            lat: wpt.latitude,
            lon: wpt.longitude,
            ele: wpt.altitude,
            time: DateTime.parse(wpt.date),
          ));
        }
      }

      final Gpx gpx = Gpx()
        ..creator = 'my_gps_app'
        ..metadata = Metadata(name: _fileTrackName, time: DateTime.now())
        ..wpts = userPOI
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

      // Borrar waypoints en la DB
      await DBProvider.db.deleteWaypoints();

      // Limpiar fileTrackName
      _fileTrackName = '';
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

  Future<void> _addWaypointToDB() async {
    final newWaypoint = WaypointModel(
      name: _waypointName,
      latitude: _lastLocation!.latitude!,
      longitude: _lastLocation!.longitude!,
      altitude: _lastLocation!.altitude!,
      date: DateTime.now().toString(),
    );

    await DBProvider.db.newWaypoint(newWaypoint);
  }

  void _stopAndRestartTheService() async {
    await BackgroundLocation.startLocationService(distanceFilter: 10);

    Future.delayed(const Duration(milliseconds: 300), () {
      BackgroundLocation.stopLocationService();
    });

    Future.delayed(const Duration(milliseconds: 300), () async {
      await BackgroundLocation.startLocationService(distanceFilter: 10);
    });
  }

  void _showOneCursor() {
    if (markers.length >= 2) {
      Map<int, Marker> elements = markers.asMap();

      Map<int, Marker> cursors = {};
      elements.forEach((index, value) {
        if (value.key != null) {
          final cursor = <int, Marker>{index: value};
          cursors.addEntries(cursor.entries);
        }
      });

      List<int> cursorIndeces = cursors.keys.toList();
      if (cursorIndeces.length > 1) {
        cursorIndeces.sort();
        int minIndex = cursorIndeces[0];

        markers.removeAt(minIndex);
      }
    }
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
