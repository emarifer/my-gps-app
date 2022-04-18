import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/screen/screen.dart';
import 'src/providers/providers.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <ChangeNotifierProvider<dynamic>>[
        ChangeNotifierProvider<MapDataProvider>(
          create: (context) => MapDataProvider(),
          lazy: false, // Hace que se cree el Provider al construir la app
        ),
        ChangeNotifierProvider<GeolocatorProvider>(
          create: (context) => GeolocatorProvider(),
        ),
        ChangeNotifierProvider<TrackDataProvider>(
          create: (context) => TrackDataProvider(),
          lazy: false, // Hace que se cree el Provider al construir la app
        ),
        ChangeNotifierProvider<UIProvider>(
          create: (context) => UIProvider(),
          lazy: false, // Hace que se cree el Provider al construir la app
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mi GPS App',
        home: FullScreenMap(),
      ),
    );
  }
}

/**
 * WARNINGS EN LA PLAY GOOGLE CONSOLE. VER:
 * https://stackoverflow.com/questions/62568757/playstore-error-app-bundle-contains-native-code-and-youve-not-uploaded-debug#69155101
 * https://github.com/flutter/flutter/issues/60240
 * 
 * DOCUMENTACION DE LA LIBRERIA DE DART «gpx»:
 * https://pub.dev/packages/gpx
 * 
 * CLONADO PROFUNDO DE MAPS, SETS Y LISTS SIN PASAR REFERENCIA EN DART:
 * https://stackoverflow.com/questions/21744480/clone-a-list-map-or-set-in-dart
 * 
 * ¿Cómo ejecutar el código después de un retraso en Flutter?:
 * https://stackoverflow.com/questions/49471063/how-to-run-code-after-some-delay-in-flutter
 * 
 * Finding Minimum and Maximum Value in a List:
 * https://www.geeksforgeeks.org/dart-finding-minimum-and-maximum-value-in-a-list/
 * 
 * HACER QUE UNA COLUMNA OCUPE SOLO LA ALTURA DE SU CONTENIDO:
 * https://stackoverflow.com/questions/66024678/how-to-fill-a-widget-to-the-full-available-row-height
 * 
 * How to Get Difference Between Two DateTime in Dart/Flutter:
 * https://www.fluttercampus.com/guide/168/how-to-get-difference-between-two-datetime-in-dart-flutter/
 * 
 */
