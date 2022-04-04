import 'package:flutter/material.dart';

import '../../src/widgets/widgets.dart';

class CustomActions extends StatelessWidget {
  const CustomActions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: const <Widget>[
        ShowInfoButton(),
        SizedBox(height: 3),
        SwitchMapsButton(),
        SizedBox(height: 3),
        ClearDataButton(),
        SizedBox(height: 3),
        AddTrackButton(),
        SizedBox(height: 3),
        StartStopLocationButton(),
        SizedBox(height: 15),
      ],
    );
  }
}
