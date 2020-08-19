import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:torrentsearch/features/torrent/domain/entities/torrent.dart';

// ignore_for_file: missing_whitespace_between_adjacent_strings

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  /// Table [torrent_info] Name
  String tableTorrentInfo = "torrent_info";

  ///Table [torrent_info] columns
  String columnName = "name";
  String columnUrl = "url";
  String columnSeeders = "seeders";
  String columnLeechers = "leechers";
  String columnUploadDate = "uploaddate";
  String columnSize = "size";
  String columnUploader = "uploader";
  String columnMagnet = "magnet";
  String columnWebsite = "website";
  String columnTorrentFile = "torrenfileurl";

  /// Table [history] Name
  String tableHistory = "history";

  /// Table [history] Column
  String columnSearchHistory = "search";

  static Database _db;

  StreamController streamController = StreamController<dynamic>.broadcast();

  DatabaseHelper.internal();
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    return initDb();
  }

  Future<Database> initDb() async {
    final String databasesPath = await getDatabasesPath();
    final String path = join(databasesPath, 'torrent.db');
    // ignore: unnecessary_await_in_return
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  /// OnCreate Callback method for [openDatabase]
  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $tableTorrentInfo($columnName TEXT UNIQUE, $columnUrl TEXT'
        ', $columnSeeders TEXT, $columnLeechers TEXT'
        ', $columnUploadDate TEXT, $columnSize TEXT'
        ', $columnUploader TEXT, $columnMagnet TEXT'
        ', $columnWebsite TEXT, $columnTorrentFile TEXT)');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $tableHistory($columnSearchHistory TEXT UNIQUE)');
  }

  /// Insert [Torrent] or [History] and Return lastInserted Column id
  Future<int> insert({Torrent torrentinfo, History history}) async {
    final Database dbClient = await db;
    int result = 0;
    if (torrentinfo != null) {
      result = await dbClient.insert(tableTorrentInfo, torrentinfo.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    if (history != null) {
      result = await dbClient.insert(tableHistory, history.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    return result;
  }

  /// Query all [Torrent] or [History] depending on Param
  /// and Add Result to Stream
  Future<void> queryAll(
      {bool torrentinfo = false, bool history = false}) async {
    final Database dbClient = await db;
    var result;
    if (torrentinfo) {
      result = await dbClient.query(tableTorrentInfo);
    }
    if (history) {
      result = await dbClient.query(tableHistory);
    }
    return streamController.sink.add(result);
  }

  Future<bool> isExist(String name,
      {bool torrentinfo = false, bool history = false}) async {
    final Database dbClient = await db;
    int count = 0;
    if (torrentinfo) {
      count = (await dbClient.query(tableTorrentInfo,
              where: '$columnName = ?', whereArgs: [name]))
          .length;
    }
    if (history) {
      count = (await dbClient.query(tableHistory,
              where: '$columnSearchHistory = ?', whereArgs: [name]))
          .length;
    }
    return count > 0;
  }

  /// Query all [Torrent] or [History] depending on Param and Return Count
  Future<int> getCount({bool torrentinfo = false, bool history = false}) async {
    final Database dbClient = await db;
    int count;
    if (torrentinfo) {
      count = Sqflite.firstIntValue(
          await dbClient.rawQuery('SELECT COUNT(*) FROM $tableTorrentInfo'));
    }
    if (history) {
      count = Sqflite.firstIntValue(
          await dbClient.rawQuery('SELECT COUNT(*) FROM $tableHistory'));
    }
    return count;
  }

  /// Return [Torrent] where [columnName] is @param[name]
  Future<Torrent> getTorrentInfo(String name) async {
    final Database dbClient = await db;
    final List<Map> result = await dbClient
        .query(tableTorrentInfo, where: '$columnName = ?', whereArgs: [name]);

    if (result.isNotEmpty) {
      return Torrent.fromMap(result.first as Map<String, dynamic>);
    }
    return null;
  }

  /// Return int where [columnSearchHistory] is @param[name] and return Count
  Future<int> getHistoyCount(String name) async {
    final Database dbClient = await db;
    final List<Map> result = await dbClient.query(tableHistory,
        where: '$columnSearchHistory = ?', whereArgs: [name]);

    if (result.isNotEmpty) {
      return result.length;
    }
    return 0;
  }

  /// Return int where [columnName] is @param[name] and return Count
  Future<int> getTorrentInfoCount(String name) async {
    final Database dbClient = await db;
    final List<Map> result = await dbClient
        .query(tableTorrentInfo, where: '$columnName = ?', whereArgs: [name]);

    if (result.isNotEmpty) {
      return result.length;
    }
    return 0;
  }

  Future<int> delete(String name,
      {bool torrentinfo = false, bool history = false}) async {
    final Database dbClient = await db;
    int count = 0;
    if (torrentinfo) {
      count = await dbClient.delete(tableTorrentInfo,
          where: '$columnName = ?', whereArgs: [name]);
      queryAll(torrentinfo: true);
    }
    if (history) {
      count = await dbClient.delete(tableHistory,
          where: '$columnSearchHistory = ?', whereArgs: [name]);
      queryAll(history: true);
    }
    return count;
  }

  Future<void> close() async {
    final Database dbClient = await db;
    streamController.close();
    return dbClient.close();
  }
}

class History {
  String _searchHistory;
  History(String searchHistory) {
    _searchHistory = searchHistory;
  }

  String get searchHistory => _searchHistory;
  Map<String, dynamic> toMap() => <String, dynamic>{
        'search': searchHistory,
      };
  factory History.fromMap(Map<String, dynamic> json) {
    return History(
      json['search'] as String,
    );
  }
}
