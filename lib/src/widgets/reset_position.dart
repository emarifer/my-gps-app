import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/providers.dart';

class ResetPosition extends StatelessWidget {
  const ResetPosition({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      tooltip: 'Ir al último punto del Track',
      onPressed: () {
        Provider.of<TrackDataProvider>(context, listen: false).resetPosition();
      },
      child: const Icon(Icons.gps_not_fixed),
      backgroundColor: const Color(0xff0000ff),
    );
  }
}
