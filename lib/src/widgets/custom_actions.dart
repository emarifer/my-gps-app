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
          top: 100,
          right: 0,
          child: IconButton(
            onPressed: () {
              Provider.of<UIProvider>(context, listen: false)
                  .showRightControls = !showRightControls;
            },
            icon: showRightControls
                ? const Icon(Icons.arrow_forward_ios,
                    color: Color(0xff0000ff), size: 35)
                : const Icon(Icons.arrow_back_ios,
                    color: Color(0xff0000ff), size: 35),
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
          top: 100,
          left: 30,
          child: IconButton(
            onPressed: () {
              Provider.of<UIProvider>(context, listen: false).showLeftControls =
                  !showLeftControls;
            },
            icon: showLeftControls
                ? const Icon(Icons.arrow_back_ios,
                    color: Color(0xff0000ff), size: 35)
                : const Icon(Icons.arrow_forward_ios,
                    color: Color(0xff0000ff), size: 35),
          ),
        ),
        showLeftControls
            ? Positioned(
                bottom: 20,
                left: 35,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const <Widget>[
                    WriteGpx(),
                    SizedBox(height: 3),
                    CurrentWalkInfo(),
                    SizedBox(height: 3),
                    ResetPosition(),
                    SizedBox(height: 3),
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
