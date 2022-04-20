import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/track_model.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();

  // Constructor privado
  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();

    return _database!;
  }

  Future<Database> initDB() async {
    // Path de almacenamiento de la DB
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'TrackDB.db');
    // print(path);

    // Creacion de la DB
    return openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE Track(
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            latitude REAL,
            longitude REAL,
            altitude REAL,
            date TEXT
          )
        ''');
      },
    );
  }

  Future<int> newTrackPoint(TrackModel point) async {
    final Database db = await database;

    final res = await db.insert('Track', point.toJson());

    // Retorna el ID del ultimo registro insertado en la DB
    return res;
  }

  Future<List<TrackModel>> getTrackFromDB() async {
    // Verificar la DB
    final Database db = await database;

    final res = await db.query('Track');

    return res.isNotEmpty
        ? res.map((p) => TrackModel.fromJson(p)).toList()
        : [];
  }

  Future<int> deleteTrack() async {
    // Verificar la DB
    final Database db = await database;

    final res = await db.rawDelete('''
      DELETE FROM Track
    ''');

    return res;
  }
}
