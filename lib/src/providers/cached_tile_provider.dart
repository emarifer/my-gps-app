import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_map/flutter_map.dart';

class CachedTileProvider extends TileProvider {
  const CachedTileProvider();

  @override
  ImageProvider getImage(Coords<num> coords, TileLayerOptions options) {
    return CachedNetworkImageProvider(
      getTileUrl(coords, options),
      // cacheKey: 'maps',
      cacheManager: CacheManager(
        Config('maps', maxNrOfCacheObjects: 300),
      ),
      //Now you can set options that determine how the image gets cached via whichever plugin you use.
    );
  }
}
