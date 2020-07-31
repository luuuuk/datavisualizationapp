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
    var dbDir = await getDatabasesPath();
    var dbPath = join(dbDir, "activity_database.db");

    ByteData data = await rootBundle.load("assets/activity_database.db");
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(dbPath).writeAsBytes(bytes);
    return await openDatabase(dbPath, version: 1,
        onCreate: (Database db, int version)  {
      print("------------------------ onCreate ------------------------");
    });
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
  void saveActivity(RecordedActivity activity) async {
    var dbClient = await database;

    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO activities(type, date, duration, distance) VALUES(' +
              '\'' +
              activity.activityType.toString() +
              '\'' +
              ',' +
              '\'' +
              activity.date.toString() +
              '\'' +
              ',' +
              '\'' +
              activity.duration.toString() +
              '\'' +
              ',' +
              '\'' +
              activity.distance.toString() +
              '\'' +
              ')');
    });
    return;
  }
}
