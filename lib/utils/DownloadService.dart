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

import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadService {
  static List<TaskInfo> _tasks = [];
  static String _localPath = "";
  static StreamController _streamController =
      StreamController<TaskInfo>.broadcast();
  static MethodChannel platform = const MethodChannel('flutter.native/helper');
  static bool isApi29;
  static String downloadString;

  static void addTask(TaskInfo task) {
    _tasks.add(task);
  }

  static List<TaskInfo> get tasks => _tasks;
  static void loadTasks(List<DownloadTask> list) {
    _tasks = list
        .map((e) => TaskInfo(
            name: e.filename,
            link: e.url,
            taskId: e.taskId,
            progress: e.progress,
            status: e.status))
        .toList();
  }

  static void clearTasks() async {
    _tasks.forEach((e) {
      delete(e, shouldDeleteContent: false);
    });
  }

  static Stream get stream => _streamController.stream;

  static Stream<TaskInfo> updateData(
      String id, DownloadTaskStatus status, int progress) {
    var task = _tasks?.firstWhere((task) => task.taskId == id);
    if (task != null) {
      task.status = status;
      task.progress = progress;
    }
    if (task.status == DownloadTaskStatus.failed) {
      delete(task, shouldDeleteContent: true);
    }
    _streamController.add(task);
  }

  static set localPath(String path) {
    _localPath = path;
  }

  static String get localPath => _localPath;

  static Future<String> requestDownload(TaskInfo task) async {
    if (!isApi29) {
      if (!await Permission.storage.isGranted) {
        return "Give Storage permission to Download Song";
      }
    }
    if (_localPath == "") {
      _localPath = await platform.invokeMethod("getDownloadDirectory");
    }
    if (checkIfDownloading(task.link)) {
      return "Already Downloading/Paused";
    }
    if (await isExist(task.name)) {
      return "Already Downloaded to Internal/Music";
    }

    task.taskId = await FlutterDownloader.enqueue(
        url: task.link,
        headers: {"auth": "test"},
        savedDir: _localPath,
        showNotification: true,
        fileName: task.name,
        openFileFromNotification: !isApi29);
    _tasks.insert(0, task);
    return "Downloading to Internal/Music";
  }

  static void cancelDownload(TaskInfo task) async {
    await FlutterDownloader.cancel(taskId: task.taskId);
    _tasks.remove(task);
    _streamController.add(task);
  }

  static void pauseDownload(TaskInfo task) async {
    await FlutterDownloader.pause(taskId: task.taskId);
    _streamController.add(task);
  }

  static void resumeDownload(TaskInfo task) async {
    String newTaskId = await FlutterDownloader.resume(taskId: task.taskId);
    task.taskId = newTaskId;
    _tasks.remove(task);
    _tasks.insert(0, task);
  }

  static void retryDownload(TaskInfo task) async {
    String newTaskId = await FlutterDownloader.retry(taskId: task.taskId);
    task.taskId = newTaskId;
    _tasks.remove(task);
    _tasks.add(task);
  }

  static Future<bool> openDownloadedFile(TaskInfo task) {
    return FlutterDownloader.open(taskId: task.taskId);
  }

  static void delete(TaskInfo task, {shouldDeleteContent = false}) async {
    await FlutterDownloader.remove(
        taskId: task.taskId, shouldDeleteContent: shouldDeleteContent);
    _tasks.remove(task);
    _streamController.add(task);
  }

  static Future<bool> isExist(String filename) async {
    if (isApi29) {
      return await platform.invokeMethod("isExist", {"filename": filename});
    }
    return File(_localPath + "/" + filename).existsSync();
  }

  static bool checkIfDownloading(String link) {
    TaskInfo task =
        _tasks?.firstWhere((task) => task.link == link, orElse: () => null);
    if (task == null) {
      return false;
    }

    if (task.status == DownloadTaskStatus.running ||
        task.status == DownloadTaskStatus.enqueued ||
        task.status == DownloadTaskStatus.paused) {
      return true;
    }
    return false;
  }

  static void dispose() {
    _streamController.close();
  }
}

class TaskInfo {
  final String name;
  final String link;

  String taskId;
  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;

  TaskInfo(
      {this.name,
      this.link,
      this.taskId,
      this.progress = 0,
      this.status = DownloadTaskStatus.undefined});
}
