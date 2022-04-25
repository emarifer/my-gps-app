import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';

import '../../src/providers/providers.dart';
import '../scale_config/scale_config.dart';
import '../widgets/widgets.dart';

class FullScreenMap extends StatelessWidget {
  const FullScreenMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final MapDataProvider mapDataProvider =
        Provider.of<MapDataProvider>(context);
    final GeolocatorProvider geolocatorProvider =
        Provider.of<GeolocatorProvider>(context);
    final TrackDataProvider trackDataProvider =
        Provider.of<TrackDataProvider>(context);

    return Scaffold(
      body: FlutterMap(
        mapController: trackDataProvider.mapController,
        options: MapOptions(
          center: mapDataProvider.centerOfTheMap, // Centro de la Península
          zoom: 5.0,
          plugins: [ScaleLayerPlugin()],
          interactiveFlags: mapDataProvider.interactiveFlags,
          onPositionChanged: (MapPosition position, bool hasGesture) =>
              geolocatorProvider.onPositionChanged(position, hasGesture),
        ),
        nonRotatedLayers: [
          ScaleLayerPluginOption(
            lineColor: Colors.black,
            lineWidth: 2,
            textStyle: const TextStyle(color: Colors.black, fontSize: 12),
            padding: EdgeInsets.only(left: 10, top: screenHeight - 30),
          ),
        ],
        layers: <LayerOptions>[
          PolylineLayerOptions(polylines: trackDataProvider.lines),
          MarkerLayerOptions(markers: trackDataProvider.markers),
        ],
        children: const <Widget>[
          CustomLayersMapsWidget(),
          GeolocatorWidget(),
        ],
      ),
      floatingActionButton: const CustomActions(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
    );
  }
}

/**
 * Flutter - FloatingActionButton in the center. VER:
 * https://stackoverflow.com/questions/44713501/flutter-floatingactionbutton-in-the-center
 */
