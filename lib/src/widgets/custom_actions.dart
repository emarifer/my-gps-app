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
    bool showLeftControls = Provider.of<UIProvider>(context).showLeftControls;

    return Stack(
      children: [
        Positioned(
          top: MediaQuery.of(context).size.height * 0.08,
          right: 0,
          child: ElevatedButton(
            onPressed: () {
              Provider.of<UIProvider>(context, listen: false)
                  .showRightControls = !showRightControls;
            },
            style:
                ElevatedButton.styleFrom(primary: Colors.indigoAccent.shade100),
            child: showRightControls
                ? const Icon(Icons.chevron_right)
                : const Icon(Icons.chevron_left),
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
        Positioned(
          top: MediaQuery.of(context).size.height * 0.08,
          left: 30,
          child: ElevatedButton(
            onPressed: () {
              Provider.of<UIProvider>(context, listen: false).showLeftControls =
                  !showLeftControls;
            },
            style:
                ElevatedButton.styleFrom(primary: Colors.indigoAccent.shade100),
            child: showLeftControls
                ? const Icon(Icons.chevron_left)
                : const Icon(Icons.chevron_right),
          ),
        ),
        showLeftControls
            ? Positioned(
                bottom: 20,
                left: 35,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const <Widget>[
                    StartStopTrackRecord(),
                  ],
                ),
              )
            : const Positioned(
                bottom: 5,
                left: 0,
                child: SizedBox(width: 0, height: 0),
              ),
      ],
    );
  }
}

/**
 * 
 */
