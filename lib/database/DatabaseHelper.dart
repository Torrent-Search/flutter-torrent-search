/*
 *     Copyright (C) 2020 by Tejas Patil <tejasvp25@gmail.com>
 *
 *     torrentsearch is free software: you can redistribute it and/or modify
 *     it under the terms of the GNU General Public License as published by
 *     the Free Software Foundation, either version 3 of the License, or
 *     (at your option) any later version.
 *
 *     torrentsearch is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *     GNU General Public License for more details.
 *
 *     You should have received a copy of the GNU General Public License
 *     along with torrentsearch.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:torrentsearch/network/model/TorrentInfo.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;
  String tableTorrentInfo = "torrent_info";
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

  String tableHistory = "history";
  String columnSearchHistory = "search";

  static Database _db;

  DatabaseHelper.internal();
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'torrent.db');

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

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

  Future<int> insert(
      {TorrentInfo torrentinfo = null, History history = null}) async {
    Database dbClient = await db;
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

  Future<List> queryAll(
      {bool torrentinfo = false, bool history = false}) async {
    Database dbClient = await db;
    var result;
    if (torrentinfo) {
      result = await dbClient.query(tableTorrentInfo);
    }
    if (history) {
      result = await dbClient.query(tableHistory);
    }
    return result.toList();
  }

  Future<int> getCount({bool torrentinfo = false, bool history = false}) async {
    Database dbClient = await db;
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

  Future<TorrentInfo> getTorrentInfo(String name) async {
    Database dbClient = await db;
    List<Map> result = await dbClient
        .query(tableTorrentInfo, where: '$columnName = ?', whereArgs: [name]);

    if (result.length > 0) {
      return TorrentInfo.fromMap(result.first);
    }
    return null;
  }

  Future<int> getHistoyCount(String name) async {
    Database dbClient = await db;
    List<Map> result = await dbClient.query(tableHistory,
        where: '$columnSearchHistory = ?', whereArgs: [name]);

    if (result.length > 0) {
      return result.length;
    }
    return 0;
  }

  Future<int> getTorrentInfoCount(String name) async {
    Database dbClient = await db;
    List<Map> result = await dbClient
        .query(tableTorrentInfo, where: '$columnName = ?', whereArgs: [name]);

    if (result.length > 0) {
      return result.length;
    }
    return 0;
  }

  Future<int> delete(String name,
      {bool torrentinfo = false, bool history = false}) async {
    Database dbClient = await db;
    int count = 0;
    if (torrentinfo) {
      count = await dbClient.delete(tableTorrentInfo,
          where: '$columnName = ?', whereArgs: [name]);
    }
    if (history) {
      count = await dbClient.delete(tableHistory,
          where: '$columnSearchHistory = ?', whereArgs: [name]);
    }
    return count;
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}

class History {
  String _searchHistory;
  History(String searchHistory) {
    this._searchHistory = searchHistory;
  }

  String get searchHistory => _searchHistory;
  Map<String, dynamic> toMap() => <String, dynamic>{
        'search': this.searchHistory,
      };
  factory History.fromMap(Map<String, dynamic> json) {
    return History(
      json['search'] as String,
    );
  }
}
