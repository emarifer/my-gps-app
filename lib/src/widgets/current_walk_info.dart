import 'package:flutter/material.dart';

import 'package:latlong2/latlong.dart';

import '../models/track_model.dart';
import '../providers/providers.dart';
import '../utils/utils.dart';

class CurrentWalkInfo extends StatelessWidget {
  const CurrentWalkInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      tooltip: 'Información del Track grabado',
      backgroundColor: Colors.black,
      child: const Icon(Icons.directions_walk, color: Colors.white),
      onPressed: () async {
        final List<TrackModel> track = await DBProvider.db.getTrackFromDB();
        _showSnackBar(context, track);
      },
    );
  }

  _showSnackBar(BuildContext context, List<TrackModel> track) {
    if (track.isNotEmpty) {
      List<LatLng> points = [];
      List<DateTime?> times = [];
      final String altitude = '${track.last.altitude.toStringAsFixed(2)} m';

      for (var point in track) {
        points.add(LatLng(point.latitude, point.longitude));
      }

      for (var point in track) {
        times.add(DateTime.parse(point.date));
      }

      final String pathLength = Utils.calculateDistance(points) ?? '';
      final String duration = Utils.calculateDuration(times) ?? '';

      final snackBar = SnackBar(
        content: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '• Distancia recorrida: $pathLength',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 5),
              Text(
                '• Tiempo desde el inicio: $duration',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 5),
              Text(
                '• Altitud: $altitude',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        duration: const Duration(seconds: 10),
        action: SnackBarAction(
          label: 'Ok',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
