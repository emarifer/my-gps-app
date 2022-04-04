import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';

class StartStopLocationButton extends StatelessWidget {
  const StartStopLocationButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool onOffLocation = Provider.of<GeolocatorProvider>(context).onOffLocation;

    return GestureDetector(
      onDoubleTap: () {
        Provider.of<GeolocatorProvider>(context, listen: false)
            .moveMapToLocation();
      },
      child: FloatingActionButton.small(
        tooltip: 'Iniciar/Detener GPS',
        child: const Icon(Icons.my_location),
        backgroundColor: onOffLocation ? Colors.pinkAccent : Colors.greenAccent,
        onPressed: () async {
          await Permission.locationWhenInUse.request();
          Provider.of<GeolocatorProvider>(context, listen: false)
              .startStopGps();
        },
      ),
    );
  }
}
