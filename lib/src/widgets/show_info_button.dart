import 'package:flutter/material.dart';

import 'package:geojson/geojson.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';
import '../utils/utils.dart';

class ShowInfoButton extends StatelessWidget {
  const ShowInfoButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      tooltip: 'Mostrar Datos',
      backgroundColor: Colors.grey.shade700,
      child: Icon(Icons.info_outline, color: Colors.amberAccent.shade700),
      onPressed: () {
        showDialog(context: context, builder: _buildAlertDialog);
      },
    );
  }

  Widget _buildAlertDialog(BuildContext context) {
    final TrackDataProvider trackDataProvider =
        Provider.of<TrackDataProvider>(context);
    GeoJsonLine? lineProvider = trackDataProvider.lineProvider;
    String? trackName = trackDataProvider.trackName;

    final String? pathLength = Utils.calculateDistance(lineProvider);
    final String? altitude = Utils.maxElevation(lineProvider);

    return AlertDialog(
      title: Row(
        children: const <Widget>[
          Icon(Icons.info),
          SizedBox(width: 5),
          Text('Info Track'),
        ],
      ),
      content: SizedBox(
        height: trackName != null && trackName.length > 35 ? 150 : 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Nombre: ${trackName ?? "No hay track cargado"}'),
            const SizedBox(height: 5),
            Text('• Distancia: ${pathLength ?? "No hay track cargado"}'),
            const SizedBox(height: 5),
            Text('• Máx. Elevación: ${altitude ?? "No hay track cargado"}'),
          ],
        ),
      ),
      actions: <Widget>[
        RawMaterialButton(
          child: const Text('Aceptar', style: TextStyle(color: Colors.white)),
          fillColor: Colors.blue,
          onPressed: () async {
            // await CacheManager(Config('maps')).emptyCache();
            Navigator.of(context).pop();
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ],
    );
  }
}
