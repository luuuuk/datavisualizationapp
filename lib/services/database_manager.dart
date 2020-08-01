import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:data_visualization_app/models/recorded_activity.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseManager {
  DatabaseManager._();

  static final DatabaseManager db = DatabaseManager._();
  static Database _database;

  DatabaseManager();

  Future<Database> get database async {
    //_database.isOpen ? print("database is open") : print("database is NOT open");

    if (_database != null) {
      return _database;
    }

    // if _database is null, instantiate it
    _database = await initDB();

    return _database;
  }

  initDB() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "asset_activity_database.db");

// Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "activity_database.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
    // open the database
    return await openDatabase(path);
  }

  /// Method to get all activities
  Future<List<RecordedActivity>> getActivities() async {
    var dbClient = await database;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM activities');
    List<RecordedActivity> activities = new List();
    for (int i = 0; i < list.length; i++) {
      activities.add(new RecordedActivity(list[i]["type"], list[i]["date"],
          list[i]["duration"], list[i]["distance"]));
    }
    return activities;
  }

  /// Save card
  Future<int> saveActivity(RecordedActivity activity) async {
    Database dbClient = await this.database;

    var result = await dbClient.insert("activities", activity.toMap());
    return result;
  }
}
