import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/providers.dart';

class ClearDataButton extends StatelessWidget {
  const ClearDataButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      tooltip: 'Eliminar Track',
      backgroundColor: Colors.deepOrange.shade900,
      child: const Icon(Icons.delete),
      onPressed: () => Provider.of<TrackDataProvider>(context, listen: false)
          .removeDataTrack(),
    );
  }
}
