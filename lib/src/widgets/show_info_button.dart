import 'package:flutter/material.dart';

import 'package:latlong2/latlong.dart';
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
    const String noTrack = 'No hay track cargado';
    final TrackDataProvider trackDataProvider =
        Provider.of<TrackDataProvider>(context);
    List<LatLng> lineProvider = trackDataProvider.lineProvider;
    String trackName = trackDataProvider.trackName.isNotEmpty
        ? trackDataProvider.trackName
        : 'Sin nombre o $noTrack';
    List<double?> elevations = trackDataProvider.elevations;
    List<DateTime?> times = trackDataProvider.times;

    final String pathLength = Utils.calculateDistance(lineProvider) ?? noTrack;
    final List<String> altitude = Utils.maxElevation(elevations) ??
        [
          'Sin elevaciones o $noTrack',
          'Sin elevaciones o $noTrack',
        ];
    final String duration =
        Utils.calculateDuration(times) ?? 'Duración no disponible o $noTrack';

    return AlertDialog(
      title: Row(
        children: const <Widget>[
          Icon(Icons.info),
          SizedBox(width: 5),
          Text('Info Track'),
        ],
      ),
      // IntrinsicHeight le otorga a la columna la altura de su contenido
      content: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('• Nombre: $trackName'),
            const SizedBox(height: 5),
            Text('• Distancia: $pathLength'),
            const SizedBox(height: 5),
            Text('• Máx. Elevación: ${altitude[0]}'),
            const SizedBox(height: 5),
            Text('• Min. Elevación: ${altitude[1]}'),
            const SizedBox(height: 5),
            Text('• Duración aprox.: $duration'),
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
