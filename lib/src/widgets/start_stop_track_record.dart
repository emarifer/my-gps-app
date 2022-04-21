import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../models/track_model.dart';
import '../providers/providers.dart';

class StartStopTrackRecord extends StatelessWidget {
  const StartStopTrackRecord({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool onOffTrackRecord =
        Provider.of<TrackDataProvider>(context).onOffTrackRecord;

    return FloatingActionButton.small(
      tooltip: 'Iniciar/Detener Grabación de Track',
      child: Icon(
        onOffTrackRecord
            ? Icons.radio_button_checked
            : Icons.radio_button_unchecked,
        color: Colors.white,
      ),
      backgroundColor: onOffTrackRecord
          ? Colors.orangeAccent.shade700
          : Colors.tealAccent.shade700,
      onPressed: () async {
        await Permission.locationAlways.request();
        await Permission.ignoreBatteryOptimizations.request();
        if (!onOffTrackRecord) {
          if (await _showWarning(context)) {
            Provider.of<TrackDataProvider>(context, listen: false)
                .startRecordingPosition();
          }
        } else {
          Provider.of<TrackDataProvider>(context, listen: false)
              .startRecordingPosition();
        }
      },
    );
  }

  Future<bool> _showWarning(BuildContext context) async {
    final List<TrackModel> track = await DBProvider.db.getTrackFromDB();

    if (track.isNotEmpty) {
      final snackBar = SnackBar(
        content: const Text('¡El Track de la base de datos debe ser guardado!'),
        action: SnackBarAction(
          label: 'Ok',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
    return true;
  }
}
