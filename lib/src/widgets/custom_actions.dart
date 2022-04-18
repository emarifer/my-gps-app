import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/providers.dart';
import '../widgets/widgets.dart';

class CustomActions extends StatelessWidget {
  const CustomActions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool showRightControls = Provider.of<UIProvider>(context).showRightControls;

    return Stack(
      children: [
        Positioned(
          top: MediaQuery.of(context).size.height * 0.35,
          right: 0,
          child: GestureDetector(
            onTap: () {
              Provider.of<UIProvider>(context, listen: false)
                  .showRightControls = !showRightControls;
            },
            child: Container(
              width: 20,
              height: 40,
              color: Colors.indigoAccent.shade100,
              child: showRightControls
                  ? const Icon(Icons.chevron_right, size: 22)
                  : const Icon(Icons.chevron_left, size: 22),
            ),
          ),
        ),
        showRightControls
            ? Positioned(
                bottom: 10,
                right: 0,
                child: Column(
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
                  ],
                ),
              )
            : const Positioned(
                bottom: 5,
                right: 0,
                child: SizedBox(width: 0, height: 0),
              ),
      ],
    );
  }
}
