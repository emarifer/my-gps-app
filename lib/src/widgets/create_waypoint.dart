import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/providers.dart';

class CreateWaypoint extends StatelessWidget {
  const CreateWaypoint({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lines = Provider.of<TrackDataProvider>(context).lines;

    return FloatingActionButton.small(
      tooltip: 'Crear Waypoint',
      backgroundColor: Colors.teal.shade600,
      child: const Icon(Icons.place, color: Colors.white),
      onPressed: () {
        for (var line in lines) {
          if (line.color == Colors.redAccent) {
            _displayTextInputDialog(context);
            break;
          }
        }
      },
    );
  }

  _displayTextInputDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: const <Widget>[
                Icon(Icons.place),
                SizedBox(width: 5),
                Text(
                  'Crear Waypoint',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: TextField(
              onChanged: (value) {
                Provider.of<TrackDataProvider>(context, listen: false)
                    .waypointName = value;
              },
              // controller: _textFieldController,
              decoration:
                  const InputDecoration(hintText: 'Nombre del Waypoint'),
            ),
            actions: <Widget>[
              RawMaterialButton(
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.white),
                ),
                fillColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              RawMaterialButton(
                child: const Text(
                  'Crear',
                  style: TextStyle(color: Colors.white),
                ),
                fillColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onPressed: () async {
                  Provider.of<TrackDataProvider>(context, listen: false)
                      .addUserPoiToMap();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
