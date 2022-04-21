import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';

class WriteGpx extends StatelessWidget {
  const WriteGpx({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      tooltip: 'Guardar archivo GPX',
      backgroundColor: Colors.yellowAccent.shade700,
      child: const Icon(Icons.save, color: Colors.black),
      onPressed: () async {
        await Permission.manageExternalStorage.request();
        _displayTextInputDialog(context);
      },
    );
  }

  _displayTextInputDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: IntrinsicHeight(
              child: Column(
                children: <Widget>[
                  Row(
                    children: const <Widget>[
                      Icon(Icons.save),
                      SizedBox(width: 5),
                      Text(
                        'Guardar Track',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '¡Debes de guardar este Track para no perderlo!',
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
            ),
            content: TextField(
              onChanged: (value) {
                Provider.of<TrackDataProvider>(context, listen: false)
                    .fileTrackName = value;
              },
              // controller: _textFieldController,
              decoration: const InputDecoration(hintText: 'Nombre del Track'),
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
                  'Guardar',
                  style: TextStyle(color: Colors.white),
                ),
                fillColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onPressed: () async {
                  Provider.of<TrackDataProvider>(context, listen: false).writeGpx();
                  _showConfirmation(context);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _showConfirmation(BuildContext context) {
    final snackBar = SnackBar(
        content: const Text('Track guardado en la carpeta MyTracks'),
        action: SnackBarAction(
          label: 'Ok',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
