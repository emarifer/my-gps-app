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
    final double sizeBoxHeight = MediaQuery.of(context).size.height * 0.075;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: sizeBoxHeight),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Provider.of<UIProvider>(context, listen: false)
                      .showLeftControls = !showLeftControls;
                },
                icon: showLeftControls
                    ? const Icon(Icons.arrow_back_ios,
                        color: Color(0xff0000ff), size: 35)
                    : const Icon(Icons.arrow_forward_ios,
                        color: Color(0xff0000ff), size: 35),
              ),
              SizedBox(height: sizeBoxHeight * 3.5),
              showLeftControls
                  ? Column(
                      children: const <Widget>[
                        CreateWaypoint(),
                        SizedBox(height: 3),
                        WriteGpx(),
                        SizedBox(height: 3),
                        CurrentWalkInfo(),
                        SizedBox(height: 3),
                        ResetPosition(),
                        SizedBox(height: 3),
                        StartStopTrackRecord(),
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
          Column(
            children: <Widget>[
              IconButton(
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
              SizedBox(height: sizeBoxHeight * 3.5),
              showRightControls
                  ? Column(
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
                    )
                  : const SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}

/**
 * Flutter: alinear dos elementos en los extremos: uno a la izquierda y otro a la derecha. VER:
 * https://stackoverflow.com/questions/50365770/flutter-align-two-items-on-extremes-one-on-the-left-and-one-on-the-right
 */
