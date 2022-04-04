import 'package:flutter/material.dart';

import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';

class GeolocatorWidget extends StatelessWidget {
  const GeolocatorWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GeolocatorProvider geolocatorProvider =
        Provider.of<GeolocatorProvider>(context);

    return geolocatorProvider.onOffLocation
        ? LocationMarkerLayerWidget(
            plugin: LocationMarkerPlugin(
              centerCurrentLocationStream: geolocatorProvider
                  .centerCurrentLocationStreamController!.stream,
              centerOnLocationUpdate:
                  geolocatorProvider.centerOnLocationUpdate!,
            ),
          )
        : Container();
  }
}
