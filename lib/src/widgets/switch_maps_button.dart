import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/map_data_provider.dart';

class SwitchMapsButton extends StatelessWidget {
  const SwitchMapsButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      tooltip: 'Alternar tipos de Mapas',
      child: const Icon(Icons.layers),
      onPressed: () => Provider.of<MapDataProvider>(context, listen: false)
          .switchMapsLayers(),
    );
  }
}
