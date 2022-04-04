import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapDataProvider extends ChangeNotifier {
  final centerOfTheMap = LatLng(40.239748, -4.239292); // Centro de la Península
  final interactiveFlags = InteractiveFlag.pinchZoom |
      InteractiveFlag.drag |
      InteractiveFlag.flingAnimation;

  String urlTemplate =
      'https://www.ign.es/wmts/mapa-raster?request=getTile&layer=MTN&TileMatrixSet=GoogleMapsCompatible&TileMatrix={z}&TileCol={x}&TileRow={y}&format=image/jpeg';

  String attribution = 'MTN ráster CC BY 4.0 - ign.es';
  String _mapType = 'ign';

  void switchMapsLayers() {
    // Seleccion «circular» de opciones:
    if (_mapType == "ign") {
      _mapType = "pnoa";
      urlTemplate =
          'https://www.ign.es/wmts/pnoa-ma?service=WMTS&request=GetTile&version=1.0.0&layer=OI.OrthoimageCoverage&tilematrix={z}&tilematrixset=GoogleMapsCompatible&tilerow={y}&tilecol={x}&format=image/jpeg&style=default';
      attribution = 'Ortofoto PNOA CC-BY 4.0 - scne.es';
    } else if (_mapType == "pnoa") {
      _mapType = "osm";
      urlTemplate = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
      attribution = '© OpenStreetMap contributors';
    } else {
      _mapType = "ign";
      urlTemplate =
          'https://www.ign.es/wmts/mapa-raster?request=getTile&layer=MTN&TileMatrixSet=GoogleMapsCompatible&TileMatrix={z}&TileCol={x}&TileRow={y}&format=image/jpeg';
      attribution = 'MTN ráster CC BY 4.0 - ign.es';
    }
    notifyListeners();
  }
}
