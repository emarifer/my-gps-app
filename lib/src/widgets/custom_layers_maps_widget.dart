import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';

class CustomLayersMapsWidget extends StatelessWidget {
  const CustomLayersMapsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MapDataProvider mapDataProvider =
        Provider.of<MapDataProvider>(context);

    return TileLayerWidget(
      options: TileLayerOptions(
        urlTemplate: mapDataProvider.urlTemplate,
        subdomains: ['a', 'b', 'c'],
        attributionBuilder: (_) => Padding(
          padding: const EdgeInsets.only(right: 10, bottom: 5),
          child: Text(mapDataProvider.attribution),
        ),
        tileProvider: const CachedTileProvider(),
      ),
    );
  }
}
