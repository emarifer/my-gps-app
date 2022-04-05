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
 */
