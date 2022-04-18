import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';

class StartStopTrackRecord extends StatelessWidget {
  const StartStopTrackRecord({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool onOffTrackRecord =
        Provider.of<TrackDataProvider>(context).onOffTrackRecord;

    return GestureDetector(
      onDoubleTap: () {
        Provider.of<GeolocatorProvider>(context, listen: false)
            .moveMapToLocation();
      },
      child: FloatingActionButton.small(
        tooltip: 'Iniciar/Detener Grabación de Track',
        child: Icon(
          onOffTrackRecord
              ? Icons.radio_button_checked
              : Icons.radio_button_unchecked,
          color: Colors.white,
        ),
        backgroundColor: onOffTrackRecord
            ? Colors.tealAccent.shade700
            : Colors.amberAccent.shade700,
        onPressed: () async {
          await Permission.locationAlways.request();
          await Permission.ignoreBatteryOptimizations.request();
          Provider.of<TrackDataProvider>(context, listen: false)
              .startRecordingPosition();
          Provider.of<GeolocatorProvider>(context, listen: false)
              .startStopGps();
        },
      ),
    );
  }
}