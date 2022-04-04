import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map/flutter_map.dart';

class GeolocatorProvider extends ChangeNotifier {
  CenterOnLocationUpdate? centerOnLocationUpdate;
  StreamController<double?>? centerCurrentLocationStreamController;

  bool onOffLocation = false;

  void startStopGps() {
    if (onOffLocation) {
      centerCurrentLocationStreamController!.close();
      centerCurrentLocationStreamController = null;
      onOffLocation = false;
    } else {
      centerCurrentLocationStreamController = StreamController<double?>();
      centerOnLocationUpdate = CenterOnLocationUpdate.always;
      onOffLocation = true;
      // Center the location marker on the map and zoom the map to level 18.
      // centerCurrentLocationStreamController?.add(18);
    }
    notifyListeners();
  }

  void onPositionChanged(MapPosition position, bool hasGesture) {
    if (hasGesture) {
      centerOnLocationUpdate = CenterOnLocationUpdate.never;
      notifyListeners();
    }
  }

  void moveMapToLocation() {
    if (onOffLocation) {
      centerOnLocationUpdate = CenterOnLocationUpdate.always;
      notifyListeners();
    }
  }
}
