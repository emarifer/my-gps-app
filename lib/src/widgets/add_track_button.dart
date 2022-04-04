import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/providers.dart';

class AddTrackButton extends StatelessWidget {
  const AddTrackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      tooltip: 'Agregar Tracks',
      backgroundColor: Colors.deepPurple,
      child: const Icon(Icons.attach_file),
      onPressed: () => Provider.of<TrackDataProvider>(context, listen: false)
          .addTrackToMap(),
    );
  }
}
