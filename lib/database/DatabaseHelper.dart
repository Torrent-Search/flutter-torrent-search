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
import 'package:torrentsearch/network/Network.dart';

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
  String columnTypeHistory = "type";

  String tableSongs = "songs";
  String columnsongid = "id";
  String columnsong = "song";
  String columnImage = "image";
  String columnsongalbum = "album";
  String columnsongalbumid = "albumid";
  String columnsongMediaurl = "encrypted_media_url";
  String columnsongyear = "year";
  String columnsongdusration = "duration";
  String columnsongsingers = "singers";

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
    Database db = await openDatabase(path,
        version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
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
        'CREATE TABLE IF NOT EXISTS $tableHistory($columnSearchHistory TEXT UNIQUE,$columnTypeHistory TEXT)');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $tableSongs($columnsongid TEXT UNIQUE, $columnsong TEXT'
        ', $columnImage TEXT, $columnsongalbum TEXT'
        ', $columnsongalbumid TEXT, $columnsongMediaurl TEXT'
        ', $columnsongyear TEXT, $columnsongdusration TEXT'
        ', $columnsongsingers TEXT)');
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $tableSongs($columnsongid TEXT UNIQUE, $columnsong TEXT'
        ', $columnImage TEXT, $columnsongalbum TEXT'
        ', $columnsongalbumid TEXT, $columnsongMediaurl TEXT'
        ', $columnsongyear TEXT, $columnsongdusration TEXT'
        ', $columnsongsingers TEXT)');
    try {
      await db.execute("SELECT $columnTypeHistory from $tableHistory");
    } on DatabaseException {
      await db
          .execute('ALTER $tableHistory ADD COLUMN $columnTypeHistory TEXT');
      await db.execute(
          'UPDATE TABLE $tableHistory SET $columnTypeHistory="torrent"');
    }
  }

  Future<int> insert(
      {TorrentInfo torrentinfo = null,
      History history = null,
      SongdataWithUrl songdata = null}) async {
    Database dbClient = await db;
    int result = 0;
    if (torrentinfo != null) {
      result = await dbClient.insert(tableTorrentInfo, torrentinfo.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    try {
      if (history != null) {
        result = await dbClient.insert(tableHistory, history.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    } on DatabaseException {
      _onUpgrade(dbClient, 2, 3);
    }

    if (songdata != null) {
      result = await dbClient.insert(tableSongs, songdata.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    return result;
  }

  Future<List> queryAll({bool torrentinfo = false,
    bool history = false,
    bool song = false,
    String type = "torrent"}) async {
    Database dbClient = await db;
    var result;
    if (torrentinfo) {
      result = await dbClient.query(tableTorrentInfo);
    }
    if (history) {
      result = await dbClient
          .query(tableHistory, where: "type = ?", whereArgs: [type]);
    }
    if (song) {
      result = await dbClient.query(tableSongs);
    }
    return result.toList();
  }

  Future<int> delete(String name,
      {bool torrentinfo = false,
        bool history = false,
        bool song = false}) async {
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
    if (song) {
      count = await dbClient
          .delete(tableSongs, where: '$columnsongid = ?', whereArgs: [name]);
    }

    return count;
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}

class History {
  String searchHistory;
  String type;

  History(String searchHistory, {this.type = "torrent"}) {
    this.searchHistory = searchHistory;
  }

  Map<String, dynamic> toMap() =>
      <String, dynamic>{'search': this.searchHistory, 'type': this.type};

  factory History.fromMap(Map<String, dynamic> json) {
    return History(
      json['search'] as String,
      type: json['type'] as String,
    );
  }
}
